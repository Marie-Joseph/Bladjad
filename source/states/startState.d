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

        Button testButton;

        immutable string[] optNames = ["Play", "Rules", "Credits", "Quit"];
        Text[optNames.length] options;
        Text[optNames.length] highlights;
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

        testButton = new Button(25, WndDim.height - 150, menuFont, "Test");

        auto last = titleText;
        foreach (i, name; optNames) {
            options[i] = new Text(menuFont, name);
            options[i].mode = Font.Mode.Shaded;
            options[i].foreground = Color4b.Yellow;
            options[i].background = Color4b(0x143D4C);
            options[i].update();
            options[i].setPosition((WndDim.width / 2) - (options[i].width / 2),
                                  last.y + last.height + (options[i].height * 2));

            last = options[i];

            highlights[i] = new Text(menuFont, name);
            highlights[i].mode = Font.Mode.Shaded;
            highlights[i].background = Color4b.Cyan;
            highlights[i].setPosition(last.getPosition());
        }
    }

    override void update(Event event) {
        if (event.type == Event.Type.KeyDown) {
            switch (event.keyboard.key) {
                case Keyboard.Key.Down:
                    if (selection < (options.length - 1))
                        selection++;
                    else
                        selection = 0;
                    break;

                case Keyboard.Key.Up:
                    if (selection > 0)
                        selection--;
                    else
                        selection = options.length - 1;
                    break;

                case Keyboard.Key.Return:
                    changeState();
                    break;

                default: break;
            }
        } else if ((event.type == Event.Type.MouseButtonDown) && (event.mouse.button.button == Mouse.Button.Left)) {
            setSelection();
            changeState();
        } else if (event.type == Event.Type.MouseMotion) {
            setSelection();
        }
    }

    override void render() {
        wnd.draw(titleText);

        foreach (i, option; options) {
            if (i == selection)
                wnd.draw(highlights[i]);
            else
                wnd.draw(option);
        }

        testButton.render();
    }

    override void exit() {
        foreach (option; options) {
            option.destroy();
        }
        options.destroy();
        foreach (highlight; highlights) {
            highlight.destroy();
        }
        highlights.destroy();
        titleText.destroy();
    }

    private void setSelection() {
        Vector2!int mouseVect = Mouse.getCursorPosition();
        foreach (i, option; options) {
            if ((mouseVect.y >= option.y) && (mouseVect.y <= (option.y + option.height))) {
                if ((mouseVect.x >= option.x) && (mouseVect.x <= (option.x + option.width))) {
                    selection = i;
                }
            }
        }
    }

    private void changeState() {
        string choice = options[selection].getText();
        if (choice == "Quit")
            wnd.push(Event.Type.Quit);
        else
            gStateMachine.change(choice);
    }
}
