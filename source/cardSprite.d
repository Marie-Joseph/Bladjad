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
 * CardSprite - Sprite subclass
 */

/* Phobos imports */
import std.math : abs;

/* Dgame imports */
import Dgame.Graphic : Texture, Sprite, Surface;
import Dgame.System : StopWatch;
import Dgame.Window : Window;

/* Project imports */
import bladjad;

/// A subclass of Sprite to specially handle displaying cards.
class CardSprite : Sprite
{

    private
    {
        Texture tex;
        float scale;
    }

    /**
     * Constructor for CardSprite.
     *
     * Params:
     *  filePath = path to the image of the card
     *  scale = scale to adjust card; for future use
     */
    this(string filePath, float scale = 0.75)
    {
        this.tex = Texture(Surface(filePath));
        super(tex);
        this.scale = scale;
        this.setScale(scale, scale);
    }

    /// Scaled width of the CardSprite for accurate placement.
    @property float width()
    {
        return tex.width() * scale;
    }

    /// Scaled height of the CardSprite for accurate placement.
    @property float height()
    {
        return tex.height() * scale;
    }

    /**
     *  Place a CardSprite on the board.
     *
     *  Params:
     *      numPlayed = integer indicating order of card played; for future use
     *      playerCard = bool indicating if this card is for the player
     */
    public void place(size_t numPlayed, bool playerCard = false)
    {
        const float startX = WndDim.width - this.width - 25;
        const float startY = (WndDim.height / 2) - (this.height / 2);

        float endX;
        if (playerCard)
            endX = (((WndDim.width * 3) / 4) - this.width) - (((this.width * 2) / 5) * numPlayed);
        else
            endX = ((WndDim.width / 4) + ((this.width * 2) / 5) * numPlayed);

        const float endY = playerCard ? WndDim.height - (this.height / 2) : -(this.height / 2);

        if (!playerCard)
        {
            this.setRotationCenter(this.width / 2, this.height / 2);
            this.setRotation(180);
        }

        this.transition(startX, startY, endX, endY);
    }

    private void transition(float startX, float startY, float endX, float endY)
    {
        this.setPosition(startX, startY);
        this.render();

        StopWatch sw;
        uint elapsedTime;
        const uint goalTime = 500;
        const float diffX = (endX - startX) / goalTime;
        const float diffY = (endY - startY) / goalTime;
        sw.reset();
        while ((elapsedTime = sw.getElapsedTicks()) < goalTime)
        {
            const float tempX = (diffX * elapsedTime) + startX;
            const float tempY = (diffY * elapsedTime) + startY;
            this.setPosition(tempX, tempY);
            this.render();
        }

        this.setPosition(endX, endY);
    }

    private void render()
    {
        wnd.clear();
        gStateMachine.render();
        wnd.display();
    }
}
