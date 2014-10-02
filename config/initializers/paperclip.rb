if Rails.env.production?
  @@aws_bucket_id = ENV['AMAZON_BUCKET_ID']
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']

  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = { :access_key_id => @@access_key_id, :secret_access_key => @@secret_access_key}
  Paperclip::Attachment.default_options[:bucket] = @@aws_bucket_id
end
