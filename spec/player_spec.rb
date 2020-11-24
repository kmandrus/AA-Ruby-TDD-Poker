require 'rspec'
require 'player'

describe Player do
    let(:name) { "Skye" }
    let(:hand) { double("hand") }
    let(:other_hand) { double("other hand")}
    let(:starting_money) { 100 }
    let(:display) { 
        disp = double("display") 
        allow(disp).to receive(:add_message)
        disp
    }
    
    subject(:player) { described_class.new(name, hand, starting_money, display) }
    describe "#initialize" do
        it "accepts a name, hand, starting money, and display parameters" do
            expect { subject }.to_not raise_error
        end
        it "allows the name to be read" do
            expect(subject.name).to eq(name)
        end
        it "allows the money to be publicly read" do
            expect(subject.money).to eq(starting_money)
        end
        it "allows reading and writing of the hand" do
            expect(subject.hand).to eq(hand)
            subject.hand = other_hand
            expect(subject.hand).to eq(other_hand)
        end
        it "sets a public pot variable to zero" do
            expect(subject.pot).to eq(0)
        end
    end

    describe "#folded?" do
        context "after initialization" do
            it "the player has not folded" do
                expect(player.folded?).to be false
            end
        end
        it "is true after calling #fold" do
            player.fold
            expect(player.folded?).to be true
        end
    end

    describe "#new_round" do
        it "ensures #folded? is false" do
            player.fold
            player.new_round
            expect(player.folded?).to be false
        end
        it "empties the player's personal pot" do
            player.add_to_pot(25)
            player.new_round
            expect(player.pot).to eq(0)
        end
    end

    describe "#add_to_pot" do
        let(:amount) { 7 }
        it "accepts an amount as a parameter" do
            expect{player.add_to_pot(amount)}.to_not raise_error
        end
        it "reduces the players money by the amount" do
            player.add_to_pot(amount)
            expect(player.money).to eq(starting_money - amount)
        end
        it "adds the amount to the player's pot" do
            player.add_to_pot(amount)
            expect(player.pot).to eq(amount)
            player.add_to_pot(amount)
            expect(player.pot).to eq(amount * 2)
        end
        context "when the player does not have enough money remaining" do
            let(:too_much_money) { 101 }
            it "raises an error" do
                expect{ player.add_to_pot(too_much_money) }
                    .to raise_error "not enough money"
            end
        end
    end

    describe "#receive_cards" do
        let(:new_cards) { [double("c4"), double("c5")] }
        it "adds the new cards to the player's hand" do
            expect(hand).to receive(:add).with(new_cards)
            player.receive_cards(new_cards)
        end
    end
end