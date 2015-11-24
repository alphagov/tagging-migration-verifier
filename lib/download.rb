class Download
  # In tasks run by Jenkins, APP_DOMAIN will be available and point to the
  # preview/staging/production domains.
  APP_DOMAIN = ENV['APP_DOMAIN'] || "dev.gov.uk"
  SCHEME = ENV['APP_DOMAIN'] ? "https" : "http"

  def self.taggings_from(service, app_name)
    url = "#{SCHEME}://#{service}.#{APP_DOMAIN}/debug/taggings-per-app.json?app=#{app_name}"
    puts url
    JSON.parse(`curl -s #{url}`)
  rescue JSON::ParserError
    puts "Error running the verifier. Probably a connection error occured."
    exit(1)
  end
end
