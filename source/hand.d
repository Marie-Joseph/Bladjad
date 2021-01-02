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
import std.range : front, popFront, empty;
import std.uni : isAlpha;

/* Dgame imports */
import Dgame.Graphic;

/* Project imports */
import bladjad;
import cardSprite;

class Hand
{

    private
    {
        string[] cardNames;
        CardSprite[] cardSprites;

        bool isPlayer;
        uint score;
        bool busted;

        size_t frontIndex;
    }

    /**
     *  Create a new Hand.
     *
     *  Params:
     *      player = bool indicating whether or not this is the player's hand
     *
     *  Returns:
     *      A new Hand
     */
    this(bool player = false)
    {
        this.isPlayer = player;
    }

    /**
     *  Add a card to the Hand.
     *
     *  Params:
     *      card = a two-letter card code
     */
    public void add(string card)
    {
        cardNames ~= card;
        if ((cardSprites.length == 0) && !this.isPlayer)
            cardSprites ~= new CardSprite("images/cards/back.png");
        else
            cardSprites ~= new CardSprite(format!"images/cards/%s.png"(card));
        cardSprites[$ - 1].place(cardSprites.length - 1, isPlayer);
        updateScore();
    }

    /// Flip face-down cards upon the completion of a game.
    public void flip()
    {
        cardSprites[0].updateTexture(format!"images/cards/%s.png"(cardNames[0]));
    }

    private void updateScore()
    {
        uint aces;
        score = 0;
        foreach (name; cardNames)
        {
            if (name[1].isAlpha)
            {
                if (name[1] == 'A')
                {
                    score += 11;
                    aces += 1;
                }
                else
                {
                    score += 10;
                }
            }
            else
            {
                score += to!int(to!string(name[1]));
            }
        }

        while (score > 21)
        {
            if (aces > 0)
            {
                score -= 10;
                aces -= 1;
            }
            else
            {
                busted = true;
                break;
            }
        }
    }

    /// Return true if the Hand has an ace, else false
    public bool hasAce()
    {
        foreach (card; cardNames)
        {
            if (card[0] == 'A')
            {
                return true;
            }
        }
        return false;
    }

    /// Return true if this Hand had busted, else false
    public @property hasBusted()
    {
        return this.busted;
    }

    /// Return this Hand's current score
    public @property curScore()
    {
        return score;
    }

    /// Cleanup function
    public void finish()
    {
        foreach (card; cardSprites)
        {
            card.destroy();
        }
        this.destroy();
    }

    /// Helper function for calculating score
    public void reset()
    {
        frontIndex = 0;
    }

    /// Range interface front function; returns front card of Hand
    public CardSprite front()
    {
        return cardSprites[frontIndex];
    }

    /// Range interface popFront function
    public void popFront()
    {
        frontIndex++;
    }

    /// Range interface empty function
    public bool empty()
    {
        return frontIndex < cardSprites.length ? false : true;
    }
}
