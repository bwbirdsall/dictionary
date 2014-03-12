require 'rspec'
require 'definition'

describe Definition do

  it 'stores the word and the language it belongs to' do
    test_definition = Definition.new('a delicious treat','english')
    test_definition.should be_an_instance_of Definition
  end

  it 'returns the definition value stored' do
    test_definition = Definition.new('a delicious treat','english')
    test_definition.value.should eq 'a delicious treat'
  end

  it 'returns the language stored' do
    test_definition = Definition.new('a delicious treat','english')
    test_definition.language.should eq 'english'
  end
end
