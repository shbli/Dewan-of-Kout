#ifndef PLAYER_MM
#define PLAYER_MM

#include "player.h"
#include "global_keys.h"
#include <Foundation/Foundation.h>
#include "cocos2d.h"
#include "SimpleAudioEngine.h"
#include "fadedel.h"
#include "dealer.h"
#include "card.h"


dealer* Player::gameDealer = 0;
qreal Player::originalCardScale = 1;

#define center_z 100
#define rotationOffset 4
#define locationOffset 5.0
#define speechZlevel 130
#define speechTag 10
#define playtableScale 0.60
#define reaching_speed 0.20

Player::Player()
{
    preperToReArrange = 0;
    speechLayerCreated = false;
    selectedID = Card::None;
    selectionMade = false;
    toPlay = Card::None;
    tutMessageSprite = 0;
    ai_unit.playerP = this;
}

Player::~Player() {
}

void Player::takeCardFromDealer(card_layer* recived_card) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"dealing_card.wav"];
    if (myHandCards.size() == 0) {
        //we are starting a new game, am reciving my first card from the dealer, let me do some initilization :)
        selectedID = -1;
        selectionMade = false;
    }
    myHandCards.append(recived_card);
    [recived_card stopAllActions];
    float newRotation = centerCardRotation;
    newRotation -= [recived_card rotation];
    [recived_card runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*3.0 angle:newRotation] rate:4]];
    [recived_card runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed position:pixToPoint(centerCardPos.x, centerCardPos.y)] rate:4]];
    if (pid == 0 && myHandCards.size() >= 9) {
        preperToReArrange = true;
    }
//    if (true) {
    //this is for testing purpose, to uncover all players papers uncomment the code above, and comment the below one
    if (pid == 0) {
        [recived_card turnFaceUp:reaching_speed*2.0];
        [recived_card runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed scale:Player::originalCardScale] rate:4]];
    } else {
        [recived_card runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];
    }
    orgnize_cards(0.5);
}

