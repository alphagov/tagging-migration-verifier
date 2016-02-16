require 'http'

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
    puts "Downloading #{url}"

    response = HTTP.get(url)
    unless response.code == 200
      puts "Error GET #{url}"
      puts "#{response.inspect}"
      puts "#{response}"
      exit(1)
    end

    JSON.parse(response.body)
  end
end
