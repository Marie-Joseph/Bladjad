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
 * State machine - manages states and transitions between them
 */

/* Phobos imports */
import std.stdio : stderr, writeln;

/* Dgame imports */
import Dgame.Window : Event, Window;

/* Project imports */
import state;
import Bladjad;

class StateMachine {

    private {
        State[string] states;
        State curState;
    }

    this(State[string] statesArr) {
        states = statesArr.dup();
    }

    public void change(string stateName) {
        if (stateName in states) {
            curState = states[stateName];
            curState.enter();
        } else if (stateName == "Quit") {
            wnd.push(Event.Type.Quit);
        } else {
            stderr.writeln("Unknown state ", stateName);
        }
    }

    public void update(Event event) {
        curState.update(event);
    }

    public void render() {
        curState.render();
    }

    public void exit() {
        curState.exit();
    }

    public void finish() {
        this.exit();
        foreach (state; states) {
            state.exit();
            state.destroy();
        }
        states.destroy();
        this.destroy();
    }
}
