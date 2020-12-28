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
module bladjad;

/* Phobos imports */
import std.datetime.systime : Clock;
import std.file : exists, mkdir;
import std.format : format;
import std.stdio : writeln;

/* Dgame imports */
import Dgame.Graphic : Color4b, Texture, Sprite, Surface;
import Dgame.Window : DisplayMode, Event, Window;
import Dgame.System : Keyboard;

/* Project imports */
import creditState;
import playState;
import rulesState;
import stateMachine;
import startState;

/// The dimensions for the Window. Has width and height.
enum WndDim: int { width = 1024, height = 768 }

/// Global Window object
Window wnd;
/// Global StateMachine
StateMachine gStateMachine;

void main() {
    wnd = Window(WndDim.width, WndDim.height, "Bladjad");
    auto displayRect = DisplayMode.getDisplayBounds();
    wnd.setPosition((displayRect.width / 2) - (WndDim.width / 2),
                    (displayRect.height / 2) - (WndDim.height / 2));
    wnd.setVerticalSync(Window.VerticalSync.Disable);
    wnd.setClearColor(Color4b(0x4C3D14));

    gStateMachine = new StateMachine(["Start": new StartState(),
                                      "Play": new PlayState(),
                                      "Rules": new RulesState(),
                                      "Credits": new CreditState]);

    //if (!exists("screenshots"))
        //mkdir("screenshots");

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
                    //else if (event.keyboard.key == Keyboard.Key.P)
                        //wnd.capture().saveToFile(format!"screenshots/Screenshot-%s.png"(Clock.currTime().toISOString()));
                    else
                        goto default;
                    break;

                default:
                    gStateMachine.update(event);
                    break;
            }
        }

        gStateMachine.render();

        wnd.display();
    }
}
