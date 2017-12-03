#include "card.h"

Card::Card(cardType type,int cardNumber) {
    typ = type;
    cardNum = cardNumber;
    inPlayerHand = false;
}

bool Card::cardWithPlayer() {
    return inPlayerHand;
}

bool Card::cardWithDealer() {
    return !cardWithPlayer();
}

void Card::giveCardToPlayer(int id) {
    inPlayerHand = true;
    player_id = id;
}

void Card::returnCardToDealer() {
    inPlayerHand = false;
}

int Card::player_id_holding_card() {
    return player_id;
}
