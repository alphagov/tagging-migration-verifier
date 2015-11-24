class Compare
  attr_reader :a, :b

  def initialize(a, b)
    @a = prepare(a)
    @b = prepare(b)
  end

  def same?
    only_a.empty? && only_b.empty?
  end

  def diffs
    {
      only_a: only_a,
      only_b: only_b,
    }
  end

private

  def only_a
    a - b
  end

  def only_b
    b - a
  end

  def prepare(hash)
    hash.each do |content_id, links_hash|
      links_hash.each do |tag_name, link_ids|
        links_hash[tag_name] = link_ids.sort
      end
    end.to_a
  end
end
