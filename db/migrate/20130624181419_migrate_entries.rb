module Locomotive
    class ContentType
      def ensure_class_name_security(field)
      end
    end
end

class MigrateEntries < Mongoid::Migration
  def self.up
    ua = Locomotive::Site.where(subdomain: "ua").first
    ru = Locomotive::Site.where(subdomain: "ru").first

    saved_ct_names = {}
    cts = []
    Locomotive::ContentType.where(site_id: ua.id).entries.each do |t|
      #t2 = t.clone
      #t2.site = ru

      #saved_ct_names[t.id.to_s] = t2.id.to_s
      #t2.slug = t2.slug + "_ru"
      t2 = Locomotive::ContentType.new
      h = t.as_json
      h.delete("id")
      h.delete("_id")
      t2.from_presenter(h)
      t2.site = ru
      t2.slug = t2.slug + "_ru"
      saved_ct_names[t.id.to_s] = t2.id.to_s
      cts << t2
      
    end

    ct1 = []
    ct2 = []
    cts.each do |ct|
      flag = false
      ct.entries_custom_fields.each_with_index do |f,i|

        if f.class_name.present?
          id = f.class_name.scan(/Locomotive::ContentEntry(.*)$/).flatten.first
          if id
            ct.entries_custom_fields[i].class_name = f.class_name.gsub(/#{id}/, saved_ct_names[id])
            flag = true
          end
        end

      end if ct.entries_custom_fields
      if flag 
        ct2 << ct
      else
        ct1 << ct
      end
    end
    #ct1.each do |ct| 
      #ct.save rescue next
    #end

    #ct2.each do |ct| 
      #ct.save rescue next
    #end

    1.upto(10) do
      ct1.each do |ct| 
        next unless ct.changed?
        begin
          if !ct.save
            p "CT Error", ct.id, ct.errors, "-"*80
          end
        rescue
          next
        end
      end
    end

    1.upto(10) do
      ct2.each do |ct| 
        next unless ct.changed?
        begin
          if !ct.save
            p "CT Error", ct.id, ct.errors, "-"*80
          end
        rescue 
          next
        end
      end
    end

    processed_entries = []
    entries_map = {}

    Locomotive::ContentEntry.where(site_id: ua.id).entries.each do |e|
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
        p "CE Error", e2.id, e2.errors, "-"*80
      else
        processed_entries << e.id
        entries_map[e.id] = e2.id
      end
    end
    Locomotive::ContentEntry.where(site_id: ua.id).entries.each do |e|
      next unless e
      next if processed_entries.include? e.id
      next if e.content_type && e.content_type.site.id == ru.id

      p "----------"
      e2 = e.clone

      e2._slug = e2._slug + "_ru"
      e2.site = ru
      e2.content_type = Locomotive::ContentType.where(name: e.content_type.name).where(site_id: ru.id).first if e.content_type

      e2._type = "Locomotive::ContentEntry" + e2.content_type.id.to_s

      projects = e2.project_ids rescue []
      if projects.any?
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
        p "CE2 Error", e2.id, e2.errors, "-"*80
      else
        processed_entries << e.id
        entries_map[e.id] = e2.id
      end
    end


  end

  def self.down
    ua = Locomotive::Site.where(subdomain: "ua").first
    ru = Locomotive::Site.where(subdomain: "ru").first

    p "CT"
    Locomotive::ContentType.delete_all(site_id: ru.id)
    sleep 0.5
    p "CE"
    Locomotive::ContentEntry.delete_all(site_id: ru.id)
  end
end