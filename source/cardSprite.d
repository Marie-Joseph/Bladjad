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

/* Dgame imports */
import Dgame.Graphic : Texture, Sprite, Surface;
import Dgame.Window : Window;

/* Project imports */
import Bladjad;

class CardSprite : Sprite {

    private {
        Texture tex;
        float scale;
    }

    this(string filePath, float scale = 0.75) {
        this.tex = Texture(Surface(filePath));
        super(tex);
        this.scale = scale;
        this.setScale(scale, scale);
    }

    @property float width() { return tex.width() * scale; }

    @property float height() { return tex.height() * scale; }

    public void place(size_t numPlayed, bool playerCard = false) {
        float xDim;
        if (playerCard)
            xDim = (((WndDim.width * 3) / 4) - this.width) - (((this.width * 2) / 5) * numPlayed);
        else
            xDim = ((WndDim.width / 4) + ((this.width * 2) / 5) * numPlayed);

        float yDim = playerCard ? WndDim.height - (this.height / 2) : -(this.height / 2);

        if (!playerCard) {
            this.setRotationCenter(this.width / 2, this.height / 2);
            this.setRotation(180);
        }

        this.setPosition(xDim, yDim);
    }
}
