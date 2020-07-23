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
 * This is the entry file for Bladjad.
 */
module Bladjad;

/* Phobos imports */
import std.stdio : writeln;

/* Dgame imports */
import Dgame.Graphic : Color4b, Texture, Sprite, Surface;
import Dgame.Window : Event, Window;
import Dgame.System : Keyboard;

/* Project imports */
import creditState;
import playState;
import rulesState;
import stateMachine;
import startState;

enum WndDim: int { width = 1024, height = 768 }

Window wnd;

void main() {
    wnd = Window(WndDim.width, WndDim.height, "Bladjad");

    wnd.setVerticalSync(Window.VerticalSync.Enable);
    wnd.setClearColor(Color4b(0x4C3D14));

    StateMachine gStateMachine = new StateMachine(["Start": new StartState(),
                                                   "Play": new PlayState(),
                                                   "Rules": new RulesState(),
                                                   "Credits": new CreditState]);

    Event event;
    gStateMachine.change("Start");
    outer: while (true) {
        wnd.clear();

        /* Check for events that affect the entire program */
        while (wnd.poll(&event)) {
            switch (event.type) {

                case Event.Type.Quit:
                    gStateMachine.finish();
                    break outer;

                case Event.Type.KeyDown:
                    if ((event.keyboard.key == Keyboard.Key.Esc) || (event.keyboard.key == Keyboard.Key.Q))
                        wnd.push(Event.Type.Quit);
                    else
                        gStateMachine.update(event, wnd);
                    break;

                default: break;
            }
        }

        gStateMachine.render(wnd);

        wnd.display();
    }
}
