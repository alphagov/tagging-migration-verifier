require 'rest-client'
require 'retries'

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

    response = download_file(url)
    JSON.parse(response.body)
  end

  def self.download_file(url)
    with_retries(max_tries: 10, max_sleep_seconds: 10) do |attempt_number|
      puts "Downloading #{url}, attempt #{attempt_number}/10"
      RestClient.get(url)
    end
  rescue RestClient::Exception => e
    puts "Download of #{url}"
    puts "Exception: #{e.class}"
    puts "Message:\n\n#{e.inspect}"
    exit(1)
  end
end
