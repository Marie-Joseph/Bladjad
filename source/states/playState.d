/**
 * Bladjad - A blackjack game in D. Because we're replacin' the 'c's, 'kays?
 *
 * Art from https://mapsandapps.itch.io/synthwave-playing-card-deck-assets
 *
 * Author: Marie-Joseph
 * Year: 2020
 * License: CC0 (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
 */

/**
 * Play State - handles the game of blackjack itself
 */

/* Phobos imports */
import std.format : format;
import std.stdio : writeln;

/* Dgame imports */
// In State superclass

/* Project imports */
import Bladjad;
import cardSprite;
import deck;
import hand;
import stateMachine;
import state;

class PlayState : State {

    private {
        StateMachine gStateMachine;

        Font instFont;
        Text instText;

        Font endFont;
        Text endText;
        Text restartText;
        Text bustText;
        Text blackjackText;
        bool ended;

        Deck deck;

        CardSprite cardBackSprite;

        Hand playerHand;
        Hand dealerHand;

        string instString = "H: hit   S: stand   M: menu";

        bool stood;
        bool firstRun;
    }

    override void enter(StateMachine gStateMachine) {
        this.gStateMachine = gStateMachine;

        cardBackSprite = new CardSprite("images/cards/back.png");
        cardBackSprite.setPosition(WndDim.width - cardBackSprite.width - 25,
                                   (WndDim.height / 2) - (cardBackSprite.height / 2));

        deck = new Deck();

        playerHand = new Hand(gStateMachine, true);
        dealerHand = new Hand(gStateMachine);

        instFont = Font("fonts/ExpressionPro.ttf", 20);
        instText = new Text(instFont, instString);
        instText.mode = Font.Mode.Shaded;
        instText.foreground = Color4b(0x00FFFF);
        instText.background = Color4b(0x143D4C);
        instText.update();
        // instText.setPosition(5, 5);
        instText.setPosition(WndDim.width - instText.width - 5, WndDim.height - instText.height - 5);

        endFont = Font("fonts/ExpressionPro.ttf", 72);
        endText = new Text(endFont, "Placeholder");
        endText.mode = Font.Mode.Shaded;
        endText.foreground = Color4b(0x00FFFF);
        endText.background = Color4b(0x143D4C);

        restartText = new Text(instFont, "Press 'r' to restart, 'm' for menu");
        restartText.mode = Font.Mode.Shaded;
        restartText.foreground = Color4b(0x00FFFF);
        restartText.background = Color4b(0x143D4C);
        restartText.update();

        bustText = new Text(endFont, "BUST");
        bustText.mode = Font.Mode.Shaded;
        bustText.foreground = Color4b(0x00FFFF);
        bustText.background = Color4b(0x143D4C);
        bustText.update();
        bustText.setPosition((WndDim.width / 2) - (bustText.width / 2),
                             WndDim.height - (bustText.height * 3));

        blackjackText = new Text(endFont, "BLACKJACK");
        blackjackText.mode = Font.Mode.Shaded;
        blackjackText.foreground = Color4b(0x00FFFF);
        blackjackText.background = Color4b(0x143D4C);
        blackjackText.update();
        blackjackText.setPosition((WndDim.width / 2) - (blackjackText.width / 2),
                                  WndDim.height - (blackjackText.height * 3));

        firstRun = true;
    }

    override void update(Event event, ref Window wnd) {
        switch (event.keyboard.key) {
            case Keyboard.Key.H:
                if (!stood)
                    playerHit(wnd);
                break;

            case Keyboard.Key.M:
                stood = false;
                ended = false;
                gStateMachine.change("Start");
                break;

            case Keyboard.Key.R:
                stood = false;
                ended = false;
                gStateMachine.change("Play");
                break;

            case Keyboard.Key.S:
                playerStand(wnd);
                break;

            default: break;
        }
    }

    override void render(ref Window wnd) {
        if (firstRun) {
            firstRun = false;
            playerHit(wnd); hit(wnd); playerHit(wnd); hit(wnd);
        }

        wnd.draw(cardBackSprite);
        foreach(card; playerHand) {
            wnd.draw(card);
        }
        playerHand.reset();
        foreach(card; dealerHand) {
            wnd.draw(card);
        }
        dealerHand.reset();
        if (ended) {
            wnd.draw(endText);
            wnd.draw(restartText);
        } else {
            wnd.draw(instText);
        }
        if (playerHand.hasBusted())
            wnd.draw(bustText);
        else if (playerHand.curScore() == 21)
            wnd.draw(blackjackText);
    }

    override void exit() {
        playerHand.finish();
        dealerHand.finish();
        deck.destroy();
        cardBackSprite.destroy();
        instText.destroy();
        endText.destroy();
        bustText.destroy();
        blackjackText.destroy();
    }

    private void playerHit(ref Window wnd) {
        if (deck.empty)
            deck.shuffle();

        playerHand.add(deck.draw(), wnd);
        if (playerHand.hasBusted || (playerHand.curScore == 21))
            playerStand(wnd);
    }

    private void hit(ref Window wnd) {
        if (deck.empty)
            deck.shuffle();

        dealerHand.add(deck.draw(), wnd);
    }

    private void playerStand(ref Window wnd) {
        stood = true;
        uint dealerScore;
        while ((dealerScore = dealerHand.curScore()) < 17) {
            hit(wnd);

        }
        bool dealerBust = dealerHand.hasBusted();

        uint playerScore = playerHand.curScore();
        bool playerBust = playerHand.hasBusted();

        if (dealerBust) {
            if (playerBust) {
                tie();
            } else {
                playerVictory();
            }
        } else if (playerBust) {
            playerLoss();
        } else if (playerScore == dealerScore) {
            tie();
        } else if ((playerScore == 21) || (playerScore > dealerScore)) {
            playerVictory();
        } else {
            playerLoss();
        }
    }

    private void tie() {
        setEndText("It's a draw!");
    }

    private void playerVictory() {
        setEndText("You win!");
    }

    private void playerLoss() {
        setEndText("You lose...");
    }

    private void setEndText(string toWrite) {
        endText.setData(toWrite);
        endText.update();
        endText.setPosition((WndDim.width / 2) - (endText.width / 2),
                            (WndDim.height / 2) - (endText.height / 2));
        restartText.setPosition((WndDim.width / 2) - (restartText.width / 2),
                                endText.y + endText.height + 5);
        ended = true;
    }
}

