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
 * State - a base class for states
 */

/* Phobos imports */

/* Dgame imports */
public import Dgame.Graphic : Color4b, Text, Shape;
public import Dgame.Math : Geometry, Vector2, Vector3, Vertex;
public import Dgame.System : Font, Keyboard, Mouse, StopWatch;
public import Dgame.Window : Event, Window;

/* Project imports */

abstract class State
{

    /// Perform any necessary configuration of the State on entry.
    public void enter()
    {
    }

    /// Update the State every tick.
    public void update(Event event)
    {
    }

    /// Render the State every tick.
    public void render()
    {
    }

    /// Perform any necessary cleanup before leaving the State.
    public void exit()
    {
    }
}
