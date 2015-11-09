class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word, guesses = '', wrong_guesses = '')
    @word = word
    @guesses = guesses
    @wrong_guesses = wrong_guesses
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
	raise ArgumentError if letter.nil?
	raise ArgumentError if letter.empty?
	raise ArgumentError if /.*[^a-zA-Z]+.*/.match(letter).nil? == false
	guessarray = self.guesses + self.wrong_guesses
	if guessarray.downcase.include? letter.downcase
		return false
	else
		if /.*#{letter}+.*/i.match(word).nil? == true
			self.wrong_guesses << letter
			return letter
		else
			self.guesses << letter
			return letter
		end
	end
  end

  def word_with_guesses
	displayed = word
	displayed.each_char{ |let| 
		unless self.guesses.include? let
			displayed = displayed.gsub(let){|rep_let| '-'}
		end
	}
	return displayed
  end


  def check_win_or_lose

	if self.wrong_guesses.length >=7
		return :lose
	elsif self.guesses.empty?
		return :play
	elsif /^[#{self.guesses}]+$/i.match(word).nil? == false
		return :win
	else
		return :play
	end
  end
end
