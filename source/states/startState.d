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
 * Start State - the state for the starting screen
 */

/* Phobos imports */
import std.stdio : writeln;

/* Dgame imports */
// In State superclass

/* Project imports */
import Bladjad;
import button;
import state;

class StartState : State {

    private {
        Font titleFont;
        Font menuFont;

        Text titleText;

        immutable string[] optNames = ["Play", "Rules", "Credits", "Quit"];
        Button[optNames.length] buttons;
        size_t selection;
    }

    override void enter() {
        titleFont = Font("fonts/ExpressionPro.ttf", 80);
        menuFont = Font("fonts/ExpressionPro.ttf", 40);

        titleText = new Text(titleFont, "Bladjad");
        titleText.mode = Font.Mode.Shaded;
        titleText.foreground = Color4b.Cyan;
        titleText.background = Color4b(0x143D4C);
        titleText.update();
        titleText.setPosition((WndDim.width / 2) - (titleText.width / 2),
                              WndDim.height / 5);

        // cheat and use z coord for height
        Vector3!float last = Vector3!float(titleText.x, titleText.y, titleText.height);
        foreach (i, name; optNames) {
            void delegate(Button) f = (b) {
                string nm = b.getText();
                gStateMachine.change(nm);
            };
            buttons[i] = new Button(menuFont, name, f);
            
            buttons[i].setPosition((WndDim.width / 2) - (buttons[i].width / 2),
                                  last.y + last.z + (buttons[i].height * 1.5));

            last = Vector3!float(buttons[i].x, buttons[i].y, buttons[i].height);
        }
    }

    override void update(Event event) {
        if (event.type == Event.Type.KeyDown) {
            switch (event.keyboard.key) {
                case Keyboard.Key.Down:
                    buttons[selection].hasFocus = false;
                    
                    if (selection < (buttons.length - 1)) {
                        selection++;
                    } else {
                        selection = 0;
                    }

                    buttons[selection].hasFocus = true;
                    break;

                case Keyboard.Key.Up:
                    buttons[selection].hasFocus = false;
                    
                    if (selection > 0) {
                        selection--;
                    } else {
                        selection = buttons.length - 1;
                    }

                    buttons[selection].hasFocus = true;
                    break;

                case Keyboard.Key.Return:
                    buttons[selection].onClick(buttons[selection]);
                    break;

                default: break;
            }
        } else if ((event.type == Event.Type.MouseButtonDown) && (event.mouse.button.button == Mouse.Button.Left)) {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            foreach (i, button; buttons) {
                if (button.getHasFocus(mouseVect)) {
                    button.onClick(button);
                } 
            }
        } else if (event.type == Event.Type.MouseMotion) {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            foreach (i, button; buttons) {
                if (button.getHasFocus(mouseVect))
                    selection = i;
            }
        }
    }

    override void render() {
        wnd.draw(titleText);
        foreach (button; buttons) {
            button.render();
        }
    }

    override void exit() {
        foreach (button; buttons) { button.destroy(); }
        buttons.destroy();
        titleText.destroy();
        this.destroy();
    }
}
