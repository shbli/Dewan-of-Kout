#include "intell_controll.h"
#include "player.h"
#include <stdlib.h>
#define qrand arc4random
#define pid playerP->pid
//#define debugging
//#define macdebugging

//variabled for all players to memorize
//saving all other suites than the bed suite in an array to treat them
Card::cardType intell_controll::suites[3];
//now let's save the game number, total game plays last time cards have been dealt by the dealer
short int intell_controll::gameNumber;
//let's save the remaining number of eats we need
short int intell_controll::remaining_eats;
short int intell_controll::enemy_remaining_eats;
//bed suite cards outside my hand
int intell_controll::bedSuiteCards;
int intell_controll::minCard;
bool intell_controll::redJokerPlayed;
bool intell_controll::blackJokerPlayed;
Card::cardType intell_controll::playingSuite = Card::None;

intell_controll::intell_controll() {
    selectedID = Card::None;
    toPlay = Card::None;
    myTurn = false;
    tookTurn = false;
}

void intell_controll::takeCardFromDealer(Card *recived_card) {
    if (playerP->myHandcards_size() == 0) {
        //we are starting a new game, am reciving my first card from the dealer, let me do some initilization :)
        for (int i = 0; i < 4 ; i++) {
            dontHave [i] = false;
        }
        selectedID = -1;
    }
}

//force is false by defualt, last player beding will recive it true, he's forced to play, if no other players have already bedded
int intell_controll::bed(bool force) {
    int numOfBeddingSuite = 0;
    //Assuming I have both jokers and Let's check
    bool jokers = true;
    short int numOfStraightCards = 0;
    //first, let's get some initial random score : 1 or 2, also not forget our chances
    float score = 1 + playerP->myTeamChange(pid);
    score += qrand() % 3;
    //here we'll add something for the diffculty
    if (pid%numOfTeams == computerTeam) {
        //computer player
        if (playerP->compDiffculty() == easyID) {
            score += 2;
        }
        if (playerP->compDiffculty() == mediumID) {
            score += 2;
        }
    }
    
    //    //if my team is the winner, I'll always add 1 or 2 to my score to give other team a chance
    //    if (playerP->teams[playerP->player_team(pid)].score > playerP->teams[playerP->opposite_team(playerP->player_team(pid))].score) {
    //#ifdef debugging
    //        qDebug() << "We are stronger " << pid;
    //#endif
    //        score += (qrand() % 2) + 1;
    //    }
    //first thing, we'll check if we have the black or red joker and add the score respectively
    float jokerAdder = 1.0;
    if (find(Card::RedJoker)!= -1) {
        //red joker found
        numOfStraightCards += 1;
        score += jokerAdder;
        numOfBeddingSuite++;
    } else {
        //it's not found, we'll decrease the chance for red joker
        jokers = false;
        jokerAdder -= 0.2;
    }
    //find black joker
    if (find(Card::BlackJoker)!= -1) {
        //black joker found
        numOfStraightCards += 1;
        score += jokerAdder;
        numOfBeddingSuite++;
    } else {
        //it's not found, we'll decrease the chance for black joker
        jokers = false;
        jokerAdder -= 0.2;
    }
    //now we'll add the score for each of the suites
    float max;
    short int suitecounter = 0;
    //hearts
    float hearts = 0;
    float heartsAdder = 1.0;
    for (int i = 14; i > 1; i--) {
        if (find(Card::Heart,i) != -1) {
            //found, add the adder
            hearts += heartsAdder;
            suitecounter++;
            if (heartsAdder >= 1) {
                numOfStraightCards += 1;
            }
        } else {
            //decrease the adder
            heartsAdder -= (0.33);
            if (heartsAdder < 0) {
                heartsAdder = 0.4;
            }
        }
    }
    max = hearts;
    maxSuite = Card::Heart;
    numOfBeddingSuite = suitecounter;
    suitecounter = 0;
    //spade
    float spades = 0;
    float spadesAdder = 1.0;
    for (int i = 14; i > 1; i--) {
        if (find(Card::Spade,i) != -1) {
            //found, add the adder
            spades += spadesAdder;
            suitecounter++;
            if (spadesAdder >= 1) {
                numOfStraightCards += 1;
            }
        } else {
            //decrease the adder
            spadesAdder -= (0.33);
            if (spadesAdder < 0) {
                spadesAdder = 0.4;
            }
        }
    }
    if (spades > max) {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (spades-max > 0.4 && spades-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = spades;
                maxSuite = Card::Spade;
                numOfBeddingSuite = suitecounter;
                
            }
        } else {
            //diffrence is large,spade is my new bed suite
            score += max;
            max = spades;
            maxSuite = Card::Spade;
            numOfBeddingSuite = suitecounter;
        }
    } else {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (spades-max > 0.4 && spades-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = spades;
                maxSuite = Card::Spade;
                numOfBeddingSuite = suitecounter;
                
            }
        } else {
            score += spades;
        }
    }
    //club
    suitecounter = 0;
    float clubs = 0;
    float clubsAdder = 1.0;
    for (int i = 14; i > 1; i--) {
        if (find(Card::Club,i) != -1) {
            //found, add the adder
            clubs += clubsAdder;
            suitecounter++;
            if (clubsAdder >= 1) {
                numOfStraightCards += 1;
            }
        } else {
            //decrease the adder
            clubsAdder -= (0.33);
            if (clubsAdder < 0) {
                clubsAdder = 0.4;
            }
        }
    }
    if (clubs > max) {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (clubs-max > 0.4 && clubs-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = clubs;
                maxSuite = Card::Club;
                numOfBeddingSuite = suitecounter;
                
            }
        } else {
            //diffrence is large,club is my new bed suite
            score += max;
            max = clubs;
            maxSuite = Card::Club;
            numOfBeddingSuite = suitecounter;
        }
    } else {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (clubs-max > 0.4 && clubs-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = clubs;
                maxSuite = Card::Club;
                numOfBeddingSuite = suitecounter;
                
            }
        } else {
            score += clubs;
        }
    }
    
    //diamond
    suitecounter = 0;
    float diamonds = 0;
    float diamondsAdder = 1.0;
    for (int i = 14; i > 1; i--) {
        if (find(Card::Diamond,i) != -1) {
            //found, add the adder
            diamonds += diamondsAdder;
            suitecounter++;
            if (diamondsAdder >= 1) {
                numOfStraightCards += 1;
            }
        } else {
            //decrease the adder
            diamondsAdder -= (0.33);
            if (diamondsAdder < 0) {
                diamondsAdder = 0.4;
            }
        }
    }
    
    if (diamonds > max) {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (diamonds-max > 0.4 && diamonds-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = diamonds;
                maxSuite = Card::Diamond;
                numOfBeddingSuite = suitecounter;
            }
        } else {
            //diffrence is large,club is my new bed suite
            score += max;
            max = diamonds;
            maxSuite = Card::Diamond;
            numOfBeddingSuite = suitecounter;
        }
    } else {
        //it's not only that, if the diffrence is too low, and number of cards is larger for older one, we'll not choose this
        if (diamonds-max > 0.4 && diamonds-max < -0.4) {
            //diffrence is low, we'll get the higher
            if (suitecounter > numOfBeddingSuite) {
                score += max;
                max = diamonds;
                maxSuite = Card::Diamond;
                numOfBeddingSuite = suitecounter;
                
            }
        } else {
            score += diamonds;
        }
    }
    
    //now we'll recalculate our max suite
    max = 0;
    float maxAdder = 1;
    for (int i = 14; i > 1; i--) {
        if (find(maxSuite,i) != -1) {
            //found, add the adder
            max += maxAdder;
            
        } else {
            //decrease the adder
            maxAdder -= 0.1;
            if (maxAdder < 0.25) {
                maxAdder = 0.25;
            }
        }
    }
    score += max;
    
    if (score > 4.0 && score < 6.0) {
        score = 5.1;
        if (numOfStraightCards > 3) {
            score = 6.1;
        }
        if (numOfStraightCards > 2 && numOfBeddingSuite > 4) {
            score = 7.1;
        }
    }
