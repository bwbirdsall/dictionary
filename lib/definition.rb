class Definition
  attr_reader :value, :language

  def initialize(definition_input, language)
    @value = definition_input
    @language = language
  end

  def set_value(new_definition)
    @value = new_definition
  end
end
