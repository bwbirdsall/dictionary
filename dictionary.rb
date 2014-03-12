require './lib/term'
require './lib/word'
require './lib/definition'

@language = "english"

def add_word
  system('clear')
  header
  puts 'Enter a new word: '
  word = gets.chomp
  puts 'What language is the word?'
  language = gets.chomp.downcase
  new_word = Word.new(word, language)
  print "Enter the definition for '#{word}': "
  definition = gets.chomp
  new_definition = Definition.new(definition, language)
  new_term = Term.create(new_word, new_definition)
  main_menu
end

def main_menu
  system('clear')
  header
  puts "Welcome to the dictionary. You are currently working in the #{@language} language.\nEnter 'l' to list the words, 'n' to add a new word, 'e' to edit a word, 'd' to delete a word, 's' to search for a word, 'c' to change language, or 'x' to exit."
  user_command = gets.chomp
  case user_command
  when 'l'
    menu_list
  when 'n'
    add_word
  when 'e'
    edit_menu
  when 'd'
    delete_word
  when 's'
    search_words
  when 'c'
    change_language
  when 'x'
    print "Thank you for using DICTIONARY; have a nice day.\n"
  else
    print "Invalid input. Please try again, and do better."
    main_menu
  end
end

def start_language
  system('clear')
  header
  puts "What language would you like to use DICTIONARY in?"
  initial_language = gets.chomp.downcase
  @language = initial_language
  main_menu
end

def change_language
  system('clear')
  header
  puts "Here is a list of languages currently in the DICTIONARY:"
  lang_list = []
  Term.all.each do |term|
    term.words.each do |word|
      if lang_list.include?(word.language) == false
        lang_list << word.language
      end
    end
  end
  lang_list.sort!
  puts lang_list.join(", ")
  puts "What language would you like to use? \n(Be aware that all DICTIONARY prompts will remain in english, as this program is very provincial in its worldview.)"
  new_lang = gets.chomp.downcase
  @language = new_lang
  main_menu
end

def list_words
  term_counter = 1
  print "#{term_counter}: "
  Term.all.each do |term|
    word_counter = 0
    term.words.each do |word|
      if(word.language == @language)
        if word_counter == 0
          print "#{word.value}"
        else
          print ", #{word.value}"
        end
        word_counter += 1
      end
    end
    if word_counter > 0
      term_counter += 1
      print "\n#{term_counter}: "
    end
  end
  print "\b\b\b\b\b\b\b"
end

def menu_list
  system('clear')
  header
  puts "Here are all of the words that exist:"
  list_words
  puts "Enter the number of the word you would like to see the definition for, or 'm' to return to the main menu."
  list_choice = gets.chomp
  case list_choice
  when /\d/

    Term.all[list_choice.to_i - 1].words.each do |word|
      word_counter = 0
      if word.language == @language
        if word_counter == 0
          print "#{word.value}"
        else
          print ", #{word.value}"
        end
        word_counter += 1
      end
    end
    print "\n"

    definition_counter = 1
    definition_counter_index_hash = {}
    Term.all[list_choice.to_i - 1].definitions.each_with_index do |definition, index|
      # puts "#{definition.value} - #{definition.language} #{@language}"

      if definition.language == @language
        puts "\t#{definition_counter}: #{definition.value}"
        definition_counter_index_hash[definition_counter] = index
        definition_counter += 1
      end
    end
    puts "Enter a definition number to edit the definition, 'l' to return to the list of words, or 'm' to return to the main menu."
    menu_choice = gets.chomp
    case menu_choice
    when /\d/
      edit_definition((list_choice.to_i - 1), definition_counter_index_hash[menu_choice.to_i])
    when 'l'
      menu_list
    when 'm'
      main_menu
    else
      puts "Invalid choice. Try again."
      menu_list
    end
  when 'm'
    main_menu
  else
    puts "Invalid choice. Try again."
    menu_list
  end
