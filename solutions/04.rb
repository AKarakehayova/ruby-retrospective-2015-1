class Card
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def to_s
   "#{rank.to_s.capitalize} of #{suit.capitalize}"
  end

  def ==(another_card)
    @rank == another_card.rank && @suit == another_card.suit
  end
end

class Deck
  include Enumerable
  def standard_deck
    deck = Array.new
    ranks = %w{2 3 4 5 6 7 8 9 10 :jack :queen :king :ace}
    suits = %w{:spades :heart :diamonds :clubs}
    suits.each do |suit|
      ranks.each do |rank|
      deck << Card.new(rank, suit)
      end
    end
    deck
  end


  def initialize(array_of_cards = standard_deck)
    @deck = array_of_cards
  end

  def each
    @deck.each { |card| yield card}
  end

  def size
    @deck.length
  end

  def draw_top_card
    @deck.slice!(0)
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def shuffle
    @deck.shuffle!
  end

  def to_s
    @deck.each{|card| card.to_s + "\n"}
  end

  def deal
    @deck.slice!(0,26)
  end
end

class WarDeck < Deck
  def standard_deck
    deck = Array.new
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    suits = [:spades, :heart, :diamonds, :clubs]
    suits.each do |suit|
      ranks.each do |rank|
      deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def initialize(array_of_cards = standard_deck)
    @deck = array_of_cards
  end

  def deal
    array = @deck.slice!(0,26)
    Hand.new(array)
  end

  def sort
    rank = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    suit = [:spades, :hearts, :queen, :jack]
    @deck.sort_by!{|a| [rank.index(a.rank), suit.index(a.suit)].reverse}
  end

end

class BeloteDeck < Deck
  def standard_deck
    deck = Array.new
    ranks = [7, 8, 9, 10, :jack, :queen, :king, :ace]
    suits = [:spades, :hearts, :diamonds, :clubs]
    suits.each do |suit|
      ranks.each do |rank|
        deck << Card.new(rank, suit)
    end
  end
  deck
  end

  def initialize(array_of_cards = standard_deck)
    @deck = array_of_cards
  end

  def deal
    array = @deck.slice!(0,8)
    BeloteHand.new(array)
  end

  def sort
    rank = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
    suit = [:spades, :hearts, :diamonds, :clubs]
    @deck.sort_by!{|a| [rank.index(a.rank), suit.index(a.suit)].reverse}
  end
end

class SixtySixDeck < Deck
 def standard_deck
    deck = Array.new
    ranks = [9, 10, :jack, :queen, :king, :ace]
    suits = [:spades, :hearts, :diamonds, :clubs]
    suits.each do |suit|
      ranks.each do |rank|
        deck << Card.new(rank, suit)
    end
  end
  deck
  end

  def initialize(array_of_cards = standard_deck)
    @deck = array_of_cards
  end

  def deal
    cards = @deck.slice!(0,6)
    Hand.new(cards)
  end

  def sort
    rank = [:ace, 10, :king, :queen, :jack, 9]
    suit = [:spades, :hearts, :diamonds, :clubs]
    @deck.sort_by!{|a| [rank.index(a.rank), suit.index(a.suit)].reverse}
  end
end

class Hand < Deck
  def initialize(array)
    @hand = array
  end


  def play_card
    @hand.pop
  end

  def allow_face_up?
    @hand.size <= 3
  end


  def twenty?(trump_suit)
    suits = [:spades, :hearts, :diamonds, :clubs]
    suits.delete(trump_suit)
    twenty_help(suits)
  end

  def twenty_help(array_of_suits)
    count, found = 0, false
    while count < 3
      king = @hand.include?(Card.new(:king, array_of_suits[count]))
      queen = @hand.include?(Card.new(:queen, array_of_suits[count]))
      if king and queen
        found = true
      end
      count += 1
    end
    found
  end


  def size
    @hand.length
  end

  def forty?(trump_suit)
    king = @hand.include?(Card.new(:king, trump_suit))
    queen = @hand.include?(Card.new(:queen, trump_suit))
    king and queen
  end
end

class BeloteHand < BeloteDeck
  def initialize(array)
    @hand = array
  end

  def highest_of_suit(suit)
    deck = Array.new
    ranks = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
    @hand.sort_by! {|card| ranks.index(card.rank)}
    @hand.each do |card|
    if card.suit == suit
    deck << card
    end
    end
    deck.first
  end

  def belote?
    suits = [:spades, :hearts, :diamonds, :clubs]
    belote_help(suits)
  end

  def belote_help(array_of_suits)
    count, found = 0, false
    while count < 4
      king = @hand.include?(Card.new(:king, array_of_suits[count]))
      queen = @hand.include?(Card.new(:queen, array_of_suits[count]))
      if king and queen
       found = true
      end
      count += 1
    end
    found
  end

  def help(number)
    deck = tierce_help
    found, first, second = false, [], []
    deck.each_cons(number) do |cards| first << cards
    end
    @hand.each_cons(number) do |other_cards| second << other_cards
    end
    if first & second != []
      found = true
    end
    found
  end

  def tierce?
    help(3)
  end

  def quarte?
    help(4)
  end

  def quint?
    help(5)
  end

  def tierce_help
    deck = Array.new
    rank = [7, 8, 9, :jack, :queen, :king, 10, :ace]
    suit = [:spades, :hearts, :diamonds, :clubs]
    suit.each do |suit|
      rank.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def carre?(rank)
    spade = @hand.include?(Card.new(rank, :spades))
    heart = @hand.include?(Card.new(rank, :hearts))
    diamond = @hand.include?(Card.new(rank, :diamonds))
    club = @hand.include?(Card.new(rank, :clubs))
    spade and heart and diamond and club
  end

  def carre_of_jacks?
    carre?(:jack)
  end

  def carre_of_nines?
    carre?(9)
  end

  def carre_of_aces?
    carre?(:ace)
  end
end
