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
 * Rules state - state displaying rules of blackjack
 */

/* Phobos imports */

/* Dgame imports */
// In State superclass

/* Project imports */
import bladjad;
import button;
import state;

class RulesState : State
{

    private
    {
        Font smallFont;

        immutable string[] rulesStrings = [
            "Bladjad is simply the game blackjack. If you're familiar with blackjack,",
            "you should be ready to go. If not, here's a brief summary.", " ",
            "Your objective is to have a hand whose value is as close to 21 as possible ",
            "without exceeding it. Each numeric card is worth its face value, ",
            "and each face card is worth 10. Aces are special and can be 11 or 1, ",
            "depending on the situation. In Bladjad, this is handled automatically.",
            "Each round, you can choose to 'hit' by pressing 'h', adding a card ",
            "to your hand from the deck. When you're satisfied with your hand,",
            "simply 'stand' by pressing 's'. If your hand is worth more than 21, ",
            "you will 'bust', losing unless the dealer busts. If your hand is worth ",
            "exactly 21, you will stand automatically.", " ",
            "Once you've stood or busted, the dealer will play just as you have, ",
            "and when they have finished, your scores will be compared."
        ];
        Text[rulesStrings.length] rulesText;

        Button menuButton;
        Button quitButton;
    }

    override void enter()
    {
        smallFont = Font("fonts/ExpressionPro.ttf", 32);

        Text last;
        foreach (i, str; rulesStrings)
        {
            rulesText[i] = new Text(smallFont, str);
            rulesText[i].mode = Font.Mode.Shaded;
            rulesText[i].foreground = Color4b(0x00FFFF);
            rulesText[i].background = Color4b(0x143D4C);
            rulesText[i].update();
            rulesText[i].setPosition((WndDim.width / 2) - (rulesText[i].width / 2),
                    (last is null) ? (rulesText[i].height * 5) : (last.y + last.height));
            last = rulesText[i];
        }

        void delegate(Button) f = (b) => gStateMachine.change("Start");
        menuButton = new Button(smallFont, "Menu", f);
        menuButton.setPosition((WndDim.width / 4) + menuButton.width,
                WndDim.height - (menuButton.height * 2));

        f = (b) => gStateMachine.change("Quit");
        quitButton = new Button(smallFont, "Quit", f);
        quitButton.setPosition(((WndDim.width * 3) / 4) - quitButton.width, menuButton.y);
    }

    override void update(Event event)
    {
        if (event.type == Event.Type.KeyDown)
        {
            switch (event.keyboard.key)
            {
            case Keyboard.Key.M:
                gStateMachine.change("Start");
                break;

            default:
                break;
            }
        }
        else if ((event.type == Event.Type.MouseButtonUp) &&
                (event.mouse.button.button == Mouse.Button.Left))
        {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            if (menuButton.getHasFocus(mouseVect))
                menuButton.onClick(menuButton);
            else if (quitButton.getHasFocus(mouseVect))
                quitButton.onClick(quitButton);
        }
        else if (event.type == Event.Type.MouseMotion)
        {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            menuButton.getHasFocus(mouseVect);
            quitButton.getHasFocus(mouseVect);
        }
    }

    override void render()
    {
        foreach (text; this.rulesText)
            wnd.draw(text);

        menuButton.render();
        quitButton.render();
    }

    override void exit()
    {
        foreach (text; this.rulesText)
            text.destroy();

        menuButton.finish();
        quitButton.finish();
        this.destroy();
    }
}
