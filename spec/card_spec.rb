require 'rspec'
require 'card'

describe Card do
    describe "#initialize" do
        let(:value) { :'10' }
        subject(:card) { Card.new(:Spades, value) }
        it "should accept a suit and value" do
            expect{card}.to_not raise_error
        end
        it "should set a public suit instance variable" do
            expect(card.suit).to eq(:Spades)
        end
        it "should set a public value instance variable" do
            expect(card.value).to eq(value)
        end
    end

    context "when comparing cards" do
        let(:ace) { :Ace }
        let(:ten) { :'10' }
        let(:nine) { :'9'}
        let(:jack) { :Jack }
        subject(:ten_of_spades) { Card.new(:Spades, ten) }
        let(:ace_of_spades) { Card.new(:Spades, ace) }
        let(:ten_of_hearts) { Card.new(:Hearts, ten) }
        let(:nine_of_diamonds) { Card.new(:Diamonds, nine) }
        let(:ace_of_hearts) { Card.new(:Hearts, ace) }
        let(:jack_of_clubs) { Card.new(:Clubs, jack) }
        let(:other_ten_of_hearts) { Card.new(:Hearts, ten) } 
        
        describe "#>" do
            it "should determine if caller's value is greater" do
                expect( ten_of_spades > nine_of_diamonds).to be true
                expect( nine_of_diamonds > ten_of_spades ).to be false
            end
            it "should successfully compare face cards" do
                expect(jack_of_clubs > ten_of_spades).to be true
                expect(ten_of_spades > jack_of_clubs).to be false
                expect(jack_of_clubs > ace_of_hearts).to be false
                expect(ace_of_hearts > jack_of_clubs).to be true
            end
            it "should use suits to break ties" do
                expect(ace_of_spades > ace_of_hearts).to be false
                expect(ace_of_hearts > ace_of_spades).to be true
                expect(ten_of_hearts > ten_of_spades).to be true
                expect(ten_of_spades > ten_of_hearts).to be false
            end
        end

        describe "#<" do
            it "should determine if caller's value is lesser" do
                expect( ten_of_spades < nine_of_diamonds).to be false
                expect( nine_of_diamonds < ten_of_spades ).to be true
            end
            it "should successfully compare face cards" do
                expect(jack_of_clubs < ten_of_spades).to be false
                expect(ten_of_spades < jack_of_clubs).to be true
                expect(jack_of_clubs < ace_of_hearts).to be true
                expect(ace_of_hearts < jack_of_clubs).to be false
            end
            it "should use suits to break ties" do
                expect(ace_of_spades < ace_of_hearts).to be true
                expect(ace_of_hearts < ace_of_spades).to be false
                expect(ten_of_hearts < ten_of_spades).to be false
                expect(ten_of_spades < ten_of_hearts).to be true
            end
        end

        describe "#==" do
            it "should return true when the suit and value are the same" do
                expect(ten_of_hearts == other_ten_of_hearts).to be true
            end
            it "should return false when either the suit or value are different" do
                expect(ten_of_hearts == nine_of_diamonds).to be false
                expect(ten_of_hearts == ten_of_spades).to be false
                expect(ace_of_spades == ace_of_hearts).to be false
            end
        end
    end
    
    context "when creating sets of cards" do
        let(:suits) { [:Clubs, :Spades, :Hearts, :Diamonds] }
        let(:values) { [
            :'2',
            :'3',
            :'4',
            :'5',
            :'6',
            :'7',
            :'8',
            :'9',
            :'10',
            :Jack,
            :Queen,
            :King,
            :Ace] }
        subject(:suits_of_cards) do 
            suits.map do |suit|
                Card.suit_of_cards(suit)
            end
        end

        describe "::suit_of_cards" do
            it "should accept a suit parameter" do
                expect { Card.suit_of_cards(:Hearts) }.to_not raise_error
            end
            it "should accept the four standard suits" do
                expect do 
                    suits.each { |suit| Card.suit_of_cards(suit) } 
                end.to_not raise_error
            end
            it "should raise an error if the suit isn't valid" do
                expect { Card.suit_of_cards(:Shovels) }.to raise_error "invalid suit"
            end
            it "should return an array of 13 cards" do
                expect( 
                    suits_of_cards.all? { |set| set.length == 13 }
                ).to be true
            end
            it "should contain each card in the suit exactly once" do
                expect(
                    suits_of_cards.all? do |set|
                        set.all? do |card|
                            card.suit == set.first.suit
                        end
                    end
                ).to be true
                expect(
                    suits_of_cards.map { |set| set.first.suit } == suits
                ).to be true
                expect( 
                    suits_of_cards.all? do |set|
                        set.map { |card| card.value } == values
                    end
                ).to be true
            end
        end

        describe "::fifty_two_cards" do
            subject(:cards) { Card.fifty_two_cards }
            let(:cards_by_suit) { suits.map { |suit| Card.suit_of_cards(suit) } }
            it "should return an array that holds a standard deck of 52 cards" do
                expect(cards.length).to eq(52)
                expect(
                    cards_by_suit.all? do |suit_of_cards|
                        suit_in_deck = cards.select do |card| 
                            card.suit == suit_of_cards.first.suit 
                        end
                        suit_in_deck == suit_of_cards
                    end
                ).to be true
            end
        end
    end
    
end