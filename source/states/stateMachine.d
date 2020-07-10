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
import std.stdio : writeln;

/* Dgame imports */
import Dgame.Window : Event, Window;

/* Project imports */
import state;

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
            if (curState !is null)
                curState.exit();
            curState = states[stateName];
            curState.enter(this);
        } else {
            writeln("Mf said ", stateName);
        }
    }

    public void update(Event event, ref Window wnd) {
        curState.update(event, wnd);
    }

    public void render(ref Window wnd) {
        curState.render(wnd);
    }

    public void exit() {
        curState.exit();
    }

    public void finish() {
        this.exit();
        foreach (state; states) {
            state.destroy();
        }
        states.destroy();
        this.destroy();
    }
}
