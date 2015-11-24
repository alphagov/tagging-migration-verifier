require 'spec_helper'
require_relative '../../lib/comparer'

RSpec.describe Comparer do
  describe '#same?' do
    it 'considers the ordering of links to be irrelevant' do
      a = { "MY-ITEM" => { "my_tag_name" => ["TAG-A", "TAG-B"] } }
      b = { "MY-ITEM" => { "my_tag_name" => ["TAG-B", "TAG-A"] } }

      compare = Comparer.new(a, b)

      expect(compare.same?).to eql(true)
    end

    it 'considers the ordering of items to be irrelevant' do
      a = { "A" => {}, "B" => {} }
      b = { "B" => {}, "A" => {} }

      compare = Comparer.new(a, b)

      expect(compare.same?).to eql(true)
    end

    it 'detects missing elements in the links hashes' do
      a = { "MY-ITEM" => { "my_tag_name" => ["TAG-A", "TAG-B"] } }
      b = { "MY-ITEM" => { "my_tag_name" => ["TAG-B"] } }

      compare = Comparer.new(a, b)

      expect(compare.same?).to eql(false)
    end
  end
end
