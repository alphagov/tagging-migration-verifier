class Download
  def self.taggings_from(service, app_name)
    # In tasks run by Jenkins, GOVUK_APP_DOMAIN will be available and point to the
    # preview/staging/production domains.
    if ENV['GOVUK_APP_DOMAIN']
      host = "https://#{service}.#{ENV['GOVUK_APP_DOMAIN']}"
    else
      host = "http://#{service}.dev.gov.uk"
    end

    url = "#{host}/debug/taggings-per-app.json?app=#{app_name}"
    JSON.parse(`curl -s #{url}`)
  rescue JSON::ParserError
    puts "Error running the verifier. Probably a connection error occured."
    exit(1)
  end
end