//this function is used to always reorgize the cards, just position and rotation
void Player::orgnize_cards(float time) {
    if (setting_down()) {
        pid = 0;
        //this is a fix for a bug, where the id changes automatically
    }
#ifdef debugging
    if (pid < 0 || pid >= gameDealer->numOfPlayer) {
        qDebug() << "WARNING WRONG ID IS " << pid << " PLEASE FIX THE PROBLEM";
    }
#endif
    int center_z_level = center_z;
    if (pid == 0) {
        center_z_level += 45;
    }
    if (!myHandCards.isEmpty()) {
        card_layer* tempCard;
        for (int i = 0; i< myHandCards.size(); i++) {
            card_layer* tempCard = myHandCards.at(i);
            [tempCard setZ:center_z_level + ( myHandCards.size() - (i*3) ) ];
        }
        int middle_card = myHandCards.size()/2;
        tempCard = myHandCards.at(middle_card);
        qreal cardWidth = [tempCard cardWidth] * Player::originalCardScale;
        if (pid == 0) {
            cardWidth *= 1.2;
        } else {
            cardWidth /= downScaleComputerPlayersCards;
            cardWidth /= 2;
        }
        [tempCard stopAllActions];
        float newRotation = centerCardRotation;
        newRotation -= [tempCard rotation];
        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];

        float extraX = 0.0;
        if (setting_down() && selectedID != -1) {
            extraX = - 60.0 * Player::originalCardScale;
        }
        float x;
        float y;
        x = centerCardPos.x;
        y = centerCardPos.y;
        if (middle_card > selectedID) {
            x += extraX;
        }
        if (middle_card < selectedID) {
            x -= extraX;
        }
        if (middle_card == selectedID && setting_down()) {
            y += ( [tempCard cardWidth] /2);
        }
        if (preperToReArrange) {
            preperToReArrange = false;
            rearrange_cards();
            return;
//            tempCard->runSequence(
//                        Sequence::sequenceWithActions(
//                            action::easeinout(action::easeinout(action::moveTo(reaching_speed*time,x,y))),
//                            action::FuncCall(this,SLOT(rearrange_cards())),NULL));
        } else {
            [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(x, y)] rate:4]];
        }
        if (setting_down()) {
            [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale] rate:4]];
        } else {
            [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];
        }
        int card_left = middle_card - 1;
        int card_right = middle_card + 1;
        int diff;

        if (card_left >= 0 || card_right < myHandCards.size()) {
            if (setting_down()) {
                while (card_left >= 0 || card_right < myHandCards.size()) {
                    if (card_left >= 0) {
                        diff = card_left - middle_card;
                        tempCard = myHandCards.at(card_left);
                        [tempCard stopAllActions];
                        x = centerCardPos.x-((cardWidth/locationOffset)*diff);
                        y = centerCardPos.y+((cardWidth/(locationOffset*locationOffset*1.5))*diff);
                        if (card_left > selectedID) {
                            x += extraX;
                        }
                        if (card_left < selectedID) {
                            x -= extraX;
                        }
                        if (card_left == selectedID) {
                            y += ([tempCard cardWidth]/2);
                        }
                        float newRotation = centerCardRotation-(diff*rotationOffset/1.5);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(x, y)] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale] rate:4]];
                        [tempCard turnFaceUp:reaching_speed];
                        card_left --;
                    }
                    if (card_right < myHandCards.size()) {
                        diff = card_right - middle_card;
                        tempCard = myHandCards.at(card_right);
                        [tempCard stopAllActions];
                        x = centerCardPos.x-((cardWidth/locationOffset)*diff);
                        y = centerCardPos.y-((cardWidth/(locationOffset*locationOffset*1.5))*diff);
                        if (card_right > selectedID) {
                            x += extraX;
                        }
                        if (card_right < selectedID) {
                            x -= extraX;
                        }
                        if (card_right == selectedID) {
                            y += ([tempCard cardWidth]/2);
                        }
                        float newRotation = centerCardRotation-(diff*rotationOffset/1.5);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(x, y)] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale] rate:4]];
                        [tempCard turnFaceUp:reaching_speed];
                        card_right ++;
                    }
                }

            } else if (setting_up()) {
                while (card_left >= 0 || card_right < myHandCards.size()) {
                    if (card_left >= 0) {
                        diff = card_left - middle_card;
                        tempCard = myHandCards.at(card_left);
                        [tempCard stopAllActions];
                        float newRotation = centerCardRotation-(diff*rotationOffset/1.5);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x+((cardWidth/locationOffset)*diff),
                                                                                                                                               centerCardPos.y-((cardWidth/(locationOffset*locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];

                        card_left --;
                    }
                    if (card_right < myHandCards.size()) {
                        diff = card_right - middle_card;
                        tempCard = myHandCards.at(card_right);
                        [tempCard stopAllActions];
                        float newRotation = centerCardRotation-(diff*rotationOffset);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x+((cardWidth/locationOffset)*diff),
                                                                                                                                               centerCardPos.y+((cardWidth/(locationOffset*locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];

                        card_right ++;
                    }
                }

            } else if (setting_right()) {
                while (card_left >= 0 || card_right < myHandCards.size()) {
                    if (card_left >= 0) {
                        diff = card_left - middle_card;
                        tempCard = myHandCards.at(card_left);
                        [tempCard stopAllActions];
                        float newRotation = centerCardRotation-(diff*rotationOffset);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x+((cardWidth/(locationOffset*locationOffset))*diff),
                                                                                                                                               centerCardPos.y+((cardWidth/(locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];

                        card_left --;
                    }
                    if (card_right < myHandCards.size()) {
                        diff = card_right - middle_card;
                        tempCard = myHandCards.at(card_right);
                        [tempCard stopAllActions];
                        
                        float newRotation = centerCardRotation-(diff*rotationOffset);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x-((cardWidth/(locationOffset*locationOffset))*diff),
                                                                                                                                               centerCardPos.y+((cardWidth/(locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];
                        
                        card_right ++;
                    }
                }

            } else if (setting_left()) {
                while (card_left >= 0 || card_right < myHandCards.size()) {
                    if (card_left >= 0) {
                        diff = card_left - middle_card;
                        tempCard = myHandCards.at(card_left);
                        [tempCard stopAllActions];
                        
                        float newRotation = centerCardRotation-(diff*rotationOffset);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x-((cardWidth/(locationOffset*locationOffset))*diff),
                                                                                                                                               centerCardPos.y-((cardWidth/(locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];
                        
                        card_left --;
                    }
                    if (card_right < myHandCards.size()) {
                        diff = card_right - middle_card;
                        tempCard = myHandCards.at(card_right);
                        [tempCard stopAllActions];
                        
                        float newRotation = centerCardRotation-(diff*rotationOffset);
                        newRotation -= [tempCard rotation];
                        
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:reaching_speed*time angle:newRotation] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:reaching_speed*time position:pixToPoint(centerCardPos.x+((cardWidth/(locationOffset*locationOffset))*diff),
                                                                                                                                               centerCardPos.y-((cardWidth/(locationOffset))*diff))] rate:4]];
                        [tempCard runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:reaching_speed*time scale:Player::originalCardScale/downScaleComputerPlayersCards] rate:4]];

                        card_right ++;
                    }
                }
            }
        }
    }
}

//this function rearrange the cards, from largest on right of the screen to lowest
void Player::rearrange_cards() {
    //we'll creat a list
    QList card_temp_list;
    
    card_layer* tempCard;
    while (!myHandCards.isEmpty()) {
        card_temp_list.append(myHandCards.takeLast());
        tempCard =  card_temp_list.last();
        [tempCard stopAllActions];
    }
    //check if our list contains hearts
    if (arrangeType(&card_temp_list,Card::Heart)) {
        if (arrangeType(&card_temp_list,Card::Spade)) {
            if (arrangeType(&card_temp_list,Card::Diamond)) {
                arrangeType(&card_temp_list,Card::Club);
            }
            else {
                // no diamond
                if (arrangeType(&card_temp_list,Card::Club)) {
                    //some mistakes in caluculation, we'll fix it easy, we have hearts, club and spade
                    while (!myHandCards.isEmpty()) {
                        card_temp_list.append(myHandCards.takeLast());
                    }
                    arrangeType(&card_temp_list,Card::Spade);
                    arrangeType(&card_temp_list,Card::Heart);
                    arrangeType(&card_temp_list,Card::Club);


                }
                else {
                    //no club, we are done, only hearts and spade
                }
            }

        } else {
            //only one black
            arrangeType(&card_temp_list,Card::Club);
            arrangeType(&card_temp_list,Card::Diamond);
        }

    } else {
        //a chance that it contains diamond, but sure not hearts, only one red type
        arrangeType(&card_temp_list,Card::Spade);
        arrangeType(&card_temp_list,Card::Diamond);
        arrangeType(&card_temp_list,Card::Club);
    }
    //last jokers
    arrangeType(&card_temp_list,Card::BlackJoker);
    arrangeType(&card_temp_list,Card::RedJoker);
    if (pid == 0) {
        for (int i = 0; i < myHandCards.size(); i++) {
            tempCard = myHandCards.at(i);
            [tempCard turnFaceDown:0];
            [tempCard stopAllActions];
            [tempCard turnFaceUp:0];
        }
    }
    orgnize_cards(2);
    card_temp_list.release();
}

//this is used by the aobve function, to arrange specific suite, it returns success or false, if this suite is not found
bool Player::arrangeType(QList *tempList, Card::cardType cardtype) {
    bool containsThisType = true;
    bool success_value = false;
    card_layer* tempCard;
    card_layer* maxCard;
    while (containsThisType) {
        containsThisType = false;
        int max = -1;
        for (int i = 0; i<tempList->size(); i++) {
            tempCard = tempList->at(i);
            if ([tempCard cardInst]->typ == cardtype) {
                containsThisType = true;
                //compare it with the max
                if (max == -1) {
                    max = i;
                }
                else {
                    tempCard = tempList->at(i);
                    maxCard = tempList->at(max);
                    if ([tempCard cardInst]->cardNum > [maxCard cardInst]->cardNum) {
                        max = i;
                    }
                }
            }
        }
        if (max != -1) {
            success_value = true;
            myHandCards.prepend(tempList->takeAt(max));
        }
    }
    return success_value;
}
int Player::cards_count() {
    if (!myHandCards.isEmpty()) {
        return myHandCards.size();
    }
    return 0;
}

//these are to determine where this player is setting
bool Player::setting_down() {
    return (centerCardPos.y < 0 && centerCardPos.x == 0);
}
bool Player::setting_up() {
    return (centerCardPos.y > 0 && centerCardPos.x == 0);
}
bool Player::setting_left() {
    return (centerCardPos.x > 0);
}
bool Player::setting_right() {
    return (centerCardPos.x < 0);
}

void Player::clear_hand() {
    card_layer* tempCard;
    while (!myHandCards.isEmpty()) {
        tempCard = myHandCards.takeFirst();
        [tempCard returnCardToDealer];
    }
    myHandCards.clear();
}

//force is false by defualt, last player beding will recive it true, he's forced to play, if no other players have already bedded
int Player::bed(bool forced) {
    int bed = ai_unit.bed(force);
    ai_unit.tookTurn = true;
    if (bed >= 5 && bed > [gameDealer bed].amout) {
        speech(bed);
        bedding newbed = [gameDealer bed];
        newbed.amout = bed;
        newbed.suite = ai_unit.maxSuite;
        newbed.playerID = pid;
        newbed.team = pid%numOfTeams;
        [gameDealer setBed:newbed];
        // this is a hint for other players, that Oh I might be able to eat 2, because I already was 6
        if (bed > 5) {
            int team = pid % numOfTeams;
            [gameDealer teams:team]->chance += (bed/2.0);
        }
    } else {
        speech(-1);
    }
    return bed;
}

void Player::deleteMessageBox() {
}

void Player::speech(int speechText) {
    if (!speechLayerCreated)
        CreatSpeechLayer();
    //this code is for a later update
//    if (!setting_down()) {
//        //we are not setting down, let's speech
//        QString landExt = "_ar";
//        QSettings defaultsetting;
//        int langID = defaultsetting.value(langkey,arabic).toInt();
//        if (langID == arabic) {
//        } else {
//            //anything unnormal, we'll just make it english
//            landExt = "_en";
//        }
//        QString speechFile = QString().setNum(speechText) + QString("_") + QString().setNum(pid) + landExt + QString(".wav");
//        qDebug() << "Sound file is " << speechFile;
//        audioManager::playSound(speechFile);
//    }
    
    [speechBox setNum:speechText];
    [speechBox stopAllActions];
    [speechBox setScale:[speechBox scale]*1.5];
    [speechBox setOpacity:255 time:0.5];
    [speechBox runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:Player::originalCardScale] rate:4]];
}

