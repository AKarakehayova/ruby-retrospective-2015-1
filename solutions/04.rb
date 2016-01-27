class Card
  SUITS = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  attr_reader :rank, :suit
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
   "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
  end

  def ==(another_card)
    @rank == another_card.rank && @suit == another_card.suit
  end
end

module DeckModule
  include Enumerable

  def each
    deck.each {|card| yield card}
  end

  def size
    deck.length
  end

  def draw_top_card
    deck.slice!(0)
  end

  def draw_bottom_card
    deck.pop
  end

  def top_card
    deck.first
  end

  def bottom_card
    deck.last
  end

  def shuffle
    deck.shuffle!
  end

  def to_s
    deck.map(&:to_s).join("\n")
  end
end

class Deck
  include DeckModule

  def initialize(array_of_cards = nil)
    if array_of_cards
      @deck = array_of_cards
    else @deck = Card::SUITS.product(Card::RANKS).map do |suit, rank|
      Card.new(rank, suit)
      end
    end
  end

  def deck
    @deck
  end
end

class WarDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

  def initialize(array_of_cards = nil)
    if array_of_cards
      @deck = array_of_cards
    else @deck = SUITS.product(RANKS).map do |suit, rank|
      Card.new(rank, suit)
      end
    end
  end

  def deal
    hand_cards = []
    26.times do
      hand_cards << draw_top_card
    end
    Hand.new(hand_cards)
  end

  def sort
    rank = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    suit = [:spades, :hearts, :diamonds, :clubs]
    @deck.sort_by!{|a| [rank.index(a.rank), suit.index(a.suit)].reverse}
  end
end

class BeloteDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]

  def initialize(array_of_cards = nil)
    if array_of_cards
      @deck = array_of_cards
    else @deck = SUITS.product(RANKS).map do |suit, rank|
      Card.new(rank, suit)
      end
    end
  end

  def deal
    hand_cards = []
    8.times do
      hand_cards << draw_top_card
    end
    BeloteHand.new(hand_cards)
  end

  def sort
    rank = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
    suit = [:spades, :hearts, :diamonds, :clubs]
    @deck.sort_by!{|a| [rank.index(a.rank), suit.index(a.suit)].reverse}
  end

  def deck
    @deck
  end
end

class SixtySixDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [9, :jack, :queen, :king, 10, :ace]

   def initialize(array_of_cards = nil)
    if array_of_cards
      @deck = array_of_cards
    else @deck = SUITS.product(RANKS).map do |suit, rank|
      Card.new(rank, suit)
      end
    end
  end

  def deal
    hand_cards = []
    6.times do
      hand_cards << draw_top_card
    end
    Hand.new(hand_cards)
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
    @hand.select { |card| card.suit != trump_suit }.
    select { |card| card.rank == :king || card.rank == :queen }.
    group_by { |card| card.suit }.
    any? { |_, cards_of_same_suit| cards_of_same_suit.size == 2 }
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

  def deck
    @hand
  end

  def cards_by_suit(suit)
    @hand.select {|card| card.suit == suit}
  end

  def ranks_by_suit(suit)
    cards_by_suit(suit).map {|card| card.rank}
  end

  def highest_of_suit(suit)
    BeloteDeck.new(@hand.select { |card| card.suit == suit}).sort.first
  end

  def belote?
    @hand.select { |card| card.rank == :king || card.rank == :queen }.
        group_by { |card| card.suit }.
        any? { |_, same_suit_cards| same_suit_cards.size == 2 }
  end

   def consecutive? (length)
    Card::SUITS.any? do |suit|
      ranks = ranks_by_suit(suit)
      BeloteDeck::RANKS.each_cons(length).any? do |consecutive_ranks|
        (consecutive_ranks & ranks).size == length
      end
    end
  end

  def tierce?
    consecutive?(3)
  end

  def quarte?
    consecutive?(4)
  end

  def quint?
    consecutive?(5)
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
