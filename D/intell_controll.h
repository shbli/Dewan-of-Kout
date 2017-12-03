#ifndef INTELL_CONTROLL_H
#define INTELL_CONTROLL_H

#include "card.h"
#include "global_keys.h"

class Player;

class intell_controll
{
public:
    Player* playerP;
    intell_controll();
    void takeCardFromDealer(Card* recived_card);
    int cards_count();
    bool human;
    //saves player id
//    short int pid;
    void play_card();
    void clear_hand();
    //ask the player how much he can bed
    int bed(bool force = false);
    bool dontHave[4];
    //variabled for all players to memorize
    //saving all other suites than the bed suite in an array to treat them
    static Card::cardType suites[3];
    //now let's save the game number, total game plays last time cards have been dealt by the dealer
    static short int gameNumber;
    //let's save the remaining number of eats we need
    static short int remaining_eats;
    //let's save the enemy remaining number of eats we need
    static short int enemy_remaining_eats;
    //bed suite cards outside my hand
    static int bedSuiteCards;
    static int minCard;
    static bool redJokerPlayed;
    static bool blackJokerPlayed;
    static Card::cardType playingSuite;
    //not static, specific to each player
    int toPlay;
    static int findLargestOnTable();
    bool tookTurn;
    Card::cardType maxSuite;
    bool myTurn;
    int countHandSuite(Card::cardType cardtype);

private:
    int selectedID;
    bool beddingSuiteOnTable;
    short int maxAvailable;
    int LargestOnTableID;
    int findMax(Card::cardType cardtype);
    int findMid(Card::cardType cardtype);
    int findMin(Card::cardType cardtype);
    int find(Card::cardType cardtype,int value = 0);
    int findLargerThan(Card::cardType cardtype,int value = 0);
    int findLargestNotPlayed(Card::cardType cardtype);
    bool rememberIfPlayedCard(Card::cardType cardtype,int value = 0);
    bool suiteExistWithOtherTeam(Card::cardType cardtype);
    bool suiteExistWithMyTeam(Card::cardType cardtype);
    void setUpStaticVariables ();
    void updateEveryRound();
    void play_a_kind_exist_once();
    void play_any_ace();
    void play_smallest_max_repeated();
    void play_bed_suite_ace();
    void play_bed_suite_mid();
    void play_bed_suite_max();
    void play_bed_suite_min();
    void play_largest_in_game();
    void play_smallest_not_with_others();
    void play_smallest_not_with_friends();
    void play_smallest();
    void play_redJoker();
    void play_blackJoker();
    void play_bedderStart();
    void play_first();
    void play_not_first();
    void play_not_first_have();
    void play_not_first_have_last();
    void play_not_first_have_not_last();
    void play_not_first_dont_have();
    void play_zero_bed_cards();
    void play_remaining_bed_suites();
    bool all_papers_shaiks();

};

#endif // INTELL_CONTROLL_H