#ifdef debugging
    qDebug() << "Player " << pid << " Chance is " << score;
#endif
    int bed = score;
    if (bed > 9)
        bed = 9;
    if (bed > 7 && !jokers)
        bed = 7;
    if (bed > 6 && numOfBeddingSuite < 7)
        bed = 6;
    if (bed > 5 && numOfBeddingSuite < 5)
        bed = 5;
    if (bed < 5)
        bed = 0;
    if (force && bed < 5)
        bed = 5;
    if (numOfBeddingSuite > 7 && numOfStraightCards > 2)
        bed = 9;
    //let's becarefull if the other team bed is too high, we'll just skip because sure they have something for us
    if (playerP->bed_team() != pid%numOfTeams) {
        //if this is the other team that has bed, let me see how much they've bed
        if (playerP->bed_amout() >= 7) {
            //if they've already bedded with bigger than 7 I'll skip
            bed = 0;
        }
    }
    //if my team bedded 8 I'll try my best to bed with Bawan "9"
    if (playerP->bed_team() == pid%numOfTeams) {
        if (playerP->bed_amout() >= 8) {
            if (bed > 6) {
                bed = 9;
            }
            if (bed > 5 && playerP->bedders_round_count() >= ( playerP->numOfPlayer() - 2 ) )
                bed = 9;
        }
    }
    //if I have 8 or above cards of my max suite, I'll bed all the 9
    if (numOfBeddingSuite > 6 && jokers)
        bed = 9;
    //special case to go and say 8
    if (playerP->bedders_round_count() >= (playerP->numOfPlayer() - 2)) {
        //am the last player
        //if my team bedded 8 I'll go 9 no matter, I trust them
        if (playerP->bed_team() == pid%numOfTeams) {
            if (playerP->bed_amout() >= 8) {
                bed = 9;
            }
        }
    } else {
        if (jokers && numOfStraightCards >= 3 && bed < 8) {
            //I have all the jokers, and at least one Ace ( jokers also are straight cards)
            bed = 8;
        }
    }
    //    //this is just for testing, let one team lose fast
    //    if(pid % 2 == 0) {
    //        bed = 9;
    //    }
    return bed;
}

//play card options, call any one for any option

void intell_controll::play_redJoker() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif

    toPlay = find(Card::RedJoker);
}

void intell_controll::play_blackJoker() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif

    //this function guarantes the player who's trying to play the black joker doesn't do anything foolish
    if (findLargestOnTable() != -1) {
        if (playerP->table_cards_at(findLargestOnTable())->typ != Card::RedJoker) {
            if (playerP->table_cards_at(findLargestOnTable())->typ == playerP->bed_suite()) {
                if (playerP->table_cards_at(findLargestOnTable())->cardNum != 14) {
                    toPlay = find(Card::BlackJoker);
                }
            } else {
                toPlay = find(Card::BlackJoker);
            }
        }
    }
}

void intell_controll::play_a_kind_exist_once() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (countHandSuite(playerP->bed_suite()) != 0) {
        for (int i = 0; i < 3; i++) {
            if (countHandSuite(intell_controll::suites[i]) == 1) {
                if(toPlay == Card::None) {
                    toPlay = find(intell_controll::suites[i]);
                } else {
                    //if already found, and I have a smaller, I'll take the smaller
                    if (find(intell_controll::suites[i]) != Card::None) {
                        if ( playerP->myHandcards_at(toPlay)->cardNum > playerP->myHandcards_at(find(intell_controll::suites[i]))->cardNum) {
                            toPlay = find(suites[i]);
                        }
                    }
                }
            }
        }
    }
    if (toPlay != Card::None) {
        if ( playerP->myHandcards_at(toPlay)->cardNum > 9) {
            if ( ( !beddingSuiteOnTable && playerP->myHandcards_at(toPlay)->cardNum <= maxAvailable ) || beddingSuiteOnTable) {
                //I played a card, that makes it easy for people to reconize that no card of this is left with me!!
                dontHave[playingSuite] = true;
            }
        }
    }
}

void intell_controll::play_any_ace() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < 3; i++) {
        if(toPlay == Card::None) {
            toPlay = find(intell_controll::suites[i],14);
        }
    }
}

void intell_controll::play_smallest_max_repeated() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int max_count = countHandSuite(suites[0]);
    toPlay = findMin(suites[0]);
    for (int i = 1; i < 3; i++) {
        if(countHandSuite(suites[i]) > max_count) {
            toPlay = findMin(suites[i]);
            max_count = countHandSuite(suites[i]);
        }
    }
}

void intell_controll::play_bed_suite_ace() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->findAtTable(Card::RedJoker) == -1) {
        toPlay = find(playerP->bed_suite(),14);
    }
}

void intell_controll::play_bed_suite_mid() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->findAtTable(Card::RedJoker) == -1) {
        toPlay = findMid(playerP->bed_suite());
        if (playerP->findAtTable(Card::BlackJoker) != -1) {
            //black joker is found
            if (toPlay != Card::None) {
                if ( playerP->myHandcards_at(toPlay)->cardNum != 14) {
                    //I'll cancel that step
                    toPlay = Card::None;
                }
            }
        }
    }
}
void intell_controll::play_bed_suite_max() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->findAtTable(Card::RedJoker) == -1) {
        toPlay = findMax(playerP->bed_suite());
        if (playerP->findAtTable(Card::BlackJoker) != -1) {
            if (toPlay != Card::None) {
                if  (playerP->myHandcards_at(toPlay)->cardNum != 14) {
                    //I'll cancel that step
                    toPlay = Card::None;
                }
            }
        }
    }
}
void intell_controll::play_bed_suite_min() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->findAtTable(Card::RedJoker) == -1) {
        toPlay = findMin(playerP->bed_suite());
        if (playerP->findAtTable(Card::BlackJoker) != -1) {
            if (toPlay != Card::None) {
                if  (playerP->myHandcards_at(toPlay)->cardNum != 14) {
                    //I'll cancel that step
                    toPlay = Card::None;
                }
            }
        }
    }
    
}

