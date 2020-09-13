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
        float startX = WndDim.width - this.width - 25;
        float startY = (WndDim.height / 2) - (this.height / 2);

        float endX;
        if (playerCard)
            endX = (((WndDim.width * 3) / 4) - this.width) - (((this.width * 2) / 5) * numPlayed);
        else
            endX = ((WndDim.width / 4) + ((this.width * 2) / 5) * numPlayed);

        float endY = playerCard ? WndDim.height - (this.height / 2) : -(this.height / 2);

        if (!playerCard) {
            this.setRotationCenter(this.width / 2, this.height / 2);
            this.setRotation(180);
        }

        this.transition(startX, startY, endX, endY);
    }

    private void transition(float startX, float startY, float endX, float endY) {
        this.setPosition(startX, startY);
        this.render();

        StopWatch sw;
        uint elapsedTime;
        uint goalTime = 500;
        float diffX = (endX - startX) / goalTime;
        float diffY = (endY - startY) / goalTime;
        sw.reset();
        while ((elapsedTime = sw.getElapsedTicks()) < goalTime) {
            float tempX = (diffX * elapsedTime) + startX;
            float tempY = (diffY * elapsedTime) + startY;
            this.setPosition(tempX, tempY);
            this.render();
        }

        this.setPosition(endX, endY);
    }

    private void render() {
        wnd.clear();
        gStateMachine.render();
        wnd.display();
    }
}