void Player::CreatSpeechLayer() {
    if (!speechLayerCreated) {
        speechLayerCreated = true;
        //creating speech layer
        speechBox = [[numbers alloc] init];
        //scaling the box image
        [speechBox setScale:Player::originalCardScale];
        //setting the layer position
        [speechBox setPositionInPixels:[icon positionInPixels]];
        //fixing the positions of the numbers, so that they appear excatly in the middle
        const float iconPosFactor = 4.0;
        if (setting_right()) {
            [speechBox setPositionInPixels:CGPointMake([speechBox positionInPixels].x + (-iconPosFactor * Player::originalCardScale),[speechBox positionInPixels].y + (0.0 * Player::originalCardScale))];
        }
        if (setting_left()) {
            [speechBox setPositionInPixels:CGPointMake([speechBox positionInPixels].x + (iconPosFactor * Player::originalCardScale),[speechBox positionInPixels].y + (0.0 * Player::originalCardScale))];
        }
        if (setting_down()) {
            [speechBox setPositionInPixels:CGPointMake([speechBox positionInPixels].x + (0.0 * Player::originalCardScale),[speechBox positionInPixels].y + (- (iconPosFactor*2) * Player::originalCardScale))];
        }
        if (setting_up()) {
            [speechBox setPositionInPixels:CGPointMake([speechBox positionInPixels].x + (0.0 * Player::originalCardScale),[speechBox positionInPixels].y + (iconPosFactor * Player::originalCardScale))];
        }
        [speechBox setOpacity:0 time:0];
        //adding the layer
        [gameDealer addChild:speechBox z:0 tag:speechTag];
        if (setting_down()) {
            [speechBox.parent reorderChild:speechBox z:speechZlevel];
            [speechBox setPre:@"m"];
        } else {
            [speechBox.parent reorderChild:speechBox z:-25];
        }
    }
}

