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
import Dgame.Math : Vector2, Vertex, Geometry;
import Dgame.System : Font;

/* Project imports */
import bladjad;

class Button
{

    public
    {
        /// Whether or not the mouse cursor is currently over this Button.
        bool hasFocus;

        /// X coord of the top-left corner of the Button.
        float x;
        /// Y coord of the top-left corner of the Button.
        float y;

        alias Deleg = void delegate(typeof(this));
        /// The function to be called when this Button is clicked.
        Deleg onClick;
    }

    private
    {
        ubyte borderWidth = 5;
        ubyte totalPad = 15;

        Shape border;
        Text text;
        Text hiText;
    }

    /**
     *  Constructor for Button
     *
     *  Params:
     *      fnt = Dgame.System.Font to be used for Button text
     *      str = string to be shown by Button
     *      clk = Deleg to be used for `onClick`
     *
     *  Returns: A new Button
     */
    this(ref Font fnt, string str, Deleg clk)
    {
        this.onClick = clk;

        text = new Text(fnt, str);
        text.mode = Font.Mode.Shaded;
        text.foreground = Color4b.Yellow;
        text.background = Color4b(144, 128, 112);
        text.update();

        hiText = new Text(fnt, str);
        hiText.mode = Font.Mode.Shaded;
        hiText.background = Color4b.Cyan;
    }

    /// The scaled width of the Button.
    @property public pure nothrow @nogc uint width()
    {
        return text.width + (borderWidth * 2);
    }

    /// The scaled height of the Button.
    @property public pure nothrow @nogc uint height()
    {
        return text.height + (borderWidth * 2);
    }

    /// The text of the Button.
    @property public pure nothrow @nogc string getText()
    {
        return text.getText();
    }

    /**
     *  Set the position of the Button.
     *
     *  Params:
     *      x = the x coord of the top-left corner of the Button
     *      y = the y coord of the top-left corner of the Button
     */
    public pure nothrow void setPosition(float x, float y)
    {
        this.x = x;
        this.y = y;

        text.setPosition(x + borderWidth, y + borderWidth);
        hiText.setPosition(text.getPosition());
        border = new Shape(Geometry.Quads, [
                Vertex(x, y), Vertex(x + text.width + (borderWidth * 2), y),
                Vertex(x + text.width + (borderWidth * 2),
                    y + text.height + (borderWidth * 2)),
                Vertex(x, y + text.height + (borderWidth * 2))
                ]);
        border.setColor(Color4b.Black);
    }

    /**
     *  Check whether the mouse cursor is over the Button.
     *
     *  Params:
     *      mouseVect = the float Vector of the mouse cursor's coordinates
     *
     *  Returns: true if mouse over Button, else false
     */
    public pure nothrow bool getHasFocus(Vector2!float mouseVect)
    {
        if ((mouseVect.y >= this.y) && (mouseVect.y <= (this.y + this.height)))
        {
            if ((mouseVect.x >= this.x) && (mouseVect.x <= (this.x + this.width)))
                this.hasFocus = true;
            else
                this.hasFocus = false;
        }
        else
        {
            this.hasFocus = false;
        }

        return this.hasFocus;
    }

    /// Draw the Button to the screen.
    public void render()
    {
        wnd.draw(border);

        if (this.hasFocus)
            wnd.draw(hiText);
        else
            wnd.draw(text);
    }

    /// Cleanup before removing the Button.
    public void finish()
    {
        text.destroy();
        hiText.destroy();
        border.destroy();
        this.destroy();
    }
}
