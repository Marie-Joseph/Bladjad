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
 * Hand - manages dealt hands
 */

/* Phobos imports */
import std.array : byPair;
import std.conv : to;
import std.format : format;
import std.range: front, popFront, empty;
import std.uni : isAlpha;

/* Dgame imports */
import Dgame.Graphic;

/* Project imports */
import Bladjad;
import cardSprite;
import stateMachine;

class Hand {

    private {
        StateMachine gStateMachine;

        string[] cardNames;
        CardSprite[] cardSprites;

        bool isPlayer;
        uint score;
        bool busted;

        size_t frontIndex;
    }

    this(StateMachine gStateMachine, bool player = false) {
        this.isPlayer = player;
        this.gStateMachine = gStateMachine;
    }

    public void add(string card, ref Window wnd) {
        cardNames ~= card;
        cardSprites ~= new CardSprite(format!"images/cards/%s.png"(card));
        cardSprites[$ - 1].place(wnd, cardSprites.length - 1, gStateMachine, isPlayer);
        updateScore();
    }

    private void updateScore() {
        uint aces;
        score = 0;
        foreach(name; cardNames) {
            if (name[1].isAlpha) {
                if (name[1] == 'A') {
                    score += 11;
                    aces += 1;
                } else {
                    score += 10;
                }
            } else {
                score += to!int(to!string(name[1]));
            }
        }

        while (score > 21) {
            if (aces > 0) {
                score -= 10;
                aces -= 1;
            } else {
                busted = true;
                break;
            }
        }
    }

    public bool hasAce() {
        foreach (card; cardNames) {
            if (card[0] == 'A') {
                return true;
            }
        }
        return false;
    }

    public @property hasBusted() { return this.busted; }

    public @property curScore() { return score; }

    public void finish() {
        foreach(card; cardSprites) {
            card.destroy();
        }
        this.destroy();
    }

    public void reset() {
        frontIndex = 0;
    }

    public CardSprite front() { return cardSprites[frontIndex]; }

    public void popFront() { frontIndex++; }

    public bool empty() { return frontIndex < cardSprites.length ? false : true; }
}
