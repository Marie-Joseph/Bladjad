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
 * Deck - playing card deck object
 */

/*
 * This is a simple 52-playing-card deck in D with a custom shuffle.
 *
 * The scheme for the card codes is as follows: [suit][value]
 * So "D2" is the two of diamonds, "SQ" is the queen of spades, etc. 10 is 'X'.
 *
 * If you plan to use this elsewhere, note that it avoids exceptions and achieves
 * memory safety by, essentially, ignoring commands. Nothing happens if you call
 * `riffle` or its wrappers with a single card, and the string "empty" is returned
 * on calls to `front` if `empty` returns `true`, for example.
 * Note that garbage collection cannot be avoided because a reference array is
 * required and the idiomatic way to duplicate one requires GC.
 */

/* Phobos imports */
import std.random : Random, unpredictableSeed;
import std.uni : isAlpha;

nothrow @safe class Deck {

    private {
        Random rand;
        string[] deck;
        size_t frontIndex;
        immutable string[52] cards = [
        "SA", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "SX", "SJ", "SQ", "SK",
        "CA", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "CX", "CJ", "CQ", "CK",
        "HA", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "HX", "HJ", "HQ", "HK",
        "DA", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "DX", "DJ", "DQ", "DK"];
    }

    nothrow @safe this() {
        rand.seed(unpredictableSeed);
        deck = cards.dup();
        shuffle();
    }

    /* Core functions */

    nothrow @safe @nogc string draw() {
        string topCard = front();
        popFront();
        return topCard;
    }

    nothrow @safe void shuffle() {
        if (deck.length != cards.length) { deck = cards.dup(); }
        riffle();
        frontIndex = 0;
    }

    nothrow @safe @nogc void partialShuffle() {
        deck = deck[frontIndex .. $];
        riffle();
        frontIndex = 0;
    }

    // Based on https://fredhohman.com/card-shuffling/
    private nothrow @safe @nogc void riffle() {
        if (deck.length > 1) {
            string bottomCard = deck[$ - 1];
            string topCard;
            size_t newIndex;
            do {
                newIndex = rand.front() % deck.length;
                rand.popFront();

                if (newIndex != 0) {
                    topCard = deck[0];
                    foreach (i; 0 .. newIndex) {
                        deck[i] = deck[i + 1];
                    }
                    deck[newIndex] = topCard;
                }
            } while (topCard != bottomCard);
        }
    }

    /* Convenience functions */

    nothrow @safe string drawAsString() { return cardToString(draw()); }

    nothrow @safe string frontToString() { return cardToString(front()); }

    // Converts the given card to a string of the format "[value] of [suit]"
    nothrow @safe static string cardToString(string card) {
        if (card == "empty") { return card; }

        string cardStr;
        char suit = card[0];
        char value = card[1];

        if (value.isAlpha) {
            switch (value) {
                case ('A'):
                    cardStr ~= "Ace";
                    break;

                case ('X'):
                    cardStr ~= "10";
                    break;

                case ('J'):
                    cardStr ~= "Jack";
                    break;

                case ('Q'):
                    cardStr ~= "Queen";
                    break;

                case ('K'):
                    cardStr ~= "King";
                    break;

                default:
                    break;
            }
        } else {
            cardStr ~= value;
        }

        cardStr ~= " of ";

        switch (suit) {
            case ('S'):
                cardStr ~= "Spades";
                break;

            case ('C'):
                cardStr ~= "Clubs";
                break;

            case ('H'):
                cardStr ~= "Hearts";
                break;

            case ('D'):
                cardStr ~= "Diamonds";
                break;

            default:
                break;
        }

        return cardStr;
    }

    /* Range interface */

    nothrow @safe @nogc bool empty() { return frontIndex >= deck.length ? true : false; }

    nothrow @safe @nogc string front() { return !empty ? deck[frontIndex] : "empty"; }

    nothrow @safe @nogc void popFront() { if (!empty) frontIndex++; }

    /* Overrides */

    override string toString() {
        string retStr = "[\"";

        foreach (i, str; deck) {
            retStr ~= str;
            if (i != deck.length - 1) {
                retStr ~= "\", \"";
            } else {
                retStr ~="\"]";
            }
        }

        return retStr;
    }
}