void intell_controll::play_largest_in_game() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int largestCard;
    bool ok_found = false;
    for (int i = 0; i < 3 && (!ok_found); i++) {
        largestCard = findMax(intell_controll::suites[i]);
        if (largestCard != -1) {
            ok_found = true;
            for (int j = playerP->myHandcards_at(largestCard)->cardNum; ok_found && j < 15 ; j++) {
                if (rememberIfPlayedCard(intell_controll::suites[i],j)) {
                    //we found a larger card, we'll make this false
                    ok_found = false;
                }
            }
        }
        //if we get outside, that mean my choice was good
        if (ok_found) {
            toPlay = largestCard;
        }
    }
}

void intell_controll::play_smallest_not_with_others() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < 3; i++) {
        if (!suiteExistWithOtherTeam(intell_controll::suites[i])) {
            //I'll play that suite
            toPlay = findMin(intell_controll::suites[i]);
        }
    }
}

void intell_controll::play_smallest_not_with_friends() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < 3; i++) {
        if (!suiteExistWithMyTeam(intell_controll::suites[i])) {
            //I'll play that suite
            toPlay = findMin(intell_controll::suites[i]);
        }
    }
}

void intell_controll::play_smallest() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    toPlay = findMin(intell_controll::suites[0]);
    int temptopPlay;
    for (int i = 1; i < 3; i++) {
        if (toPlay != Card::None) {
            temptopPlay = findMin(intell_controll::suites[i]);
            if (temptopPlay != -1) {
                if  (playerP->myHandcards_at(toPlay)->cardNum < playerP->myHandcards_at(temptopPlay)->cardNum) {
                    //I'll play that suite
                    toPlay = temptopPlay;
                }
            }
        } else {
            toPlay = findMin(suites[i]);
        }
    }
}

//end of play cards options

//play options, more general

//this funciton, is called for the first player, that got the highest bed, also his first game
void intell_controll::play_bedderStart() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->bed_amout() < 6) {
        //first thing, I will try to find a card that I only have one of it's kind, and play it
        play_a_kind_exist_once();
        //if I can't find
        if (toPlay == Card::None) {
            // I'll search for an Ace
            play_any_ace();
        }
        if (toPlay == Card::None) {
            // I didn't manage to find an ace for other suites, I'll play my smallest card for the most repeated suite
            play_smallest_max_repeated();
        }
        if (toPlay == Card::None) {
            //Error
#ifdef debugging
            qDebug() << "Error in game play AI 1";
#endif
        }
    }
    else {
        //am bedding six or more
        //search for the bedding suite ace
        play_bed_suite_ace();
        if (toPlay == Card::None) {
            //play medium suite card
            play_bed_suite_mid();
        }
        if (toPlay == Card::None) {
            //play smallest bedding suite
            play_bed_suite_min();
        }
        if (toPlay == Card::None) {
            //Error, if am the bidder and dont have bedding suite it's crazy
#ifdef debugging
            qDebug() << "Error in " << Q_FUNC_INFO;
#endif
        }
    }
}

//this methode is called when bed cards are all played
void intell_controll::play_zero_bed_cards() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    play_largest_in_game();
    if (toPlay == Card::None) {
        //I don't have a card, that is largest of all others, I'll try my best to play a small card of a suite that is only with my firends
        play_smallest_not_with_others();
    }
    if (toPlay == Card::None) {
        //I don't have a card, that is largest of all others, I'll play the smallest, not bed card
        play_smallest();
    }
    if (toPlay == Card::None) {
        //this means, I only have bed suites, I'll play the smallest and check what my friends can do
        //this the last step, i have no other options, if the bed suites = 0
        play_bed_suite_min();
    }
    //maybe I only have jokekrs
    if (toPlay == Card::None) {
        play_redJoker();
    }
    if (toPlay == Card::None) {
        toPlay == find (Card::BlackJoker);
    }
    if (toPlay == Card::None) {
#ifdef debugging
        qDebug() << "Error in " << Q_FUNC_INFO;
#endif
    }
}

//this methode is called if there's still some bed suites remaining
void intell_controll::play_remaining_bed_suites() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (suiteExistWithOtherTeam(playerP->bed_suite())) {
        //there's some bedding suites remaining with enemies
        if (countHandSuite(playerP->bed_suite()) > 2) {
            if (playerP->bed_playerID() == pid) {
                //if am the bedder
                if (find(playerP->bed_suite(),11) == Card::None && find(playerP->bed_suite(),12) == Card::None && find(playerP->bed_suite(),13) == Card::None) {
                    if (playerP->bed_amout() > 7) {
                        //am bedding 8 or more
                        play_redJoker();
                        if (playerP->bed_amout() > 8) {
                            //am bawan
                            if (toPlay == Card::None) {
                                toPlay = find(Card::BlackJoker);
                            }
                        }
                    }
                }
                
            }
            //the bed suite exists with the other team
            if (playerP->bed_playerID() == pid && toPlay == Card::None)
            {
                if (toPlay == Card::None && countHandSuite(playerP->bed_suite()) > 1) {
                    play_bed_suite_max();
                }
                //am the bidder,I'll play a good bed suite, if largest in my hand, is largest available and larger than all others not played, I'll go and play it, other than that, I'll just play a small number, or a small card
                int maxNotPlayedBedCardNum = findLargestNotPlayed(playerP->bed_suite());
                if  (playerP->myHandcards_at(toPlay)->cardNum >= maxNotPlayedBedCardNum) {
                    //it's ok
                } else {
                    //be carefull, there's a bigger card outside
                    toPlay = Card::None;
                    play_largest_in_game();
                }
                if (toPlay == Card::None) {
                    //I don't have a card, that is largest of all others, and no chance I play the bed suite,I'll try my best to play a small card of a suite that is only with my firends
                    //this the last step, i have no other options, if the bed suites = 0
                    play_smallest_not_with_others();
                }
                if (toPlay == Card::None) {
                    play_smallest();
                }
            }
        }
        if (toPlay == Card::None) {
            //am not the bidder, or the number of bed cards is too low
            //I'll try to play the largest card in game if I have one, otherwise, I'll play a the smallest card
            play_largest_in_game();
        }
        if (toPlay == Card::None) {
            //I don't have a card, that is largest of all others, I'll try my best to play a small card of a suite that is only with my firends
            play_smallest_not_with_others();
        }
        if (toPlay == Card::None) {
            play_smallest();
        }
        if (toPlay == Card::None) {
            play_bed_suite_max();
            if (toPlay != Card::None) {
                int maxNotPlayedBedCardNum = findLargestNotPlayed(playerP->bed_suite());
                if  (playerP->myHandcards_at(toPlay)->cardNum >= maxNotPlayedBedCardNum) {
                    //it's ok
                } else {
                    //be carefull, there's a bigger card outside
                    toPlay = Card::None;
                    play_bed_suite_min();
                }
            }
        }
        if (toPlay == Card::None) {
            //if my luck is that bad, I'll play my smallest card
            play_smallest();
        }
        if (toPlay == Card::None) {
            play_redJoker();
        }
        if (toPlay == Card::None) {
            //if my luck is that bad, I'll play my smallest card
            toPlay = find(Card::BlackJoker);
        }
        if (toPlay == Card::None) {
#ifdef debugging
            qDebug() << "Error in game play AI 4";
#endif
        }
    }
    
    else {
        //if suite doesn't exist with the other team
        //no remaining bed suitets, I'll try to play the largest card in game if I have one, otherwise, I'll play a the smallest card
        play_largest_in_game();
        if (toPlay == Card::None) {
            //I don't have a card, that is largest of all others, I'll try my best to play a small card of a suite that is only with my firends
            play_smallest_not_with_others();
        }
        // I'll try to play a suite that doesn't exist with my friends, so they can kick in their smaller bed suites
        if (toPlay == Card::None) {
            play_smallest_not_with_friends();
        }
        //play something, that my friends doesn't have
        if (toPlay == Card::None) {
            play_bed_suite_max();
            int maxNotPlayedBedCardNum = findLargestNotPlayed(playerP->bed_suite());
            if (toPlay != Card::None) {
                if  (playerP->myHandcards_at(toPlay)->cardNum >= maxNotPlayedBedCardNum) {
                    //it's ok
                } else {
                    //be carefull, there's a bigger card outside
                    toPlay = Card::None;
                    play_bed_suite_min();
                }
            }
        }
        if (toPlay == Card::None) {
            play_smallest();
        }
        if (toPlay == Card::None) {
            play_redJoker();
        }
        if (toPlay == Card::None) {
            toPlay = find(Card::BlackJoker);
        }
        if (toPlay == Card::None) {
#ifdef debugging
            qDebug() << "Error in " << Q_FUNC_INFO;
#endif
        }
        
    }
}

