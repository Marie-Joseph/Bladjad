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
 * Button - a button widget for use throughout Bladjad
 */

/* Phobos imports */

/* Dgame imports */
import Dgame.Graphic : Color4b, Shape, Text;
import Dgame.Math : Vertex, Geometry;
import Dgame.System : Font;

/* Project imports */
import Bladjad;

class Button {

    private {
        ubyte borderWidth = 5;
        ubyte paddingWidth = 10;
        ubyte totalPad = 15;

        Shape border;
        Shape padding;
        Text text;

        float x;
        float y;
    }

    this(float x, float y, ref Font fnt, string str) {
        text = new Text(fnt, str);
        text.mode = Font.Mode.Shaded;
        text.foreground = Color4b.Yellow;
        text.background = Color4b(144, 128, 112);
        text.update();
        text.setPosition(x + totalPad, y + totalPad);

        border = new Shape(Geometry.Quads, [
                               Vertex(x, y),
                               Vertex(x + text.width + (totalPad * 2), y),
                               Vertex(x + text.width + (totalPad * 2), y + text.height + (totalPad * 2)),
                               Vertex(x, y + text.height + (totalPad * 2))
                           ]);
        border.setColor(Color4b.Black);

        padding = new Shape(Geometry.Quads, [
                                Vertex(x + borderWidth, y + borderWidth),
                                Vertex(x + text.width + borderWidth + (paddingWidth * 2),
                                       y + borderWidth),
                                Vertex(x + text.width + borderWidth + (paddingWidth * 2),
                                       y + text.height + borderWidth + (paddingWidth * 2)),
                                Vertex(x + borderWidth, y + text.height + borderWidth + (paddingWidth * 2))
                            ]);
        padding.setColor(Color4b.Slategray);
    }

    @property public uint width() { return text.width + (totalPad * 2); }

    @property public uint height() { return text.height + (totalPad * 2); }

    public void render() {
        wnd.draw(border);
        wnd.draw(padding);
        wnd.draw(text);
    }

    public void finish() {
        text.destroy();
        border.destroy();
        padding.destroy();
        this.destroy();
    }
}
