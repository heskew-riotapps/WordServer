﻿//$.namespace('Riot.Resource');

Riot.Resource =
{
    GeneralErrorTitle: "Sorry...",
    FBNotEntered: "Oops! Please enter your feedback before saving.",
    RmdTitle: "Remind {0}?",
    RmdText: "Just a reminder that {0} moved {1} days ago. It's your turn!",
    Games_Declined: "{0} declined a game",
    Games_DeclinedAuto: "A game was declined for {0} after 21 days",
    Games_Tied: "you tied {0}",
    Games_Won: "you beat {0}",
    Games_Lost: "{0} won",
    Games_Conceded: "{0} conceded",
    Games_RmdRollover: "Send a reminder to {0} to take a turn!",
    Games_ChRollover: "{0} has added some chatter!",
    PNScores: "scores (of completed games)",
    PNStart: "start a game",
    PNRules: "rules",
    PNBadges: "badges",
    PNTerms: "terms and conditions",
    PNPrivacy: "privacy policy",
    PNFeedback: "leave us feedback",
    PNStats: "stats and rivalries",
    OK: "OK",
    Cancel: "Cancel",

    
    SBNumOverlays: "number of overlay left for {0}",
    SBWinner: "WINNER!",
    SBOverlayLeft: "1 overlay left",
    SBOverlaysLeft: "{0} overlays left",
    SBOverlaysLeftRollover: "number of overlays left for {0}",
    SBLettersLeft: "LETTERS LEFT: {0}",
    SBPotentialPoints: "POINT COUNT",
    Definition: "DEFINITION",
    OppXWins: "({0} wins)",
    Opp1Win: "(1 win)",
    StartChatter: "To chatter with {0} just type your message below and hit the Enter key or click Send.",
    NoChatter: "This game with {0} was chatter free.",
    OppRecord: "Your stats against {0}:",
    Letters: "these 3 consonants and 2 vowels ({0}{1}) were the random letters chosen and added to the hopper when this game was started",
    NoScoresO: "You have not completed any games with {0} yet.",
    WordPlayedBy: "by {0} in turn {1} for {2} points",
    SBPotentialPointsOver: "The number of points you will potentially earn on this turn based on the letters you have placed on the board IF AND ONLY IF your words are all valid (and you don't exceed your overlay limit), not including any potential end of game bonuses.",
    SBWordsBtnRollover: "Review the words that have been played in this game.  You'll also be able to look up their definitions.",
    SBWordsBtn: "LOOKUP WORDS",
    SBBackToGameBtn: "BACK TO GAME",
    SBBackToGameBtnOver: "Return to the game board",
    SBBackToWordsBtn: "BACK TO WORD LIST",
    PGBackToGame: "<< game vs. {0}",

    AlertTitle: "Alert!",
    OtherAlertTitle: "<div style='margin-top:12px;'>Other Alerts...</div>",
    AlertLine: "<div style='margin-bottom:5px;'>{0}</div>",
    AlertTitleAndLine: "<div style='margin-top:5px;'>{0}</div><div>{1}</div>",
    
    RailMainTabGame: "<div><span class='rTabTurn {0}' title=\"{1}\" style='display:{2};'>&nbsp;&nbsp;&nbsp;</span><span>You vs.</span></div><div><span class='rTabTurn {3}'  title=\"{4}\" style='display:{5};'>&nbsp;&nbsp;&nbsp;</span><span>{6}</span></div>",
    RRPOver: "this is the number of active games in which it's your turn",
    RROOver: "this is the number of active games in which it's your opponents' turn",
    SBBackToWordsBtnOver: "Return to the list of played words",
    LookupWord: "Look up the definition of {0}",
    DefNotFound: "Oops....we're sorry but we couldn't find the definition of \"{0}\".  Since our \"valid word\" source is different from our source for definitions, sometimes this will happen.  Also, it is occasionally challenging to find the definition of certain variations of words.",
    PTurn: "it's your turn...",
    OTurn: "it's {0}'s turn...",
    SkipTurn: "SKIP",
    SkipTurnTitle: "Forfeit this turn without playing or swapping any letters.",
    PlayTurn: "PLAY",
    PlayTurnTitle: "Play the word(s) you have formed and rack up the points.",
    SwapTurnTitle: "Swap allows you to exchange letters in your tray.",
    SwapTurnHopperEmpty: "Swap allows you to exchange letters in your tray.  But only when your tray is full and there are letters left in the hopper.",
    SwapTurnTitle: "Exchange letters in your tray.  But forfeit this turn, of course.",
    RematchTurnTitle: "Challenge {0} to another game!",
    RematchTurn: "Challenge {0} to a Rematch",
    SwapEmptyTitle: "Swap Letters",
    SwapEmptyText: "You didn't choose any letters to exchange.  If you want to swap some letters just click Swap again and click on the letters you want to exchange.",
    CancelTurn: "CANCEL",
    CancelTurnTitle: "If you have changed your mind and don't want to play this game with {0}, no problem...just cancel it.  You will only get one chance to cancel a game, however.",
    ConcedeTurn: "CONCEDE",
    ConcedeTurnTitle: "Give up. Surrender. Cry uncle. Throw in the towel. Wave the white flag.",
    NotTurnTitle: " (But only when it's your turn.)",
    DeclineTurn: "DECLINE",
    DeclineTurnTitle: "If you don't want to play this game with {0}, no problem...just decline it.  You will only get one chance to decline a game, however.",
    PlayBtn: "Play Now",
    PlayBtnTitle: "Play Now",
    PlayBtnTitleNotTurn: "Play Now",
    SkipBtn: "Skip Now",
    SkipTitle: "Skip this turn?",
    SkipText: "You didn't place any letters. Are you sure you want to skip this turn?",
    CancelBtn: "Cancel Game Now",
    CancelTitle: "Cancel this game?",
    CancelText: "Are you sure you want to cancel this game?",
    DeclineBtn: "Decline Now",
    DeclineTitle: "Decline this game?",
    DeclineText: "Are you sure you want to decline this game?",
    ConcedeBtn: "Concede Now",
    ConcedeTitle: "Concede this game?",
    ConcedeText: "Are you sure you want to concede this game?",
  
    NoThanks: "No Thanks",
    
    SwapTitle: "Swap Letters",
    SwapBtn: "Swap Now",
    PGameLimitText: "<div>You have reached the limit of 40 active games.  Thanks very much for playing!</div>",
    OGameLimitText: "<div>This opponent has reached the limit of 40 active games.</div>",
    InvalidGapTitle: "Sorry...",
    InvalidGapText: "<div>Please make sure there are no gaps between your letters.</div>",
    InvalidCountTitle: "Sorry...",
    InvalidCountText: "<div>Please form a word at least 2 letters long.</div>",
    InvalidAxisTitle: "Sorry...",
    InvalidAxisText: "<div>Please be sure to place letters in a single axis with no gaps between letters.</div>",
    InvalidStartTitle: "Sorry...",
    InvalidStartText: "<div>To get started, at least one letter must be placed on a smiley.</div>",
    InvalidMoveTitle: "Sorry...",
    InvalidChatterTitle: "Sorry...",
    InvalidMoveText: "<div>Your letters must touch at least one already placed letter.</div>",
    ConfirmationTitle: "Are you sure?",
    ConfirmationText: "<div style='margin-bottom:3px;'>You are about to play</div>{0}",
    ConfirmationWord: "<div style='margin-left:30px;'>{0}</div>",
    Months:
        ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    FindFriend: " search for an opponent...",
    InviteTitle: "Challenge {0}?",
    InviteText: "{0} has started a WordRiot game with you.  Are you ready for the challenge?",
    Badge_0: "No wins yet",
    Badge_1: "Between 1 and 9 wins",
    Badge_10: "Between 10 and 24 wins",
    Badge_25: "Between 25 and 49 wins",
    Badge_50: "Between 50 and 74 wins",
    Badge_75: "Between 75 and 99 wins",
    Badge_100: "Between 100 and 149 wins",
    Badge_150: "Between 150 and 199 wins",
    Badge_200: "Between 200 and 249 wins",
    Badge_250: "Between 250 and 299 wins",
    Badge_300: "Between 300 and 349 wins",
    Badge_350: "Between 350 and 399 wins",
    Badge_400: "Between 400 and 449 wins",
    Badge_450: "Between 450 and 499 wins",
    Badge_500: "Between 500 and 599 wins",
    Badge_600: "Between 600 and 699 wins",
    Badge_700: "Between 700 and 799 wins",
    Badge_800: "Between 800 and 899 wins",
    Badge_900: "Between 900 and 999 wins",
    Badge_1000: "Between 1000 and 1249 wins",
    Badge_1250: "Between 1250 and 1499 wins",
    Badge_1500: "Between 1500 and 1749 wins",
    Badge_1750: "Between 1750 and 1999 wins",
    Badge_2000: "Between 2000 and 2499 wins",
    Badge_2500: "Between 2500 and 2999 wins",
    Badge_3000: "Between 3000 and 3999 wins",
    Badge_4000: "Between 4000 and 4999 wins",
    Badge_5000: "5000 or more wins",

}