//this is called, if am playing first, but not the first game really
void intell_controll::play_first() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (bedSuiteCards == 0) {
        //no remaining bed suitets, I'll try to play the largest card in game if I have one, otherwise, I'll play a the smallest card
        play_zero_bed_cards();
    } else {
        //I will play one of my suite cards, to finish up the remaining, if they exist with other team
        play_remaining_bed_suites();
    }
    
}
void intell_controll::play_not_first_have_last() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (playerP->table_cards_at(LargestOnTableID)->player_id%numOfTeams == pid%numOfTeams) {
        //largest card played by a friend
        
#ifdef debugging
        qDebug() << "last and largest card from friend";
#endif
        toPlay = findMin(playingSuite);
        
    } else {
        //largest card from enemy
#ifdef debugging
        qDebug() << "last and largest card from enemy";
#endif
        if (beddingSuiteOnTable) {
            if (playingSuite == playerP->bed_suite()) {
                if (playerP->table_cards_at(LargestOnTableID)->typ != Card::RedJoker) {
                    if (playerP->table_cards_at(LargestOnTableID)->typ != Card::BlackJoker) {
                        toPlay = findLargerThan(playingSuite,playerP->table_cards_at(LargestOnTableID)->cardNum);
                    } else {
                        play_bed_suite_ace();
                    }
                }
            }
            if (playerP->table_cards_at(LargestOnTableID)->typ == Card::BlackJoker) {
                play_redJoker();
            }
            if (toPlay == Card::None) {
                toPlay = findMin(playingSuite);
            }
        } else {
            toPlay = findLargerThan(playingSuite,playerP->table_cards_at(LargestOnTableID)->cardNum);
        }
        //let's see if am going to play one of the jokers or not
        if (toPlay == Card::None) {
            if (playerP->table_cards_at(LargestOnTableID)->cardNum > maxAvailable) {
                //it's the greatest, also from enemy threating us, let me try to play the black joker first
                play_blackJoker();
                //let's becarefull if it's the ace of the bedding suite I'll cancel
                if (playerP->table_cards_at(LargestOnTableID)->cardNum == 14 && playerP->table_cards_at(LargestOnTableID)->typ == playerP->bed_suite()) {
                    toPlay = Card::None;
                }
                if (toPlay == Card::None) {
                    play_redJoker();
                }
            }
        }
        if (toPlay == Card::None) {
            if (enemy_remaining_eats < 2) {
                play_redJoker();
                if (toPlay == Card::None) {
                    play_blackJoker();
                }
            }
        }
        if (toPlay == Card::None) {
            toPlay = findMin(playingSuite);
        }
        if (toPlay == Card::None) {
#ifdef debugging
            qDebug() << "Error in game play AI 6";
#endif
        }
    }
}