void Player::HideSpeechLayer() {
    if (!speechLayerCreated) {
    } else {
        [speechBox setOpacity:0 time:0.2];
//        [speechBox runAction:[CCFadeTo actionWithDuration:0.2 opacity:0]];
        [speechBox runAction:[CCScaleBy actionWithDuration:0.2 scale:1.5]];
    }
}

//play a card, here shall be the calculation for playing a card
void Player::play_card() {
    ai_unit.play_card();
    toPlay = ai_unit.toPlay;
    //play the card
    if (toPlay == Card::None && !infiteMode) {
        if (!ai_unit.human) {
#ifdef debugging
            qDebug() << "No specific rule to play card, please update my play AI";
#endif
        }
    } else {
        if (pid != 0 || infiteMode || !setting_down()) {
            throw_card();
        } else {
            if (!ai_unit.human) {
                //it's a tuturial, let's show the message which helps you playing a card
                show_tut_message();
            }
        }
    }
    if (ai_unit.human && setting_down()) {
        //it's a human, we'll do nothing but dim the cards that shouldn't be player
        [Player::gameDealer flashHints];
        dimAllNotAllowed();
        
    } else {
        ai_unit.human = false;
    }

}

void Player::play_second_sound() {
//    if (gameDealer->gameSpeed > 1) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_1.wav"];
//    }
}

