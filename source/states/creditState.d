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
 * Credit State - state for displaying credits
 */

/* Phobos imports */

/* Dgame imports */
// In State superclass

/* Project imports */
import bladjad;
import state;
import button;

class CreditState : State {

    private {
        Font bigFont;
        Font smallFont;

        Text programmerHeader;
        string programmerHeaderString = "Programmer";
        Text programmerText;
        string programmerString = "Marie-Joseph";

        Text artHeader;
        string artHeaderString = "Art";
        Text artText;
        string artString = "mapsandapps.itch.io - Synthwave Playing Card Deck Assets";

        Text fontHeader;
        string fontHeaderString = "Font";
        Text fontText;
        string fontString = "somepx.itch.io - Humble Fonts Free";

        Text licenseHeader;
        string licenseHeaderString = "License";
        Text licenseText;
        string licenseString = "CC0";

        Button menuButton;
        Button quitButton;
    }

    override void enter() {
        bigFont = Font("fonts/ExpressionPro.ttf", 64);
        smallFont = Font("fonts/ExpressionPro.ttf", 32);

        const uint halfway = WndDim.width / 2;

        programmerHeader = new Text(bigFont, programmerHeaderString);
        programmerHeader.mode = Font.Mode.Shaded;
        programmerHeader.foreground = Color4b(0x00FFFF);
        programmerHeader.background = Color4b(0x143D4C);
        programmerHeader.update();
        programmerHeader.setPosition(halfway - (programmerHeader.width / 2),
                                     programmerHeader.height * 1.5);

        programmerText = new Text(smallFont, programmerString);
        programmerText.mode = Font.Mode.Shaded;
        programmerText.foreground = Color4b(0x00FFFF);
        programmerText.background = Color4b(0x143D4C);
        programmerText.update();
        programmerText.setPosition(halfway - (programmerText.width / 2),
                                   programmerHeader.y + (programmerText.height * 2));

        artHeader = new Text(bigFont, artHeaderString);
        artHeader.mode = Font.Mode.Shaded;
        artHeader.foreground = Color4b(0x00FFFF);
        artHeader.background = Color4b(0x143D4C);
        artHeader.update();
        artHeader.setPosition(halfway - (artHeader.width / 2),
                              programmerText.y + (artHeader.height * 2));

        artText = new Text(smallFont, artString);
        artText.mode = Font.Mode.Shaded;
        artText.foreground = Color4b(0x00FFFF);
        artText.background = Color4b(0x143D4C);
        artText.update();
        artText.setPosition(halfway - (artText.width / 2),
                            artHeader.y + (artText.height * 2));

        fontHeader = new Text(bigFont, fontHeaderString);
        fontHeader.mode = Font.Mode.Shaded;
        fontHeader.foreground = Color4b(0x00FFFF);
        fontHeader.background = Color4b(0x143D4C);
        fontHeader.update();
        fontHeader.setPosition(halfway - (fontHeader.width / 2),
                               artText.y + (fontHeader.height * 2));

        fontText = new Text(smallFont, fontString);
        fontText.mode = Font.Mode.Shaded;
        fontText.foreground = Color4b(0x00FFFF);
        fontText.background = Color4b(0x143D4C);
        fontText.update();
        fontText.setPosition(halfway - (fontText.width / 2),
                             fontHeader.y + (fontText.height * 2));

        licenseHeader = new Text(bigFont, licenseHeaderString);
        licenseHeader.mode = Font.Mode.Shaded;
        licenseHeader.foreground = Color4b(0x00FFFF);
        licenseHeader.background = Color4b(0x143D4C);
        licenseHeader.update();
        licenseHeader.setPosition(halfway - (licenseHeader.width / 2),
                                  fontText.y + (licenseHeader.height * 2));

        licenseText = new Text(smallFont, licenseString);
        licenseText.mode = Font.Mode.Shaded;
        licenseText.foreground = Color4b(0x00FFFF);
        licenseText.background = Color4b(0x143D4C);
        licenseText.update();
        licenseText.setPosition(halfway - (licenseText.width / 2),
                             licenseHeader.y + (licenseText.height * 2));

        void delegate(Button) f = (b) => gStateMachine.change("Start");
        menuButton = new Button(smallFont, "Menu", f);
        menuButton.setPosition((WndDim.width / 4) + menuButton.width,
                               WndDim.height - (menuButton.height * 2));

        f = (b) => gStateMachine.change("Quit");
        quitButton = new Button(smallFont, "Quit", f);
        quitButton.setPosition(((WndDim.width * 3) / 4) - quitButton.width,
                               menuButton.y);
    }

    override void update(Event event) {
        if (event.type == Event.Type.KeyDown) {
            switch (event.keyboard.key) {
                case Keyboard.Key.M:
                    menuButton.onClick(menuButton);
                    break;

                default: break;
            }
        } else if ((event.type == Event.Type.MouseButtonUp) && (event.mouse.button.button == Mouse.Button.Left)) {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            if (menuButton.getHasFocus(mouseVect))
                menuButton.onClick(menuButton);
            else if (quitButton.getHasFocus(mouseVect))
                quitButton.onClick(quitButton);
        } else if (event.type == Event.Type.MouseMotion) {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            menuButton.getHasFocus(mouseVect);
            quitButton.getHasFocus(mouseVect);
        }
    }

    override void render() {
        wnd.draw(programmerHeader);
        wnd.draw(programmerText);
        wnd.draw(artHeader);
        wnd.draw(artText);
        wnd.draw(fontHeader);
        wnd.draw(fontText);
        wnd.draw(licenseHeader);
        wnd.draw(licenseText);
        menuButton.render();
        quitButton.render();
    }

    override void exit() {
        programmerHeader.destroy();
        programmerText.destroy();
        artHeader.destroy();
        artText.destroy();
        fontHeader.destroy();
        fontText.destroy();
        licenseHeader.destroy();
        licenseText.destroy();
        menuButton.finish();
        quitButton.finish();
        this.destroy();
    }
}