void intell_controll::play_not_first_have_not_last() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    //largest card played by a friend
    if (playerP->table_cards_at(LargestOnTableID)->player_id%numOfTeams == pid%numOfTeams) {
#ifdef debugging
        qDebug() << "largest card from friend";
#endif
        if (beddingSuiteOnTable) {
            if (playingSuite != playerP->bed_suite()) {
                toPlay = findMin(playingSuite);
            } else {
                //if the playing suite is the bed suite, even if my friend is eating this, I will check if it's large enough, or I will play a larger card
                if (playerP->table_cards_at(LargestOnTableID)->cardNum > maxAvailable ) {
                    //my friend played a card, large enough
                    toPlay = findMin(playingSuite);
                } else {
                    toPlay = findMax(playingSuite);
                    if (toPlay != Card::None) {
                        if  (playerP->myHandcards_at(toPlay)->cardNum < maxAvailable) {
                            toPlay = findMax(playingSuite);
                            if  (playerP->myHandcards_at(toPlay)->cardNum < maxAvailable) {
                                toPlay = findMid(playingSuite);
                            }
                        }
                    }
                    if (toPlay != Card::None) {
                        if (playerP->table_cards_at(LargestOnTableID)->cardNum + 1 == playerP->myHandcards_at(toPlay)->cardNum) {
                            //bigger than friend in one card, no need
                            toPlay = findMin(playingSuite);
                        }
                    }
                }
            }
        } else {
            if (playerP->table_cards_at(LargestOnTableID)->cardNum > maxAvailable ) {
                //my friend played a card, large enough
                toPlay = findMin(playingSuite);
            } else {
                toPlay = findMax(playingSuite);
                if (toPlay != Card::None) {
                    if  (playerP->myHandcards_at(toPlay)->cardNum < maxAvailable) {
                        toPlay = findMax(playingSuite);
                        if  (playerP->myHandcards_at(toPlay)->cardNum < maxAvailable) {
                            toPlay = findMid(playingSuite);
                        }
                    }
                }
                if (toPlay != Card::None) {
                    if (playerP->table_cards_at(LargestOnTableID)->cardNum + 1 == playerP->myHandcards_at(toPlay)->cardNum) {
                        //bigger than friend in one card, no need
                        toPlay = Card::None;
                    }
                }
            }
        }
        if (toPlay == Card::None) {
            toPlay = findMin(playingSuite);
        }
        if (toPlay == Card::None) {
#ifdef debugging
            qDebug() << "Error in game play AI 7";
#endif
        }
        
    } else {
        //largest card from enemy
#ifdef debugging
        qDebug() << "largest card from enemy";
#endif
        //if there's a card, larger than my card
        
        if (beddingSuiteOnTable) {
#ifdef debugging
            qDebug() << "bedding suite on table";
#endif
            if (playingSuite == playerP->bed_suite()) {
                //it's all playing the bed suite, let's find a larger card
                play_bed_suite_ace();
                if (toPlay == Card::None) {
                    play_bed_suite_max();
                    if (toPlay != Card::None) {
                        if  (playerP->myHandcards_at(toPlay)->cardNum < maxAvailable || playerP->myHandcards_at(toPlay)->cardNum < playerP->table_cards_at(LargestOnTableID)->cardNum) {
                            toPlay = Card::None;
                        }
                    }
                }
            }
            if (toPlay == Card::None) {
                if (enemy_remaining_eats < 2 || ( playerP->table_cards_at(LargestOnTableID)->cardNum >= maxAvailable ) ) {
                    play_redJoker();
                    if (toPlay == Card::None) {
                        play_blackJoker();
                    }
                    
                }
            }
            
            if (toPlay == Card::None) {
                toPlay = findMin(playingSuite);
                if  (playerP->myHandcards_at(toPlay)->cardNum > 10) {
                    //it's a good chance, that this is my last paper of this suite
                    dontHave[playingSuite] = true;
                }
            }
            
        } else {
            //no bed suite on table
            if  (playerP->myHandcards_at(findMax(playingSuite))->cardNum < maxAvailable ) {
                //there's a card of the play suite, larger than my card, outside with otheres
                //if that's the case, first thing I'll play the jokers
                if (rememberIfPlayedCard(playerP->bed_suite(),14)) {
                    //if that's played, am not afraid to play the black joker
                    play_blackJoker();
                }
                if (toPlay == Card::None) {
                    if (enemy_remaining_eats < 2 || ( playerP->table_cards_at(LargestOnTableID)->cardNum >= maxAvailable ) ) {
                        play_redJoker();
                        if (toPlay == Card::None) {
                            play_blackJoker();
                        }
                        
                    }
                }
                
                if (playerP->table_cards_size() <= (playerP->numOfPlayer() - 3)) {
                    //still some players to go
                    toPlay = findMin(playingSuite);
                } else {
                    // I will play largest card, to force other guys to play large cards
                    toPlay = findMax(playingSuite);
                    if  (playerP->myHandcards_at(toPlay)->cardNum < playerP->table_cards_at(LargestOnTableID)->cardNum) {
                        toPlay = findMin(playingSuite);
                    }
                }
                if (toPlay != Card::None) {
                    if  (playerP->myHandcards_at(toPlay)->typ == playingSuite) {
                        if  (playerP->myHandcards_at(toPlay)->cardNum < playerP->table_cards_at(LargestOnTableID)->cardNum) {
                            if  (playerP->myHandcards_at(toPlay)->cardNum > 10) {
                                //it's a good chance, that this is my last paper of this suite
                                dontHave[playingSuite] = true;
                            }
                        }
                    }
                }
            } else {
                //my card is largest available (AKA Shaikha)
                toPlay = findMax(playingSuite);
                if  (toPlay != Card::None) {
                    if (playerP->table_cards_at(LargestOnTableID)->cardNum > playerP->myHandcards_at(toPlay)->cardNum) {
                        toPlay = Card::None;
                        toPlay = findMin(playingSuite);
                    }
                }
            }
        }
    }
}

void intell_controll::play_not_first_have() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (toPlay == Card::None) {
        if (playerP->table_cards_size() >= (playerP->numOfPlayer() - 1)) {
            //am the last player
            play_not_first_have_last();
        } else {
            //am not the last player
            play_not_first_have_not_last();
        }
    }
    if (toPlay == Card::None) {
#ifdef debugging
        qDebug() << "Error in " << Q_FUNC_INFO;
#endif
    }
    
}

void intell_controll::play_not_first_dont_have() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    dontHave[playingSuite] = true;
    if (playerP->table_cards_at(LargestOnTableID)->player_id%numOfTeams == pid%numOfTeams) {
        //largest card played by a friend
#ifdef debugging
        qDebug() << "Largest card played by a friend";
#endif
        if (playerP->table_cards_size() >= (playerP->numOfPlayer() - 1)) {
            //am the last player, do nothing, let me friend eats it
        } else {
            //am not the last player, reCheck
            if (playerP->table_cards_at(LargestOnTableID)->cardNum > maxAvailable ) {
                //my friend played a card, large enough do nothing
            } else {
                //there's a bigger card than my friend
                if (enemy_remaining_eats < 3) {
                    if (beddingSuiteOnTable) {
                        //do nothing cause it means my friend played a card, that is from the bedding suite, so i shouldn't play a larger, and my friend also don't have this suite
                    } else {
                        //try to play a bed suite that is large enough
                        play_bed_suite_min();
                    }
                }
            }
        }
    } else {
        //largest card from enemy
#ifdef debugging
        qDebug() << "Largest card played by an enemy";
#endif
        
        if (beddingSuiteOnTable) {
            toPlay = findLargerThan(playerP->bed_suite(),playerP->table_cards_at(LargestOnTableID)->cardNum);
        } else {
            //try to play a bed suite that is large enough
            play_bed_suite_min();
        }
        if (toPlay == Card::None) {
            if (playerP->table_cards_at(LargestOnTableID)->cardNum > 9 && enemy_remaining_eats < 2) {
                play_blackJoker();
                if  (toPlay == Card::None) {
                    play_redJoker();
                }
            }
        }
    }
    // I cannot afford a higher card than played
    if ( toPlay == Card::None ) {
        play_smallest_not_with_others();
    }
    if ( toPlay == Card::None ) {
        play_smallest_max_repeated();
    }
    if (toPlay == Card::None) {
        play_smallest();
    }
    if (toPlay == Card::None) {
        play_blackJoker();
    }
    if (toPlay == Card::None) {
        play_redJoker();
    }
    if (toPlay == Card::None) {
        if (enemy_remaining_eats < 2) {
            play_blackJoker();
            if (toPlay == Card::None) {
                play_redJoker();
            }
        }
    }
    if (toPlay == Card::None) {
        //I only have cards of bedding suite
        play_bed_suite_min();
    }
    if (toPlay == Card::None) {
        //maybe I was afraid a little, but it's not my choice i only have bed suite
        toPlay = findMin(playerP->bed_suite());
    }
    
    if (toPlay == Card::None) {
        //maybe am still afraid to play the black joker, let's play it by force
        toPlay = find(Card::BlackJoker);
    }
    
    if (toPlay == Card::None) {
#ifdef debugging
        qDebug() << "Error in game play AI 9";
#endif
    }
    
}