void Player::throw_card() {
    ai_unit.tookTurn = true;
    ai_unit.myTurn = false;
    if (!ai_unit.human) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_2.wav"];
    }
    float speedfactor = 0.35;
    card_layer* CardToBePlayer = myHandCards.takeAt(toPlay);
    [CardToBePlayer runAction:[CCEaseInOut actionWithAction:[CCRotateBy actionWithDuration:speedfactor angle:playCardRotation] rate:4]];
    [CardToBePlayer runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:speedfactor position:Player::pixToPoint(playCardPos.x, playCardPos.y)] rate:4]];
    [CardToBePlayer runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:speedfactor scale:Player::originalCardScale*playtableScale] rate:4]];
    [CardToBePlayer turnFaceUp:speedfactor];
    [NSTimer scheduledTimerWithTimeInterval:speedfactor/2.0 target:gameDealer selector:@selector(play_second_sound) userInfo:nil repeats:NO];
    [gameDealer table_cards].append(CardToBePlayer);
    [CardToBePlayer returnCardToDealer];
    [CardToBePlayer setZ:(center_z +(3*[gameDealer table_cards].size()) )];

    if (setting_down()) {
        pid = 0;
        rearrange_cards();
    } else {
        orgnize_cards();
    }
    toPlay = Card::None;
    if ([gameDealer table_cards].size() >= ([gameDealer numOfPlayer])) {
        [NSTimer scheduledTimerWithTimeInterval:50/1000 target:gameDealer selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:speedfactor*[gameDealer gameSpeed] target:gameDealer selector:@selector(NextPlayerTurn) userInfo:nil repeats:NO];
    }
}

//End of play_card long function/methode!!

//show tuturial message function, this function is used to show the tuturial message, that will help the user to know more about the game
void Player::show_tut_message() {
    int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
    
    if (toPlay != Card::None && myHandcards_size() > 0) {
        card_layer* tempCard = myHandCards.at(toPlay);
        if ([Player::gameDealer table_cards].size() == 0 || ai_unit.playingSuite == Card::None) {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_first_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_first.png"];
            }
        } else if ([tempCard cardInst]->typ == Card::RedJoker) {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_red_joker_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_red_joker.png"];
            }
        } else if ([tempCard cardInst]->typ == Card::BlackJoker) {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_black_joker_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_black_joker.png"];
            }
        } else if ([tempCard cardInst]->typ == ai_unit.playingSuite) {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_exists_suite_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_exists_suite.png"];
            }
        } else if ([tempCard cardInst]->typ != ai_unit.playingSuite) {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_notexists_suite_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"playing_notexists_suite.png"];
            }
        } else {
            if (langID == arabic) {
                tutMessageSprite = [CCSprite spriteWithFile:@"unknowen_ar.png"];
            } else {
                tutMessageSprite = [CCSprite spriteWithFile:@"unknowen.png"];
            }
        }
    }
    if (tutMessageSprite != 0) {
        [gameDealer addChild:tutMessageSprite];
        [gameDealer reorderChild:tutMessageSprite z:center_z+100];
        [tutMessageSprite setScale:[gameDealer resizeToW:[tutMessageSprite contentSizeInPixels].width]];
        [tutMessageSprite setPositionInPixels:CGPointMake(1500, 0)];
        [tutMessageSprite runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 0)] rate:4]];
    }
}

