require './lib/term'

def add_word
  system('clear')
  header
  print 'Enter a new term: '
  word = gets.chomp
  print "Enter the definition for '#{word}': "
  definition = gets.chomp

  new_term = Term.create(word, definition)
  main_menu
end

def main_menu
  system('clear')
  header
  puts "Welcome to the dictionary. Enter 'l' to list the words, 'n' to add a new word, 'e' to edit a word, 'd' to delete a word, 's' to search for a word, or 'x' to exit."
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
  when 'x'
    print "Thank you for using DICTIONARY; have a nice day.\n"
  else
    print "Invalid input. Please try again, and do better."
    main_menu
  end
end

def list_words
  system('clear')
  header
  Term.all.each_with_index do |term, index|
    print "#{index + 1}: "
    term.words.each_with_index do |word, i|
      if i > 0
        print ", #{word}"
      else
        print "#{word}"
      end
    end
    print "\n"
  end
end

def menu_list
  system('clear')
  header
  puts "Here are all of the words that exist:"
  Term.all.each_with_index do |term, index|
    term.words.each_with_index do |word, i|
      if i > 0
        print ", #{word}"
      else
        print "#{index + 1}: #{word}"
      end
    end
    print "\n"
  end
  puts "Enter the number of the word you would like to see the definition for, or 'm' to return to the main menu."
  list_choice = gets.chomp
  case list_choice
  when /\d/

    Term.all[list_choice.to_i - 1].words.each_with_index do |word, i|
      if i > 0
        print ", #{word}"
      else
        print "#{word}"
      end
    end
    print "\n"

    Term.all[list_choice.to_i - 1].definitions.each_with_index do |definition, index|
      puts "\t#{index + 1}: #{definition}"
    end

    puts "Enter a definition number to edit the definition, 'l' to return to the list of words, or 'm' to return to the main menu."
    menu_choice = gets.chomp
    case menu_choice
    when /\d/
      edit_definition(list_choice.to_i - 1, menu_choice.to_i - 1)
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
      if i > 0
        print ", #{word}"
      else
        print "#{word}"
      end
    end
    puts "\nAdd another word in another language"
    language_word = gets.chomp
    Term.all[term_choice].words << language_word
    menu_list
  when 'd'
    system('clear')
    header
    puts "The term's current definitions are:"
    Term.all[term_choice].definitions.each_with_index do |definition, index|
      puts "\t#{index + 1}: #{definition}"
    end
    puts "Enter the number of the definition you want to edit or 'n' to add a definition."
    def_choice = gets.chomp
    case def_choice
    when /\d/
      edit_definition(term_choice, def_choice.to_i - 1)
    when 'n'
      print "What definition would you like to add to '"
      Term.all[term_choice].words.each_with_index do |word, i|
        if i > 0
          print ", #{word}"
        else
          print "#{word}"
        end
      end
      print "'?\n"
      Term.all[term_choice].add_definition(gets.chomp)
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
  puts "\nThe term's current definition is: '#{Term.all[term_index].definitions[def_index]}'. What would you like to change its definition to?"
  new_definition = gets.chomp
  Term.all[term_index].definitions[def_index] = new_definition
  main_menu
end

def delete_word
  system('clear')
  header
  list_words
  puts "Enter the number of the word you wish to delete."
  term_index = gets.chomp.to_i - 1
  print "Are you sure you wish to delete '"
  Term.all[term_index].words.each_with_index do |word, i|
    if i > 0
      print ", #{word}"
    else
      print "#{word}"
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
    puts "No matches found.\n Enter 's' to search again, or 'x' to return to main menu"
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
        print ", #{word}"
      else
        print "#{word}"
      end
    end
    print ": \n"
    Term.all[Term.search(search_word)].definitions.each_with_index do |definition, index|
      puts "\t#{index + 1}: #{definition}"
    end
    puts "Enter 'e' to edit this word, or 'x' to return to main menu"
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

add_word