void intell_controll::play_not_first() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    //if the bed is bawan and my friend is playing a small bed and am not the last player
    if (playerP->bed_amout() == 9 && beddingSuiteOnTable && (playerP->table_cards_size() < playerP->numOfPlayer() - 1) ) {
        //let's try to play the black joker, or red joker
        if (LargestOnTableID != Card::None) {
            if (playerP->table_cards_at(LargestOnTableID)->cardNum < maxAvailable) {
                play_redJoker();
                if (toPlay == Card::None) {
                    if (rememberIfPlayedCard(Card::RedJoker)) {
                        play_blackJoker();
                    }
                }
            }
        }
    }
    //let's first check if am going to play the joker
    if ( (playerP->table_cards_at(LargestOnTableID)->cardNum >= maxAvailable && (playerP->table_cards_at(LargestOnTableID)->player_id%numOfTeams != pid%numOfTeams)) || (playingSuite != playerP->bed_suite() && beddingSuiteOnTable && (playerP->table_cards_at(LargestOnTableID)->player_id%numOfTeams != pid%numOfTeams))) {
        play_redJoker();
        if (toPlay == Card::None) {
            if (rememberIfPlayedCard(Card::RedJoker) || playerP->table_cards_size() >= (playerP->numOfPlayer() - 1)) {
                if (rememberIfPlayedCard(playerP->bed_suite(),14) || playerP->table_cards_size() >= (playerP->numOfPlayer() - 1)) {
                    play_blackJoker();
                }
            }
        }
    }
    if (toPlay == Card::None) {
        if (countHandSuite(playingSuite) != 0) {
            //I have the card for the playing suite
            play_not_first_have();
        } else {
            //I don't have any card of the playing suite
            play_not_first_dont_have();
        }
    }
    //let's check if there's the black joker from other team I'll try to play the bed suite ace
    int blackJokerID = playerP->findAtTable(Card::BlackJoker);
    if (blackJokerID != Card::None) {
        if (playerP->table_cards_at(blackJokerID)->player_id%numOfTeams != pid%numOfTeams) {
            //if the other team has already played the black joker, I'll try to play bed ace if I can
            if (playingSuite == playerP->bed_suite() || (countHandSuite(playingSuite) == 0 )) {
                //if playing suite was already the bed suite, or i don't have the playing suite, I'll try to play the bed suite ace
                int tempPlay = find(playerP->bed_suite(),14);
                if (tempPlay != Card::None) {
                    toPlay = tempPlay;
                }
            }
        }
    }
    //second thing, after everything, we'll check if all my cards are large, I'll just plainly play the black or red joker
    if (all_papers_shaiks()) {
        if ( ( (playerP->myHandcards_at(toPlay)->cardNum >= maxAvailable
              &&
              playerP->myHandcards_at(toPlay)->typ == playerP->bed_suite()) || playerP->myHandcards_at(toPlay)->typ == playingSuite)
            
            ||
            (!beddingSuiteOnTable && playerP->myHandcards_at(toPlay)->typ == playerP->bed_suite()) ) {
            
            int toPlayTemp = toPlay;
            play_redJoker();
            if (toPlay == Card::None) {
                play_blackJoker();
            }
            if (toPlay == Card::None) {
                toPlay = toPlayTemp;
            }
        }
    }
}

//end of play options, more general

//play a card, here shall be the calculation for playing a card
void intell_controll::play_card() {
#ifdef debugging
    printf("%s \n", __func__);
    qDebug() << "PLAYER ID " << pid;
#endif
    //used to update some of the variables
    updateEveryRound();
    //I'll setUp static Variables
    setUpStaticVariables();
    myTurn = true;
    toPlay = Card::None;
    //if am the first player
    if (playerP->myHandcards_size() == 1) {
        //I only have one card no need for calculation
        toPlay = 0;
    } else {
        if (playerP->table_cards_size() == 0 || playingSuite == Card::None) {
            if (gameNumber == 0 && playerP->table_cards_size() == 0) {
                //am the bidder, am going to play my first card
                play_bedderStart();
            } else {
                //am first one, It's not the first game
                play_first();
            }
        } else {
            //am not the first player, am restricted to some cards only
            play_not_first();
        }
    }
}


//max card at my hand
int intell_controll::findMax(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int max = Card::None;
    for (int i = 0; i<playerP->myHandcards_size(); i++) {
        if  (playerP->myHandcards_at(i)->typ == cardtype) {
            //compare it with the max
            if (max == -1) {
                max = i;
            }
            else {
                if  (playerP->myHandcards_at(i)->cardNum > playerP->myHandcards_at(max)->cardNum) {
                    max = i;
                }
            }
        }
    }
    return max;
}
//min card at my hand
int intell_controll::findMin(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int min = -1;
    for (int i = 0; i < playerP->myHandcards_size(); i++) {
        if  (playerP->myHandcards_at(i)->typ == cardtype) {
            //compare it with the min
            if (min == -1) {
                min = i;
            } else {
                if  (playerP->myHandcards_at(i)->cardNum < playerP->myHandcards_at(min)->cardNum) {
                    min = i;
                }
            }
        }
    }
    return min;
}
//mid card at my hand
int intell_controll::findMid(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    if (countHandSuite(cardtype) < 3) {
        if (findLargerThan(cardtype,8) != -1) {
            if  (playerP->myHandcards_at(findLargerThan(cardtype,8))->cardNum == 13) {
                return findMin(cardtype);
            }
        }
    }
    if (playerP->numOfPlayer() > 4) {
        //kout bo 6
        return findLargerThan(cardtype,7);
    } else {
        //kout bo 4
        return findLargerThan(cardtype,9);
    }
}
//find specific card in my hand
int intell_controll::find(Card::cardType cardtype, int value) {
    for (int i = 0; i < playerP->myHandcards_size(); i++) {
        if (value == 0) {
            //search anycard of that number
            if  (playerP->myHandcards_at(i)->typ == cardtype) {
                return i;
            }
            
        } else {
            //search that specific number
            if  (playerP->myHandcards_at(i)->typ == cardtype && playerP->myHandcards_at(i)->cardNum == value) {
                return i;
            }
        }
    }
    //this function should return -1 in case, no card found
    return Card::None;
}
//return true if this card is already played
bool intell_controll::rememberIfPlayedCard(Card::cardType cardtype, int value) {
    for (int i = 0; i < playerP->cards_size(); i++) {
        if (value == 0) {
            //search anycard of that suite
            if (playerP->cards_at(i)->typ == cardtype && playerP->cards_at(i)->cardWithDealer()) {
                return true;
            }
            
        } else {
            //search that specific number
            if (playerP->cards_at(i)->typ == cardtype && playerP->cards_at(i)->cardNum == value && playerP->cards_at(i)->cardWithDealer()) {
                return true;
            }
        }
    }
    //this function should return false in case, no card found
    return false;
}
//find a cards larger than the value sent, it will find the smallest one larger than this card, if you want the max card, use max instead, if 0 is sent the function will return the min card, return -1 if no found
int intell_controll::findLargerThan(Card::cardType cardtype, int value) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int minValue = value;
    int min_id = Card::None;
    for (int i = 0; i < playerP->myHandcards_size(); i++) {
        //search that specific number
        if  (playerP->myHandcards_at(i)->typ == cardtype && playerP->myHandcards_at(i)->cardNum >= value) {
            if (min_id == Card::None) {
                //it's the first time, we'll save it
                min_id = i;
                minValue = playerP->myHandcards_at(min_id)->cardNum;
            }
            if  (playerP->myHandcards_at(i)->cardNum <= minValue) {
                //we found a new min, let's save it
                min_id = i;
                minValue = playerP->myHandcards_at(min_id)->cardNum;
            }
        }
        
    }
    //this function should return -1 in case, no card found
    return min_id;
}
//count cards of that suite
int intell_controll::countHandSuite(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int count = 0;
    for (int i = 0; i < playerP->myHandcards_size(); i++) {
        //search anycard of that suite
        if  (playerP->myHandcards_at(i)->typ == cardtype) {
            count++;
        }
    }
    //this function should return 0 in case, no card found
    return count;
}