void Player::hide_tut_message() {
    if (tutMessageSprite != 0) {
        //we are creating an object, that will take care of fading out the elemtnt, then delting it, and finally deleting itself
        [[fadeDel alloc] initWithToDel:tutMessageSprite parent:tutMessageSprite.parent action:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:pixToPoint(-1500, 0)] rate:4]];
        tutMessageSprite = 0;
        if (toPlay != Card::None) {
            //flash the card to be played, and then play it
            
            card_layer* tempCard = myHandCards.at(toPlay);
            [tempCard flash:2.0 WithTarget:gameDealer selector:@selector(player_0_throw_card)];
        }
    }
}

void Player::recievedTouch(CGPoint touchPos) {
    //no card has been selected
    if (!selectionMade) {
        //let's go for the cards one by one and check if the touch is on one of them
        for (int i = 0; i < myHandCards.size() ; i++) {
            //here we'll check one by one
            card_layer* card = myHandCards.at(i);
            if ([card contains:touchPos]) {
                if (selectedID != i) {
                    selectedID = i;
                    orgnize_cards(1);
                    selectedOrigPos = [card positionInPixels];
                } else {
                    //am touching the same card, there's a chance that I want to play that card
                    if (touchPos.y > [[CCDirector sharedDirector] winSizeInPixels].height/6) {
                        selectionMade = true;
                        [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_2.wav"];
                    }
                }
                return;
            }
        }
        selectedID = -1;
        orgnize_cards();
    } else {
        //some card has already been selected
        card_layer* card = myHandCards.at(selectedID);
        [card stopAllActions];
        [card setPositionInPixels:CGPointMake(touchPos.x-([[CCDirector sharedDirector] winSizeInPixels].width/2),touchPos.y-([[CCDirector sharedDirector] winSizeInPixels].height/2))];
    }
}

void Player::touchEnded(CGPoint touchPos) {
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (selectionMade) {
        selectionMade = false;
        if (touchPos.y > [[CCDirector sharedDirector] winSizeInPixels].height/5) {
            //if this is the case, I will play this card if it's ok otherwise, I'll just skip
            if (allowed(selectedID) && ai_unit.myTurn) {
                //the card we are going to play is allowed
                toPlay = selectedID;
                selectedID = -1;
                throw_card();
                [gameDealer stopFlashingHints];
                undimAll();
                toPlay = Card::None;
                //we call return to close the function, otherwise we'll do what below
                return;
            }
        }
        //play alert sound, this card is returned to hand
        [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_1_reveres.wav"];
        selectedID = -1;
        orgnize_cards();
    }
}

bool Player::allowed(int cardID,bool dim) {
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (ai_unit.countHandSuite(ai_unit.playingSuite) != 0) {
        //I have cards of the playing suite
        //let's do a check if that card actually exist
        if (cardID < myHandCards.size() && cardID >= 0) {
            card_layer* card = myHandCards.at(cardID);
            if ([card cardInst]->typ == ai_unit.playingSuite) {

                return true;
            }
            if ([card cardInst]->typ == Card::RedJoker) {
                return true;
            }
            if ([card cardInst]->typ == Card::BlackJoker) {
                return true;
            }
        }

        return false;
    }
    //i don't have the playing suite, let's make it clear to others that i don't have the playing suite
    ai_unit.dontHave[ai_unit.playingSuite] = true;
    return true;
}

void Player::dimAllNotAllowed() {
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < myHandCards.size(); i++) {
        if (!allowed(i,true)) {
            card_layer* card = myHandCards.at(i);
            [card dim:0.25];
        }
    }
}

void Player::undimAll() {
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < myHandCards.size(); i++) {
        card_layer* card = myHandCards.at(i);
        [card undim:0.25];
    }
}

