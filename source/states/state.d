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
public import Dgame.Math : Geometry, Vertex;
public import Dgame.System : Font, Keyboard, StopWatch;
public import Dgame.Window : Event, Window;

/* Project imports */
public import stateMachine;

abstract class State {

    public void enter(StateMachine gStateMachine) {} // handles setup

    public void update(Event event, ref Window wnd) {} // handles updates

    public void render(ref Window wnd) {} // draws any graphics

    public void exit() {} // cleans up before leaving
}
