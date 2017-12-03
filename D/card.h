#ifndef CARD_H
#define CARD_H


class Card {
public:
    
    enum cardType {
        None = -1,
        Spade = 0,
        Heart = 1,
        Club = 2,
        Diamond = 3,
        BlackJoker = 4,
        RedJoker = 5
    };

    Card(cardType type,int cardNumber);
    bool cardWithPlayer();
    bool cardWithDealer();
    void giveCardToPlayer(int playerID);
    int player_id_holding_card();
    void returnCardToDealer();
    cardType typ;
    int cardNum;
    short int player_id;

private:
    bool inPlayerHand;
};

#endif // CARD_H
