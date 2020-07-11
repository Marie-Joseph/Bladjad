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
 *
 * TODO: Card placement transitions
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
        bool ended;

        Deck deck;

        CardSprite cardBackSprite;
        CardSprite transSprite;
        float spriteScale = 0.75;

        Shape centralLine;

        Hand playerHand;
        Hand dealerHand;

        string instString = "H: hit   S: stand   M: menu";

        bool stood;

        uint waitTime = 1000;
    }

    override void enter(StateMachine gStateMachine) {
        this.gStateMachine = gStateMachine;

        cardBackSprite = new CardSprite("images/cards/back.png");
        cardBackSprite.setPosition(WndDim.width - cardBackSprite.width - 25,
                                   (WndDim.height / 2) - (cardBackSprite.height / 2));

        transSprite = new CardSprite("images/cards/back.png");

        centralLine = new Shape(Geometry.Lines, [
            Vertex(0, WndDim.height / 2),
            Vertex(WndDim.width, WndDim.height / 2)
        ]);
        centralLine.lineWidth = 4;
        centralLine.setColor(Color4b.Red);


        deck = new Deck();

        playerHand = new Hand(true);
        dealerHand = new Hand();

        instFont = Font("fonts/ExpressionPro.ttf", 25);
        instText = new Text(instFont, instString);
        instText.mode = Font.Mode.Shaded;
        instText.background = Color4b(0x9370DB);
        instText.update();
        instText.setPosition(WndDim.width - instText.width - 5, WndDim.height - instText.height - 5);

        endFont = Font("fonts/ExpressionPro.ttf", 50);
        endText = new Text(endFont, "Placeholder");
        endText.mode = Font.Mode.Shaded;
        endText.background = Color4b(0x9370DB);

        renderlessPlayerHit(); hit(); renderlessPlayerHit(); hit();
    }

    override void update(Event event, ref Window wnd) {
        switch (event.keyboard.key) {
            case Keyboard.Key.H:
                if (!stood) {
                    playerHit(wnd);
                }
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
                if (!stood) {
                    playerStand(wnd);
                }
                break;

            default: break;
        }
    }

    override void render(ref Window wnd) {
        wnd.draw(centralLine);
        wnd.draw(cardBackSprite);
        foreach(card; playerHand) {
            wnd.draw(card);
        }
        playerHand.reset();
        foreach(card; dealerHand) {
            wnd.draw(card);
        }
        dealerHand.reset();
        if (ended)
            wnd.draw(endText);
        else
            wnd.draw(instText);
    }

    override void exit() {
        playerHand.finish();
        dealerHand.finish();
        deck.destroy();
        cardBackSprite.destroy();
        transSprite.destroy();
        centralLine.destroy();
        instText.destroy();
        endText.destroy();
    }

    private void playerHit(ref Window wnd) {
        renderlessPlayerHit();
        if (playerHand.hasBusted || (playerHand.curScore == 21))
            playerStand(wnd);
        this.render(wnd);
        wnd.display();
        StopWatch.wait(waitTime);
    }

    private void renderlessPlayerHit() {
        if (deck.empty)
            deck.shuffle();
        playerHand.add(deck.draw());
    }

    private void hit() {
        if (deck.empty)
            deck.shuffle();
        dealerHand.add(deck.draw());
    }

    private void playerStand(ref Window wnd) {
        this.render(wnd);
        wnd.display();
        StopWatch.wait(waitTime);
        stood = true;
        uint dealerScore;
        while ((dealerScore = dealerHand.curScore()) < 17) {
            hit();
            this.render(wnd);
            wnd.display();
            StopWatch.wait(waitTime);

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

    private void setEndText(string toWrite) {
        endText.setData(toWrite);
        endText.update();
        endText.setPosition((WndDim.width / 2) - (endText.width / 2), (WndDim.height / 2) - (endText.height / 2));
        ended = true;
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
}

