class Word
  attr_reader :value, :language

  def initialize(word_input, language)
    @value = word_input
    @language = language
  end

end
