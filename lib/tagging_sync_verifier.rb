require 'json'
require_relative '../lib/compare'
require_relative '../lib/download'

class TaggingSyncVerifier
  attr_reader :app_name

  def initialize(app_name)
    @app_name = app_name
  end

  def verify_taggings_are_in_sync
    comparison = Compare.new(
      Download.taggings_from('contentapi', app_name),
      Download.taggings_from('content-store', app_name)
    )

    if comparison.same?
      puts "Taggings for #{app_name} are in sync!"
      exit(0)
    else
      puts "Taggings for #{app_name} are not in sync!"
      puts comparison.diffs
      exit(1)
    end
  end
end
