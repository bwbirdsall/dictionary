require 'rspec'
require 'term'
require 'word'
require 'definition'

describe Term do
  before do
    Term.clear
  end

  it 'makes an instance of Term' do
    new_word = Word.new("cookie", "english")
    new_definition = Definition.new("a delicious treat", "english")
    new_term = Term.new(new_word, new_definition)
    new_term.should be_an_instance_of Term
  end

  it 'creates a Term and pushes that to an array of words' do
    new_word = Word.new("cookie", "english")
    new_definition = Definition.new("a delicious treat", "english")
    new_term = Term.create(new_word, new_definition)
    Term.all.should eq [new_term]
  end

  describe '.clear' do
    it 'empties out all of the saved terms' do
      new_word = Word.new("cookie", "english")
      new_definition = Definition.new("a delicious treat", "english")
      Term.create(new_word, new_definition)
      Term.clear
      Term.all.should eq []
    end
  end

  describe 'add_definition' do
    it 'adds a definition for a term' do
      new_word = Word.new("cookie", "english")
      new_definition = Definition.new("a delicious treat", "english")
      new_term = Term.create(new_word, new_definition)
      second_definition = Definition.new("a baked confection consisting of sweets", "english")
      new_term.add_definition(second_definition)
      new_term.definitions.should eq [new_definition, second_definition]
    end
  end

  describe '.search' do
    it 'returns the term matching the inputted word' do
      new_word = Word.new("cookie", "english")
      new_definition = Definition.new("a delicious treat", "english")
      new_word2 = Word.new("car", "english")
      new_definition2 = Definition.new("metal box powered by gasoline", "english")
      term1 = Term.create(new_word, new_definition)
      term2 = Term.create(new_word2, new_definition2)

      Term.search('cookie').should eq 0
    end

  end



end
