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
import bladjad;

class StateMachine
{

    private
    {
        State[string] states;
        State curState;
    }

    /**
     *  Constructor for StateMachine.
     *
     *  Params:
     *      statesArr = array of strings containing the names of States
     *
     *  Returns: A new StateMachine
     */
    this(State[string] statesArr)
    {
        states = statesArr.dup();
    }

    /**
     *  Change the current State.
     *
     *  Params:
     *      stateName = the string name of the State to be changed to
     */
    public void change(string stateName)
    {
        if (stateName in states)
        {
            curState = states[stateName];
            curState.enter();
        }
        else if (stateName == "Quit")
        {
            wnd.push(Event.Type.Quit);
        }
        else
        {
            stderr.writeln("Unknown state ", stateName);
        }
    }

    /**
     *  Update the active State every tick.
     *
     *  Params:
     *      event = a Dgame.Window.Event intercepted this tick
     */
    public void update(Event event)
    {
        curState.update(event);
    }

    /// Render the current State.
    public void render()
    {
        curState.render();
    }

    /// Exit the current State.
    public void exit()
    {
        curState.exit();
    }

    /// Cleanup the StateMachine before destruction.
    public void finish()
    {
        foreach (state; states)
            state.exit();
        states.destroy();
        this.destroy();
    }
}
