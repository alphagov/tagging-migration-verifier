require 'json'
require 'awesome_print'
require_relative '../lib/comparer'
require_relative '../lib/download'

class TaggingSyncVerifier
  attr_reader :app_name

  def initialize(app_name)
    @app_name = app_name
  end

  def verify_taggings_are_in_sync
    puts "\n\nChecking #{app_name}"

    from_content_api = Download.taggings_from('contentapi', app_name)
    from_content_store = Download.taggings_from('content-store', app_name)

    if app_name == 'travel-advice-publisher'
      from_content_store.each do |content_id, links|
        from_content_store[content_id].delete('parent')
      end

      from_content_api.each do |content_id, links|
        from_content_api[content_id].delete('parent')
      end
    end

    comparison = Comparer.new(
      from_content_api,
      from_content_store
    )

    if comparison.same?
      puts "Taggings are in sync!"
    else
      puts "** Taggings are not in sync! **"

      comparison.diffs[:only_a].each do |content_id, tags|
        puts "#{content_id} has the following tags in content-api:"
        ap tags
      end

      comparison.diffs[:only_b].each do |content_id, tags|
        puts "#{content_id} has the following tags in content-store:"
        ap tags
      end

      exit(1)
    end
  end
end
