require_relative 'display.rb'
require_relative 'player.rb'
require_relative 'deck.rb'

class Game
    attr_reader :players, :deck, :display, :round_number
    attr_accessor :current_bet
    
    def initialize(players, display)
        @players = players
        @display = display
        @round_number = 0
        @current_bet = 0
    end

    def play 
        until game_over?
            new_round
            deal_starting_hands
            place_bets
            draw
            place_bets
            winners = showdown
            distribute_pot(winners)
        end
    end

    def game_over?
        players.one? { |player| player.money > 0 }
    end

    def new_round
        @players.rotate!
        @deck = Deck.new
        @players.each(&:new_round)
        @current_bet = 1
        @round_number += 1
        @display.round_number = @round_number
        @display.update_pot(pot)
    end

    def deal_starting_hands
        @players.each do |player|
            player.hand = Hand.new(deck.deal(5))
        end
    end

    def place_bets
        idx = 0
        final_bettor_idx = num_players - 1
        betting_over = false
        
        until betting_over
            player = @players[idx]
            unless player.folded?
                action, amount = player.take_action(@current_bet)
                case action
                when :see
                    see(player)
                when :raise_bet
                    raise_bet(player, amount)
                    final_bettor_idx = (idx + num_players - 1) % num_players
                when :fold
                    fold(player)
                end
            end
            
            if idx == final_bettor_idx
                betting_over = true
            else
                idx = (idx + 1) % num_players
            end
        end
    end

    def draw
        @players.each do |player|
            unless player.folded?
                num_discarded = player.discard_cards
                player.receive_cards(deck.deal(num_discarded))
            end
        end
    end
    
    def showdown
        ranked_players = remaining_players.sort { |a, b| a.hand <=> b.hand }
        winners = [ranked_players.first]
        ranked_players.each_with_index do |player, i|
            if i > 0 && winners.first.hand == player.hand
                winners << player
            end
        end
        winners
    end

    def distribute_pot(winners)
        if winners.size > 1
            split_pot(winners)
            str = winners.map { |winner| winner.name }.join(", ")
            str << " each win #{pot/winners.length}"
            display.add_message(str)
        else
            winners.first.money += pot
            display.add_message("#{winners.first.name} won $#{pot}!")
        end
    end
    def split_pot(players)
        winnings = pot / players.size.to_f
        players.each { |player| player.money += winnings}
    end

    def fold(player)
        player.fold
        @display.add_message("#{player.name} folded")
    end
    def raise_bet(player, amount)
        @current_bet += amount
        money_needed = (@current_bet - player.pot)
        player.add_to_pot(money_needed)
        display.update_pot(pot)
        @display.add_message("#{player.name} raised by #{amount}")
    end
    def see(player)
        amount = @current_bet - player.pot
        player.add_to_pot(amount)
        @display.add_message("#{player.name} saw the bet")
        display.update_pot(pot)
    end
    def remaining_players
        @players.select { |player| !player.folded? }
    end
    def pot
        @players.sum { |player| player.pot }
    end
    def num_players
        @players.size
    end
end

if __FILE__ == $PROGRAM_NAME
    names = %w(Pam Archer Lana Cheryl Cyril Ray Malory Krieger)
    players = []
    display = Display.new
    3.times do
        players << Player.new(names.pop, Hand.new, 25, display)
    end
    game = Game.new(players, display)
    game.play
end