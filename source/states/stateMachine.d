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
            curState.enter();
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
            state.destroy();
        }
        states.destroy();
        this.destroy();
    }
}
