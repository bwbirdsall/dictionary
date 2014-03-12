class Term
  attr_reader :words, :definitions

  @@all_terms = []

  def initialize(word, definition)
    @words = []
    @words << word
    @definitions = []
    @definitions << definition
  end

  def Term.create(word, definition)
    new_term = Term.new(word, definition)
    new_term.save
    new_term
  end

  def save
    @@all_terms << self
  end

  def Term.all
    @@all_terms
  end

  def Term.clear
    @@all_terms = []
  end

  def Term.search(search_word)
    results = nil
    Term.all.each_with_index do |term, index|
      if term.words.index { |word| word == search_word } != nil
        results = index
      end
    end
    results
  end

  def add_definition(new_def)
    @definitions << new_def
  end
end
