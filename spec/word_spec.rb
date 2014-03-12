require 'rspec'
require 'word'

describe Word do

  it 'stores the word and the language it belongs to' do
    test_word = Word.new('cookie','english')
    test_word.should be_an_instance_of Word
  end

  it 'returns the word value stored' do
    test_word = Word.new('cookie','english')
    test_word.value.should eq 'cookie'
  end

  it 'returns the language stored' do
    test_word = Word.new('cookie','english')
    test_word.language.should eq 'english'
  end
end