bool intell_controll::suiteExistWithOtherTeam(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < playerP->numOfPlayer(); i++) {
        //if this player is the opposite team I'll proceed to check his cards
        if (pid%numOfTeams != i%numOfTeams) {
            //this player is not in my team,yay I'll scan his cards
            if (!playerP->players(i)->dontHave(cardtype)) {
                //if the player have this suite, we'll just return true
                return true;
            }
        }
        
    }
    
    //this function should return false in case, no card found
    return false;
}

bool intell_controll::suiteExistWithMyTeam(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    for (int i = 0; i < playerP-> numOfPlayer(); i++) {
        //if this player is in my team I'll proceed to check his cards
        if (pid%numOfTeams == i%numOfTeams) {
            //this player is in my team,yay I'll scan his cards
            if (i != pid) {
                //it's not me
                if (!playerP->players(i)->dontHave(cardtype)) {
                    //if the player have this suite, we'll just return true
                    return true;
                }
            }
        }
    }
    //this function should return false in case, no card found
    return false;
}

void intell_controll::setUpStaticVariables () {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    //saving all other suites than the bed suite in an array to treat them
    if (playerP->bed_suite() == Card::Heart) {
        intell_controll::suites[0] = Card::Spade;
        intell_controll::suites[1] = Card::Club;
        intell_controll::suites[2] = Card::Diamond;
    } else if (playerP->bed_suite() == Card::Diamond) {
        intell_controll::suites[0] = Card::Spade;
        intell_controll::suites[1] = Card::Club;
        intell_controll::suites[2] = Card::Heart;
    } else if (playerP->bed_suite() == Card::Club) {
        intell_controll::suites[0] = Card::Spade;
        intell_controll::suites[1] = Card::Heart;
        intell_controll::suites[2] = Card::Diamond;
    } else if (playerP->bed_suite() == Card::Spade) {
        intell_controll::suites[0] = Card::Heart;
        intell_controll::suites[1] = Card::Club;
        intell_controll::suites[2] = Card::Diamond;
    }
}

void intell_controll::updateEveryRound() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    //now let's save the game number, total game plays last time cards have been dealt by the dealer
    if (playerP->table_cards_size() > 0) {
        beddingSuiteOnTable = false;
        maxAvailable = findLargestNotPlayed(playingSuite);
        LargestOnTableID = findLargestOnTable();
        if (LargestOnTableID >= 0 && LargestOnTableID < playerP->table_cards_size()) {
            if (playerP->table_cards_at(LargestOnTableID)->typ == playerP->bed_suite()) {
                //largest card is from the bedding suite
                maxAvailable = findLargestNotPlayed(playerP->bed_suite());
                beddingSuiteOnTable = true;
            }
        }
    }
    intell_controll::gameNumber =  Player::team_eats(0) + Player::team_eats(1);
    //let's save the remaining number of eats we need
    if (playerP->bed_team() == pid%numOfTeams) {
        //if we are the team that is bedding
        intell_controll::remaining_eats = playerP->bed_amout() - Player::team_eats(pid%numOfTeams);
        intell_controll::enemy_remaining_eats = (10-playerP->bed_amout()) - Player::team_eats(playerP->opposite_team(pid%numOfTeams));
    } else {
        intell_controll::remaining_eats = (10 - playerP->bed_amout()) - Player::team_eats(pid%numOfTeams);
        intell_controll::enemy_remaining_eats = playerP->bed_amout() - Player::team_eats(Player::opposite_team(pid%numOfTeams));
    }
    //bed suite cards outside my hand
    intell_controll::minCard = 2;
    if (playerP-> numOfPlayer() == 6) {
        intell_controll::bedSuiteCards = 13;
    } else if (playerP-> numOfPlayer() == 4) {
        if (playerP->bed_suite() == Card::Heart || playerP->bed_suite() == Card::Spade) {
            intell_controll::bedSuiteCards = 9;
            intell_controll::minCard = 6;
        } else {
            intell_controll::bedSuiteCards = 8;
            intell_controll::minCard = 7;
        }
    } else {
#ifdef debugging
        qDebug() << "Error, unknowen number of players";
#endif
    }
    //we'll just remove the already played card of this suite
    for (int i = 14; i >= minCard; i--) {
        if (rememberIfPlayedCard(playerP->bed_suite(),i)) {
            // a card has already been played
            intell_controll::bedSuiteCards--;
        }
    }
    intell_controll::bedSuiteCards -= countHandSuite(playerP->bed_suite());
    playingSuite = Card::None;
    if (playerP->table_cards_size() > 0) {
        playingSuite = playerP->table_cards_at(0)->typ;
        if (playingSuite == Card::RedJoker) {
            if (playerP->bed_amout() > 7 && (playerP->table_cards_at(0)->player_id%numOfTeams == playerP->bed_team()) ) {
                playingSuite = playerP->bed_suite();
            } else {
                //Red Joker has no meaning this time
                if (playerP->table_cards_size() > 1) {
                    playingSuite = playerP->table_cards_at(1)->typ;
                    if (playingSuite == Card::BlackJoker) {
                        if (playerP->table_cards_size() > 2) {
                            playingSuite = playerP->table_cards_at(2)->typ;
                        } else {
                            playingSuite = Card::None;
                        }
                    }
                } else {
                    playingSuite = Card::None;
                }
            }
        }
        
        if (playingSuite == Card::BlackJoker) {
            if (playerP->bed_amout() > 8 && (playerP->table_cards_at(0)->player_id%numOfTeams == playerP->bed_team()) ) {
                playingSuite = playerP->bed_suite();
            } else {
                //Black Joker has no meaning this time
                if (playerP->table_cards_size() > 1) {
                    playingSuite = playerP->table_cards_at(1)->typ;
                    if (playingSuite == Card::RedJoker) {
                        if (playerP->table_cards_size() > 2) {
                            playingSuite = playerP->table_cards_at(2)->typ;
                        } else {
                            playingSuite = Card::None;
                        }
                    }
                } else {
                    playingSuite = Card::None;
                }
            }
        }
    }
    
}
//returns the value of the largest card that is not played, for security reasons, no one is allowed to know for whoem this card belows, he just knows
int intell_controll::findLargestNotPlayed(Card::cardType cardtype) {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int maxValue = 0;
    for (int i = 0; i < playerP->cards_size(); i++) {
        if (playerP->cards_at(i)->typ == cardtype && playerP->cards_at(i)->cardNum >= maxValue && playerP->cards_at(i)->cardWithPlayer()) {
            maxValue = playerP->cards_at(i)->cardNum;
        }
    }
    //this function should return 0 in case, no card found
    return maxValue;
}

