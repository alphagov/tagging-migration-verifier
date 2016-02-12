require 'json'
require 'ap'
require_relative '../lib/comparer'
require_relative '../lib/download'

class TaggingSyncVerifier
  attr_reader :app_name

  def initialize(app_name)
    @app_name = app_name
  end

  def verify_taggings_are_in_sync
    puts "\n\nChecking #{app_name}"

    comparison = Comparer.new(
      Download.taggings_from('contentapi', app_name),
      Download.taggings_from('content-store', app_name)
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
