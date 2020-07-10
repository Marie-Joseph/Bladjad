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
import Bladjad;
import state;

class CreditState : State {

    private {
        StateMachine gStateMachine;

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
    }

    override void enter(StateMachine gStateMachine) {
        this.gStateMachine = gStateMachine;

        bigFont = Font("fonts/ExpressionPro.ttf", 45);
        smallFont = Font("fonts/ExpressionPro.ttf", 25);

        uint halfway = WndDim.width / 2;

        programmerHeader = new Text(bigFont, programmerHeaderString);
        programmerHeader.mode = Font.Mode.Shaded;
        programmerHeader.background = Color4b(0x9370DB);
        programmerHeader.update();
        programmerHeader.setPosition(halfway - (programmerHeader.width / 2),
                                     programmerHeader.height * 2);

        programmerText = new Text(smallFont, programmerString);
        programmerText.mode = Font.Mode.Shaded;
        programmerText.background = Color4b(0x9370DB);
        programmerText.update();
        programmerText.setPosition(halfway - (programmerText.width / 2),
                                   programmerHeader.y + (programmerText.height * 2));

        artHeader = new Text(bigFont, artHeaderString);
        artHeader.mode = Font.Mode.Shaded;
        artHeader.background = Color4b(0x9370DB);
        artHeader.update();
        artHeader.setPosition(halfway - (artHeader.width / 2),
                              programmerText.y + (artHeader.height * 2));

        artText = new Text(smallFont, artString);
        artText.mode = Font.Mode.Shaded;
        artText.background = Color4b(0x9370DB);
        artText.update();
        artText.setPosition(halfway - (artText.width / 2),
                            artHeader.y + (artText.height * 2));

        fontHeader = new Text(bigFont, fontHeaderString);
        fontHeader.mode = Font.Mode.Shaded;
        fontHeader.background = Color4b(0x9370DB);
        fontHeader.update();
        fontHeader.setPosition(halfway - (fontHeader.width / 2),
                               artText.y + (fontHeader.height * 2));

        fontText = new Text(smallFont, fontString);
        fontText.mode = Font.Mode.Shaded;
        fontText.background = Color4b(0x9370DB);
        fontText.update();
        fontText.setPosition(halfway - (fontText.width / 2),
                             fontHeader.y + (fontText.height * 2));

        licenseHeader = new Text(bigFont, licenseHeaderString);
        licenseHeader.mode = Font.Mode.Shaded;
        licenseHeader.background = Color4b(0x9370DB);
        licenseHeader.update();
        licenseHeader.setPosition(halfway - (licenseHeader.width / 2),
                                  fontText.y + (licenseHeader.height * 2));

        licenseText = new Text(smallFont, licenseString);
        licenseText.mode = Font.Mode.Shaded;
        licenseText.background = Color4b(0x9370DB);
        licenseText.update();
        licenseText.setPosition(halfway - (licenseText.width / 2),
                             licenseHeader.y + (licenseText.height * 2));
    }

    override void update(Event event, ref Window wnd) {
        switch (event.keyboard.key) {
            case Keyboard.Key.M:
                gStateMachine.change("Start");
                break;

            default: break;
        }
    }

    override void render(ref Window wnd) {
        wnd.draw(programmerHeader);
        wnd.draw(programmerText);
        wnd.draw(artHeader);
        wnd.draw(artText);
        wnd.draw(fontHeader);
        wnd.draw(fontText);
        wnd.draw(licenseHeader);
        wnd.draw(licenseText);
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
    }
}
