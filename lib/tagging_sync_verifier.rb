require 'json'
require_relative '../lib/comparer'
require_relative '../lib/download'

class TaggingSyncVerifier
  attr_reader :app_name, :output, :error

  def initialize(app_name)
    @app_name = app_name
    @output = []
    @error = false
  end

  def verify_taggings_are_in_sync
    @output << "Checking #{app_name}"

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

    only_in_content_api = comparison.diffs[:only_a]
    only_in_content_store = comparison.diffs[:only_b].select { |content_id, _| from_content_api.key?(content_id) }

    if only_in_content_api.empty? && only_in_content_store.empty?
      @output << "Taggings are in sync!"
    else
      @error = true
      @output << "Taggings are not in sync!"

      only_in_content_api.each do |content_id, tags|
        @output << "#{content_id} has the following tags in content-api:"
        @output << tags
      end

      only_in_content_store.each do |content_id, tags|
        @output << "#{content_id} has the following tags in content-store:"
        @output << tags
      end
    end
  end
end
