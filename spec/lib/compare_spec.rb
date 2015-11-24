require 'spec_helper'

RSpec.describe Compare do
  describe '#compare' do
    it 'considers the ordering of links to be irrelevant' do
      a = { "MY-ITEM" => { "my_tag_name" => ["TAG-A", "TAG-B"] } }
      b = { "MY-ITEM" => { "my_tag_name" => ["TAG-B", "TAG-A"] } }

      compare = Compare.new(a, b)

      expect(compare.same?).to eql(true)
    end

    it 'considers the ordering of items to be irrelevant' do
      a = { "A" => {}, "B" => {} }
      b = { "B" => {}, "A" => {} }

      compare = Compare.new(a, b)

      expect(compare.same?).to eql(true)
    end

    it 'detects missing elements in the links hashes' do
      a = { "MY-ITEM" => { "my_tag_name" => ["TAG-A", "TAG-B"] } }
      b = { "MY-ITEM" => { "my_tag_name" => ["TAG-B"] } }

      compare = Compare.new(a, b)

      expect(compare.same?).to eql(false)
    end
  end
end
