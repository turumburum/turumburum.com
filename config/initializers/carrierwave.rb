CarrierWave.configure do |config|

  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')

  case Rails.env.to_sym

  when :development
    config.storage = :file
    config.root = File.join(Rails.root, 'public')

  when :production
    # the following configuration works for Amazon S3
    config.storage          = :fog
    config.fog_credentials  = {
      :provider                 => 'AWS',
      :aws_access_key_id        => "AKIAJQ4SF2VONM7BZEDQ", #ENV['S3_KEY_ID'],
      :aws_secret_access_key    => "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", #ENV['S3_SECRET_KEY'],
      :region                   => "eu-west-1", #ENV['S3_BUCKET_REGION']
    }
    config.fog_directory    = "new-turum"#ENV['S3_BUCKET']

  else
    # settings for the local filesystem
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
  end

end