int intell_controll::findLargestOnTable() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    int maxId = 0;
    if (Player::table_cards_at(0)->typ == Card::RedJoker) {
        if (Player::bed_amout() > 7 && (Player::table_cards_at(0)->player_id%numOfTeams == Player::bed_team()) ) {
            //nothing, it's all right, because they are the team who bed, and they bedded 8 or above
            return 0; // id of first card, sure in this case joker is largeset, let's skip all other tests
        } else {
            //Red Joker has no meaning this time
            if (Player::table_cards_size() > 1) {
                maxId = 1;
                if (Player::table_cards_at(1)->typ == Card::BlackJoker) {
                    if (Player::table_cards_size() > 2) {
                        maxId = 2;
                    } else {
                        maxId = -1;
                    }
                }
            } else {
                // if it's not the case, pretend like joker is not there, player who played it is foolish
                maxId = -1;
            }
        }
    }
    
    if (Player::table_cards_at(0)->typ == Card::BlackJoker) {
        if (Player::bed_amout() > 8 && (Player::table_cards_at(0)->player_id%numOfTeams == Player::bed_team()) ) {
            //nothing, it's all right, because they are the team who bed, and they bedded 8 or above
        } else {
            //Black Joker has no meaning this time
            if (Player::table_cards_size() > 1) {
                maxId = 1;
                if (Player::table_cards_at(1)->typ == Card::RedJoker) {
                    return 1; // id of the joker, it's the largest, no need to check
                }
            } else {
                maxId = -1;
            }
        }
    }
    
    for (int i = maxId; i >= 0 && i < Player::table_cards_size(); i++) {
        //search that specific suite
        //first if we found a joker
        if (Player::table_cards_at(i)->typ == Card::RedJoker) {
            return i;
        } else if (Player::table_cards_at(i)->typ == Card::BlackJoker) {
            if (Player::table_cards_at(maxId)->typ == Player::bed_suite() && Player::table_cards_at(maxId)->cardNum == 14) {
                //ace of the bedding suite, do nothing
            } else {
                //max is black joker
                maxId = i;
            }
            
        } else if (Player::table_cards_at(i)->typ == Player::bed_suite()) {
            if (Player::table_cards_at(maxId)->typ == Card::BlackJoker && Player::table_cards_at(i)->cardNum < 14) {
                //black joker bigger than all of them, do nothing
            } else {
                if (Player::table_cards_at(maxId)->typ == Player::bed_suite()) {
                    if (Player::table_cards_at(i)->cardNum >= Player::table_cards_at(maxId)->cardNum) {
                        maxId = i;
                    }
                } else {
                    //if the max isn't from the bedding suite, also not the black joker, sure it's greater
                    maxId = i;
                }
            }
        } else if (Player::table_cards_at(i)->typ == playingSuite) {
            if (Player::table_cards_at(maxId)->typ == Player::bed_suite() || Player::table_cards_at(maxId)->typ == Card::BlackJoker); //do nothing, no need because these are bigger
            else {
                if  (maxId < 0) {
                    maxId = i;
                } else {
                    if (Player::table_cards_at(i)->cardNum >= Player::table_cards_at(maxId)->cardNum) {
                        maxId = i;
                    }
                }
            }
        }
    }
    
    //this function should return -1 in case, no card found
    return maxId;
}

//this function should return true, if I have papers, that are all larger than others, so that I better use the black joker, or red joker
bool intell_controll::all_papers_shaiks() {
#ifdef macdebugging
    printf("%s \n", __func__);
#endif
#ifdef debugging
    qDebug() << Q_FUNC_INFO;
#endif
    bool retValue = false;
    if (playerP->myHandcards_size() < 7) {
        //this is used to save if  we are done with this type or not
        bool types[4] = {false,false,false,false};
        //this is used to show that we have this kind of paper, or type
        bool found[4] = {false,false,false,false};
        //a for loop for the four kinds of papers
        for (int i = 0; i < 4; i ++) {
            int j = 2;
            if (playerP->numOfPlayer() < 6) {
                //it's kout of 4 players only
                if (i == Card::Spade || i == Card::Heart) {
                    //6 is included in these types but not others
                    j = 6;
                } else {
                    j = 7;
                }
            }
            int tempcardID;
            int countThat = 0;
            
            Card::cardType type;
            if (i == Card::Heart) {
                type = Card::Heart;
            }
            if (i == Card::Spade) {
                type = Card::Spade;
            }
            if (i == Card::Diamond) {
                type = Card::Diamond;
            }
            if (i == Card::Club) {
                type = Card::Club;
            }
            
            for (int val = findLargestNotPlayed(type) ; val >= j; val--) {
                tempcardID = find(type,val);
                if (tempcardID == Card::None) {
                    val = 0;
                } else {
                    //there's a card that have been found here
                    found[i] = true;
                    countThat++;
                }
            }
            //now we have already counted shaiks in that kind, we'll do count the cards outside with others
            for (int val = 0; val < playerP->cards_size(); val++) {
                if (playerP->cards_at(val)->typ == type
                    && playerP->cards_at(val)->cardWithPlayer()
                    && (playerP->cards_at(val)->player_id_holding_card() != pid)
                    ) 
                {
                    countThat--;
                }
            }
            if (countThat >= 0) {
                //success, this type am shaik of it
                types[i] = true;
            }
        }
        //        for (int i = 0; i < playerP->myHandcards_size(); i++) {
        //            if  (playerP->myHandcards_at(i)->typ == Card::Spade || playerP->myHandcards_at(i)->typ == Card::Heart || playerP->myHandcards_at(i)->typ == Card::Diamond || playerP->myHandcards_at(i)->typ == Card::Club) {
        //                //if this card, is one of these types, I'll check if there's a larger card outside this card
        //                //let's check if we are already done with this type, we'll do nothing, if not we'll proceed to check
        //                if (!types[playerP->myHandcards_at(i)->typ]) {
        //                    //let's make it true this time temprory, if my card is the greatest, I'll leave it true, and won't check again for this type
        //                    types[playerP->myHandcards_at(i)->typ] = true;
        //                    found[playerP->myHandcards_at(i)->typ] = true;
        //                    int largest = findLargestNotPlayed (playerP->myHandcards_at(i)->typ);
        //                    //if my card is smaller, I'll just make it false, and check another card
        //                    if  (playerP->myHandcards_at(i)->cardNum < largest) {
        //                        types[playerP->myHandcards_at(i)->typ] = false;
        //                    }
        //                }
        //            }
        //        }
        for (int i = 0; i < 4; i++) {
            if (!found[i]) {
                types[i] = true;
            }
        }
        retValue = true;
        for (int i = 0; i < 4; i++) {
            if (!types[i]) {
                retValue = false;
            }
        }
        //there's some other conditions also, if there's any bed suite outside mines not shaiks, also if there's the jokers not played mines not shaikes
        if (!found[playerP->bed_suite()]) {
            if (bedSuiteCards != 0) {
                return false;
            }
        }
        if (find(Card::RedJoker) == Card::None) {
            if (!rememberIfPlayedCard(Card::RedJoker)) {
                return false;
            }
        }
        if (find(Card::BlackJoker) == Card::None) {
            if (!rememberIfPlayedCard(Card::BlackJoker)) {
                return false;
            }
        }
    }
    return retValue;
}