end

def edit_menu
  system('clear')
  header
  list_words
  puts "Enter the number of the word you wish to edit."
  term_choice = gets.chomp.to_i - 1
  puts "Enter 'w' to add additional words', 'd' to edit definitions."
  word_or_def = gets.chomp
  case word_or_def
  when 'w'
    system('clear')
    header

    Term.all[term_choice].words.each_with_index do |word, i|
      puts "#{word.value}, language: #{word.language}"
    end
    puts "\nAdd another word in another language. What is the word?"
    language_word = gets.chomp
    puts "What is the language?"
    language_language = gets.chomp
    new_word = Word.new(language_word, language_language)
    Term.all[term_choice].words << new_word
    menu_list
  when 'd'
    system('clear')
    header
    puts "The term's current definitions are:"
    definition_counter = 1
    definition_counter_index_hash = {}
    Term.all[term_choice].definitions.each_with_index do |definition, index|
      if definition.language == @language
        puts "\t#{definition_counter}: #{definition.value}"
        definition_counter_index_hash[definition_counter] = index
        definition_counter += 1
      end
    end
    puts "Enter the number of the definition you want to edit or 'n' to add a definition."
    def_choice = gets.chomp
    case def_choice
    when /\d/
      edit_definition(term_choice, definition_counter_index_hash[def_choice.to_i - 1])
    when 'n'
      puts "What definition would you like to add?"
      new_def_value = gets.chomp
      puts "What language is this definition?"
      new_def_lang = gets.chomp
      new_def = Definition.new(new_def_value, new_def_lang)
      Term.all[term_choice].add_definition(new_def)
      main_menu
    else
      puts "Invalid choice. Please try again."
      edit_menu
    end
  else
    edit_menu
  end
end

def edit_definition(term_index, def_index)
  puts "#{term_index}a #{def_index}b"
  puts "\nThe term's current definition is: '#{Term.all[term_index.to_i].definitions[def_index.to_i].value}'. What would you like to change its definition to?"
  new_definition = gets.chomp
  Term.all[term_index].definitions[def_index].set_value(new_definition)
  main_menu
end

def delete_word
  system('clear')
  header
  list_words
  #move list words functionality here to generate hash for list index.
  puts "Enter the number of the word you wish to delete."
  term_index = gets.chomp.to_i - 1
  print "Are you sure you wish to delete '"
  Term.all[term_index].words.each_with_index do |word, i|
    if i > 0
      print ", #{word.value}"
    else
      print "#{word.value}"
    end
  end
  print "? y/n\n"
  confirmation = gets.chomp
  if confirmation == 'y'
    Term.all.delete_at(term_index)
  end
  main_menu
end

def search_words
  puts "What term are you looking for?"
  search_word = gets.chomp
  if Term.search(search_word) == nil
    puts "No matches found.\n Enter 's' to search again, or 'm' to return to main menu"
    menu_choice = gets.chomp
    case menu_choice
    when 's'
      search_words
    else
      main_menu
    end
  else
    Term.all[Term.search(search_word)].words.each_with_index do |word, i|
      if i > 0
        print ", #{word.value} language: #{word.language}"
      else
        print "#{word.value} language: #{word.language}"
      end
    end
    print ": \n"
    Term.all[Term.search(search_word)].definitions.each_with_index do |definition, index|
      puts "\t#{index + 1}: #{definition}"
    end
    puts "Enter 'e' to edit this word, or 'm' to return to main menu"
    puts "Note: this searches all languages, but to edit words you must be in their language."
    menu_choice = gets.chomp
    case menu_choice
    when 'e'
      puts "Which definition would you like to edit?"
      def_index = gets.chomp.to_i - 1
      edit_definition(Term.search(search_word), def_index)
    else
      main_menu
    end
  end
end

def header
  print "************\n*DICTIONARY*\n************\n\n"
end

start_language