float Player::myTeamChange(int sid) {
    int team = sid % numOfTeams;
    return [gameDealer teams:team]->chance;
}

int Player::compDiffculty() {
    return [gameDealer compDiffculty];
}

int Player::bed_team() {
    return [gameDealer bed].team;
}

int Player::bedders_round_count() {
    return [gameDealer bedders_round_count];
}

int Player::numOfPlayer() {
    return [gameDealer numOfPlayer];
}

int Player::bed_amout() {
    return [gameDealer bed].amout;
}

Card * Player::table_cards_at(int i) {
    card_layer* card = [gameDealer table_cards].at(i);
    return [card cardInst];
}

Card::cardType Player::bed_suite() {
    return [gameDealer bed].suite;
}

int Player::findAtTable(Card::cardType cardtype, int cardValu) {
    return [gameDealer findAtTable:cardtype val:cardValu];;
}

int Player::table_cards_size() {
    return [gameDealer table_cards].size();
}

int Player::bed_playerID() {
    return [gameDealer bed].playerID;
}

Player * Player::players(int i) {
    return [gameDealer players:i];
}

int Player::cards_size() {
    return [gameDealer cards].size();
}

Card * Player::cards_at(int i) {
    card_layer* card = [gameDealer cards].at(i);
    return [card cardInst];
}

int Player::myHandcards_size() {
    int x = myHandCards.size();
    return x;
}

Card * Player::myHandcards_at(int i) {
    card_layer* card = myHandCards.at(i);
    return [card cardInst];
}

int Player::team_eats(int idd) {
    return [gameDealer teams:idd]->eats;
}

int Player::opposite_team(int idd) {
    return [gameDealer opposite_team:idd];
}

bool Player::dontHave(Card::cardType tt) {
    return ai_unit.dontHave[tt];
}

CGPoint Player::pixToPoint(float x, float y) {
    //convert pixel to point point
    float scale = 1.0f * [[CCDirector sharedDirector] winSize].width/ [[CCDirector sharedDirector] winSizeInPixels].width ;
    x *= scale;
    y *= scale;
    return CGPointMake(x, y);
}

void Player::flashHintCard() {
    ai_unit.play_card();
    int bestCardID = ai_unit.toPlay;
    card_layer* CardToBePlayer = myHandCards.at(bestCardID);
    [CardToBePlayer flash:1.0 WithTarget:0 selector:0];
}

void Player::createPlayerUnnderIconLighter() {
    int zLevel = -10;
    if (setting_down()) {
        zLevel = 29;
        UnderIconLighter = [CCSprite spriteWithFile:@"main_light.png"];
    } else {
        int numberofTeams = numOfTeams;
        if (pid % numberofTeams == myTeam) {
            UnderIconLighter = [CCSprite spriteWithFile:@"red_light.png"];
        } else {
            UnderIconLighter = [CCSprite spriteWithFile:@"gray_light.png"];
        }
    }
    [UnderIconLighter setScale:[icon scale]];
    [UnderIconLighter setPositionInPixels:[icon positionInPixels]];
    [UnderIconLighter setRotation:[icon rotation]];
    [UnderIconLighter setOpacity:0];
    if (!setting_down()) {
        [[gameDealer iconsLayer] addChild:UnderIconLighter z:zLevel];
    } else {
        [gameDealer addChild:UnderIconLighter z:zLevel];
    }
}

void Player::startFlashingUnderIcon() {
    contFlashing = true;
    flashUnderIcon();
}

void Player::flashUnderIcon() {
    if (contFlashing) {
        [UnderIconLighter runAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.3 opacity:255],[CCFadeTo actionWithDuration:0.3 opacity:255*0.25],[CCCallFunc actionWithTarget:gameDealer selector:@selector(flashBedderAgain)], nil]];
    }
}


void Player::stopFlashingUnderIcon() {
    contFlashing = false;
    [UnderIconLighter stopAllActions];
    [UnderIconLighter stopAllActions];
    [UnderIconLighter setOpacity:0];    
}

#endif // PLAYER_H
