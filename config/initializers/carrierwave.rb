CarrierWave.configure do |config|
  config.fog_provider = "fog/aws"
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_S3_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_S3_SECRET_ACCESS_KEY"],
    region: "us-east-2"
    #host: "s3.example.com"
    #endpoint: "https://s3.scample.com:8000"
  }
  config.fog_directory  = "artificial-gallery-image"
  config.fog_public     = true
  config.cache_storage = :fog
  #config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
