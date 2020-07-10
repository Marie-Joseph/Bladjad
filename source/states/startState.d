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

/* Dgame imports */
// In State superclass

/* Project imports */
import Bladjad;
import stateMachine;
import state;

class StartState : State {

    private {
        StateMachine gStateMachine;

        Font titleFont;
        Font menuFont;

        Text titleText;

        immutable string[] optNames = ["Play", "Rules", "Credits"];
        Text[optNames.length] options;
        Text[optNames.length] highlights;
        size_t selection;
    }

    override void enter(StateMachine gStateMachine) {
        this.gStateMachine = gStateMachine;

        titleFont = Font("fonts/ExpressionPro.ttf", 80);
        menuFont = Font("fonts/ExpressionPro.ttf", 40);

        titleText = new Text(titleFont, "Bladjad");
        titleText.mode = Font.Mode.Shaded;
        titleText.foreground = Color4b(0xFFFF00);
        titleText.background = Color4b(0x9370DB);
        titleText.update();
        titleText.setPosition((WndDim.width / 2) - (titleText.width / 2),
                              WndDim.height / 4);
        titleText.update();

        auto last = titleText;
        foreach (i, name; optNames) {
            options[i] = new Text(menuFont, name);
            options[i].mode = Font.Mode.Shaded;
            options[i].foreground = Color4b(0x9370DB);
            options[i].update();
            options[i].setPosition((WndDim.width / 2) - (options[i].width / 2),
                                  last.y + last.height + (options[i].height * 2));
            options[i].update();

            last = options[i];

            highlights[i] = new Text(menuFont, name);
            highlights[i].mode = Font.Mode.Shaded;
            highlights[i].background = Color4b.Cyan;
            highlights[i].setPosition(last.getPosition());
        }
    }

    override void update(Event event, ref Window wnd) {
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
                gStateMachine.change(options[selection].getText());
                break;

            default: break;
        }
    }

    override void render(ref Window wnd) {
        wnd.draw(titleText);

        foreach (i, option; options) {
            if (i == selection)
                wnd.draw(highlights[i]);
            else
                wnd.draw(option);
        }
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
}
