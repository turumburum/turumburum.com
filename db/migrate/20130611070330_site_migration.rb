module Locomotive
    class ContentType
      def ensure_class_name_security(field)
      end
    end
end

class SiteMigration < Mongoid::Migration
  def self.up
    ua = Locomotive::Site.where(subdomain: "ua").first
    ru = Locomotive::Site.where(subdomain: "ru").first

    Locomotive::ContentAsset.where(site_id: ua.id).each do |asset|
      a2 = asset.clone
      a2.site = ru
      a2.save
    end

    saved_ct_names = {}
    cts = []
    Locomotive::ContentType.where(site_id: ua.id).each do |t|
      t2 = t.clone
      t2.site = ru

      saved_ct_names[t.id.to_s] = t2.id.to_s
      t2.slug = t2.slug + "_ru"
      cts << t2
      
    end

    ct1 = []
    ct2 = []
    cts.each do |ct|
      flag = false
      ct.entries_custom_fields.each_with_index do |f,i|

        if f.class_name.present?
          id = f.class_name.scan(/Locomotive::Entry(.*)$/).flatten.first
          ct.entries_custom_fields[i].class_name = f.class_name.gsub(/#{id}/, saved_ct_names[id])
          flag = true
        end

      end if ct.entries_custom_fields
      if flag 
        ct2 << ct
      else
        ct1 << ct
      end
    end
    ct1.each{|ct| ct.save}
    ct2.each{|ct| ct.save}

    processed_entries = []
    entries_map = {}

    Locomotive::ContentEntry.where(site_id: ua.id).each do |e|
      next unless e
      next if processed_entries.include? e.id
      next if e.content_type && e.content_type.site.id == ru.id
      next if (e.project_ids rescue []).any?
      next if (e.branch_ids rescue []).any?
      e2 = e.clone

      e2._slug = e2._slug + "_ru"
      e2.site = ru
      #p "---->"
      #p Locomotive::ContentType.where(name: e.content_type.name).where(site_id: ru.id).first
      e2.content_type = Locomotive::ContentType.where(name: e.content_type.name).where(site_id: ru.id).first if e.content_type

      e2._type = "Locomotive::ContentEntry" + e2.content_type.id.to_s

      if !e2.save
        p "Error", e2.id, e2.errors, "-"*80
      else
        processed_entries << e.id
        entries_map[e.id] = e2.id
      end
    end
    Locomotive::ContentEntry.where(site_id: ua.id).each do |e|
      next unless e
      next if processed_entries.include? e.id
      next if e.content_type && e.content_type.site.id == ru.id
      next if (e.project_ids rescue []).any?
      next if (e.branch_ids rescue []).any?

      e2 = e.clone

      e2._slug = e2._slug + "ru"
      e2.site = ru
      e2.content_type = Locomotive::ContentType.where(name: e.content_type.name).where(site_id: ru.id).first if e.content_type

      projects = e2.project_ids rescue []
      if p.any?
        new_p = []
        projects.each do |p|
          next unless entries_map[p]
          new_p << entries_map[p]
        end
        e2.project_ids = new_p
      end

      branches = e2.branch_ids rescue []
      if branches.any?
        new_b = []
        branches.each do |b|
          next unless entries_map[b]
          new_b << entries_map[b]
        end
        e2.branch_ids = new_b
      end

      if !e2.save
        p "Error", e2.id, e2.errors, "-"*80
      else
        processed_entries << e.id
        entries_map[e.id] = e2.id
      end
    end

    Locomotive::ThemeAsset.where(site_id: ua.id).each do |a|
      next unless a
      a2 = a.clone
      a2.site = ru
      #remove validation for production
      #a2.save(validate: false)
      a2.save(validate: false)
    end


    saved_pages_ids = {}
    saved_pages = []


    Locomotive::Page.where(site_id: ua.id).each do |p|
      next unless p
      p2 = p.clone
      p2.site = ru
      p2.save(validate: false)
      saved_pages_ids[p.id] = p2.id
      saved_pages << p2
    end
    saved_pages.each do |p|
      p.parent_id = saved_pages_ids[p.parent_id] if p.parent_id
      p.parent_ids = [saved_pages_ids[p.parent_ids.first]] if p.parent_ids.any?
      p.save(validate: false)
    end

  end

  def self.down
    ua = Locomotive::Site.where(subdomain: "ua").first
    ru = Locomotive::Site.where(subdomain: "ru").first

    Locomotive::ContentAsset.delete_all(site_id: ru.id)
    Locomotive::ContentType.delete_all(site_id: ru.id)
    Locomotive::ContentEntry.delete_all(site_id: ru.id)
    Locomotive::ThemeAsset.delete_all(site_id: ru.id)
    Locomotive::Page.delete_all(site_id: ru.id)
  end
end