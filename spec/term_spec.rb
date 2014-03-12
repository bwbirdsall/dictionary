require 'rspec'
require 'term'

describe Term do
  before do
    Term.clear
  end



  it 'makes an instance of Term' do
    new_term = Term.new("word", "descriptive phrase that is not actually a definition")
    new_term.should be_an_instance_of Term
  end

  it 'creates a Term and pushes that to an array of words' do
    new_term = Term.create("fun","something we like to have")
    new_term2 = Term.create('confusion', 'what we are currently experiencing')
    Term.all.should eq [new_term, new_term2]
  end

  describe '.clear' do
    it 'empties out all of the saved terms' do
      Term.create('lionwash','wash the lion')
      Term.clear
      Term.all.should eq []
    end
  end

  describe 'add_definition' do
    it 'adds a definition for a term' do
      new_term = Term.create("ostrich", "a large funny-looking bird that's bad at flying")
      new_term.add_definition("a surprisingly red meat")
      new_term.definitions.should eq ["a large funny-looking bird that's bad at flying", "a surprisingly red meat"]
    end
  end

  describe '.search' do
    it 'returns the term matching the inputted word' do
      new_term = Term.create('train', 'string of obedient freight-moving boxes')
      new_term2 = Term.create('car','metal box people mover')
      Term.search('car').should eq 1
    end
    it 'returns false if the inputted word is not in the dictionary' do
      new_term = Term.create('car','metal box people mover')
      Term.search('train').should eq nil
    end
  end



end
