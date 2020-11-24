require 'rspec'
require 'game'
require_relative '../lib/card.rb'
require_relative '../lib/hand.rb'
require_relative '../lib/player.rb'

describe Game do
    let(:players) do
         mock = [double("player_1"), double("player_2"), double("player_3")]
         mock.each do |player| 
            allow(player).to receive(:hand=)
            allow(player).to receive(:new_round)
            allow(player).to receive(:pot).and_return(0)
            allow(player).to receive(:fold)
            allow(player).to receive(:name).and_return("placeholder")
         end
         mock
    end
    let(:display) do 
        mock = double("display")
        allow(mock).to receive(:round_number=)
        allow(mock).to receive(:update_pot)
        allow(mock).to receive(:add_message)
        mock
    end
    subject(:game) { described_class.new(players, display) }
    describe "#initialize" do
        it "accepts an array of players and a display" do
            expect{game}.to_not raise_error
        end
    end

    describe "#new_round" do
        let(:deck) { double("deck") }
        let(:mock_deck_class) do
            mock = double("Deck")
            allow(mock).to receive(:new).and_return(deck)
            mock
        end
        subject(:game) do
            stub_const("Deck", mock_deck_class )
            described_class.new(players, display)
        end

        it "creates a new deck" do
            expect(mock_deck_class).to receive(:new)
            game.new_round
        end

        it "resets the current_bet to 0" do
            game.current_bet = 100
            game.new_round
            expect(game.current_bet).to eq(0)
        end

        it "increases the round number by 1" do
            previous_round_num = game.round_number
            game.new_round
            expect(game.round_number).to eq(previous_round_num + 1)
        end

        it "calls #new_round on each player" do
            players.each { |player| expect(player).to receive(:new_round) }
            game.new_round
        end

        it "rotates the starting player" do
            old_second_player = game.players[1]
            game.new_round
            expect(game.players.first).to eq(old_second_player)
        end
        
    end

    describe "#deal_starting_hands" do
        let(:five_cards) do 
            [
                double("one"), 
                double("two"), 
                double("three"), 
                double("four"), 
                double("five") 
            ] 
        end
        let(:deck) do
            deck = double("deck")
            allow(deck).to receive(:deal).with(5).and_return(five_cards)
            deck
        end
        let(:hand) {double("hand")}
        let(:mock_hand_class) do
            mock = double("Hand")
            allow(mock).to receive(:new).with(five_cards).and_return(hand)
            mock
        end
        let(:mock_deck_class) do
            mock = double("Deck")
            allow(mock).to receive(:new).and_return(deck)
            mock
        end
        subject(:game) do
            stub_const("Deck", mock_deck_class )
            stub_const("Hand", mock_hand_class)
            described_class.new(players, display)
        end
        it "creates new hands by dealing cards from the deck" do
            expect(deck)
                .to receive(:deal)
                .with(5)
                .exactly(game.players.length)
                .times
            game.new_round
            game.deal_starting_hands
        end
        it "assigns a new hand to each player" do
            players.each do |player|
                expect(player).to receive(:hand=).with(hand)
            end
            game.new_round
            game.deal_starting_hands
        end
    end
    context "when taking player actions" do
        let(:player) do
                hand = Card.cards_from_string("H6 HK H8 H2 HA")
                player = Player.new("one", hand, 100, display)
                player.add_to_pot(9)
                player
            end
            let(:other_player) do 
                hand = Card.cards_from_string("H6 HK H8 H2 HA")
                player = Player.new("two", hand, 100, display)
                player.add_to_pot(9)
                player
            end
            let(:players) { [player, other_player] }

        describe "#fold" do
            it "accepts a player as an argument" do
                expect{ game.fold(players.first) }.to_not raise_error
            end
            it "calls #fold on the player" do
                expect(players.first).to receive(:fold)
                game.fold(players.first)
            end
        end

        describe "#raise_bet" do
            let(:amount) { 12 }
            it "accepts a player and an amount as arguements" do
                expect {game.raise_bet(player, amount) }.to_not raise_error
            end
            it "raises the current_bet by the amount" do
                game.current_bet = 9
                game.raise_bet(player, amount)
                expect(game.current_bet).to eq(21)
            end
            it "makes the player's pot match the current_bet + raise amount" do
                game.current_bet = 9
                starting_bet = game.current_bet
                game.raise_bet(player, amount)
                expect(player.pot).to eq(starting_bet + amount)
            end
            it "deducts the difference from the player's money" do
                start_money = player.money
                game.current_bet = 15                
                amount_to_add_to_pot = amount + game.current_bet - player.pot 
                game.raise_bet(player, amount)
                expect(player.money).to eq(start_money - amount_to_add_to_pot )
            end

        end

        describe "#see" do
            it "accepts a player as an arguement" do
                expect { game.see(player) }.to_not raise_error
            end
            it "makes the player's pot match the current_bet" do
                game.current_bet = 20
                game.see(player)
                expect(player.pot).to eq(20)
            end
            it "deducts the difference from the player's money" do
                start_money = player.money
                game.current_bet = 20
                money_added = game.current_bet - player.pot
                game.see(player)
                expect(player.money).to eq(start_money - money_added)
            end
        end
    end

    context "when there is one winner" do
        let(:folded_player) do 
            hand = Card.cards_from_string("DJ HJ SJ CJ H7")
            Player.new("folded_player", hand, 100, display)
        end
        let(:winner) do 
            hand = Card.cards_from_string("H6 HK H8 H2 HA")
            Player.new("winner", hand, 100, display)
        end
        let(:loser_1) do 
            hand = Card.cards_from_string("SQ DJ C6 H5 C3")
            Player.new("loser_1", hand, 100, display)
        end
        let(:loser_2) do 
            hand = Card.cards_from_string("HK CK CJ SJ H10")
            Player.new("loser_2", hand, 100, display)
        end
        let(:players) do 
            players = [folded_player, winner, loser_1, loser_2]
            players.each { |player| player.add_to_pot(10) }
            players
        end
   
        describe "#showdown" do
            it "returns the player with the best hand who has not folded" do
                expect(game.showdown).to eq([winner])
            end
        end
        describe "#distribute_pot" do
            it "accepts an array of players as an argument" do
                winner = game.showdown
                expect { game.distribute_pot(winner) }.to_not raise_error
            end
            it  "adds the amount in the game's pot to the player's money" do
                winner = game.showdown
                game.distribute_pot(winner)
                expect(winner.first.money).to eq(130)
            end
        end
    end
    
    context "when there are multiple winners" do
        let(:folded_player) do 
            hand = Card.cards_from_string("DJ HJ SJ CJ H7")
            Player.new("folded_player", hand, 100, display)
        end
        let(:winner_1) do 
            hand = Card.cards_from_string("H6 HK H8 H2 HA")
            Player.new("winner_1", hand, 100, display)
        end
        let(:winner_2) do 
            hand = Card.cards_from_string("H6 HK H8 H2 HA")
            Player.new("winner_2", hand, 100, display)
        end
        let(:loser) do 
            hand = Card.cards_from_string("HK CK CJ SJ H10")
            Player.new("loser", hand, 100, display)
        end
        let(:players) do 
            players = [folded_player, winner_1, winner_2, loser]
            players.each { |player| player.add_to_pot(10) }
            players
        end

        describe "#showdown" do
            it "compares the hands of the players who have not folded" do
                expect(game.showdown.size).to eq(2)
                expect(game.showdown).to include(winner_1)
                expect(game.showdown).to include(winner_2)
            end
        end
        describe "#distribute_pot" do
            it "accepts an array of players as an argument" do
                winners = game.showdown
                expect { game.distribute_pot(winners) }.to_not raise_error
            end
            it  "adds the amount in the game's pot to the player's money" do
                winners = game.showdown
                game.distribute_pot(winners)
                winners.each do |winner|
                    expect(winner.money).to eq(110)
                end
            end
        end
    end

    describe "#remaining_players" do
        it "returns an array of players who have not yet folded" do
            players.each do |player|
                allow(player).to receive(:folded?).and_return(false)
            end
            allow(players.first).to receive(:folded?).and_return(true)
            expect(game.remaining_players).to eq(players[1..-1])
        end
    end
    describe "#pot" do 
        it "returns the sum of what's in each player's personal pot" do
            players.each { |player| allow(player).to receive(:pot).and_return(7)}
            expect(game.pot).to eq(7 * players.length)
        end
    end
end