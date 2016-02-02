class Array
  def eval_find
    self.each do |e|
      res = yield(e)
      return res if res
    end
    nil
  end
end

def get_next_words(root, words)
  Array(words).select do |word|
    (word.chars - root.chars).empty?
  end
end

def get_chain(word, words_by_length)
  r_get_chain(word, words_by_length, 0, [])
end

def r_get_chain(word, words_by_length, index, chain)
  chain[index] = word
  return chain[0..index] if word.length == 3
  next_words = get_next_words(word, words_by_length[word.length.pred])
  next_words.eval_find do |next_word|
    r_get_chain(next_word, words_by_length, index + 1, chain)
  end || nil
end

def make_length_buckets(words)
  words.each.with_object([]) do |w, o|
    o[w.length] ||= []
    o[w.length] << w
  end
end

words = File.readlines('wordlist').map(&:chomp)
words_by_length = make_length_buckets(words)

tree = words_by_length.reverse.eval_find do |words|
  Array(words).eval_find do |word|
    get_chain(word, words_by_length)
  end
end

puts tree.reverse
