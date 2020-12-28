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
 * Play State - handles the game of blackjack itself
 */

/* Phobos imports */
import std.format : format;
import std.stdio : writeln;

/* Dgame imports */
// In State superclass
import Dgame.Math.Rect;

/* Project imports */
import bladjad;
import cardSprite;
import deck;
import hand;
import state;
import button;

class PlayState : State
{

    private
    {
        Font endFont;
        Text endText;
        Text bustText;
        Text blackjackText;
        bool ended;

        Deck deck;

        CardSprite cardBack;

        Hand playerHand;
        Hand dealerHand;

        Font buttonFont;
        immutable string[] buttonNames = [
            "Hit", "Menu", "Quit", "Restart", "Stand"
        ];
        Button[string] buttons;

        bool stood;
        bool firstRun;
    }

    override void enter()
    {
        cardBack = new CardSprite("images/cards/back.png");
        cardBack.setPosition(WndDim.width - cardBack.width - 25,
                (WndDim.height / 2) - (cardBack.height / 2));

        deck = new Deck();

        playerHand = new Hand(true);
        dealerHand = new Hand();

        buttonFont = Font("fonts/ExpressionPro.ttf", 24);
        void delegate(Button) f;
        float buttonX, buttonY;
        const Rect cardRect = cardBack.getClipRect();
        foreach (name; buttonNames)
        {
            switch (name)
            {
            case "Hit":
                f = (b) => playerHit();
                buttons[name] = new Button(buttonFont, name, f);
                buttonX = cardRect.x;
                buttonY = cardRect.y - (buttons[name].height * 2);
                break;

            case "Menu":
                f = (b) => gStateMachine.change("Start");
                buttons[name] = new Button(buttonFont, name, f);
                buttonX = cardRect.x;
                buttonY = cardRect.y + cardBack.height + buttons[name].height;
                break;

            case "Restart":
                f = (b) => gStateMachine.change("Play");
                buttons[name] = new Button(buttonFont, name, f);
                buttonX = cardRect.x + (cardBack.width / 2) - (buttons[name].width / 2);
                buttonY = cardRect.y + cardBack.height + (buttons[name].height * 2) + 10;
                break;

            case "Quit":
                f = (b) => gStateMachine.change("Quit");
                buttons[name] = new Button(buttonFont, name, f);
                buttonX = cardRect.x + cardBack.width - buttons[name].width;
                buttonY = cardRect.y + cardBack.height + buttons[name].height;
                break;

            case "Stand":
                f = (b) => playerStand();
                buttons[name] = new Button(buttonFont, name, f);
                buttonX = cardRect.x + cardBack.width - buttons[name].width;
                buttonY = cardRect.y - (buttons[name].height * 2);
                break;

            default:
                break;
            }
            buttons[name].setPosition(buttonX, buttonY);
        }

        endFont = Font("fonts/ExpressionPro.ttf", 72);
        endText = new Text(endFont, "Placeholder");
        endText.mode = Font.Mode.Shaded;
        endText.foreground = Color4b.Yellow;
        endText.background = Color4b(0x143D4C);

        bustText = new Text(endFont, "BUST");
        bustText.mode = Font.Mode.Shaded;
        bustText.foreground = Color4b.Yellow;
        bustText.background = Color4b(0x143D4C);
        bustText.update();
        bustText.setPosition((WndDim.width / 2) - (bustText.width / 2),
                WndDim.height - (bustText.height * 3));

        blackjackText = new Text(endFont, "BLADJAD");
        blackjackText.mode = Font.Mode.Shaded;
        blackjackText.foreground = Color4b.Yellow;
        blackjackText.background = Color4b(0x143D4C);
        blackjackText.update();
        blackjackText.setPosition((WndDim.width / 2) - (blackjackText.width / 2),
                WndDim.height - (blackjackText.height * 3));

        firstRun = true;
        stood = false;
        ended = false;
    }

    override void update(Event event)
    {
        if (event.type == Event.Type.KeyDown)
        {
            switch (event.keyboard.key)
            {
            case Keyboard.Key.H:
                buttons["Hit"].onClick(buttons["Hit"]);
                break;

            case Keyboard.Key.M:
                buttons["Menu"].onClick(buttons["Menu"]);
                break;

            case Keyboard.Key.R:
                buttons["Restart"].onClick(buttons["Restart"]);
                break;

            case Keyboard.Key.S:
                buttons["Stand"].onClick(buttons["Stand"]);
                break;

            default:
                break;
            }
        }
        else if ((event.type == Event.Type.MouseButtonUp) &&
                (event.mouse.button.button == Mouse.Button.Left))
        {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            foreach (button; buttons)
            {
                if (button.getHasFocus(mouseVect))
                    button.onClick(button);
            }
        }
        else if (event.type == Event.Type.MouseMotion)
        {
            Vector2!float mouseVect = Mouse.getCursorPosition();
            foreach (button; buttons)
                button.getHasFocus(mouseVect);
        }
    }

    override void render()
    {
        if (firstRun)
        {
            firstRun = false;
            playerHit();
            hit();
            playerHit();
            hit();
        }

        wnd.draw(cardBack);
        foreach (card; playerHand)
            wnd.draw(card);
        playerHand.reset();
        foreach (card; dealerHand)
            wnd.draw(card);
        dealerHand.reset();
        if (ended)
        {
            wnd.draw(endText);
            buttons["Menu"].render();
            buttons["Quit"].render();
            buttons["Restart"].render();
        }
        else
        {
            foreach (button; buttons)
                button.render();
        }
        if (playerHand.hasBusted())
            wnd.draw(bustText);
        else if (playerHand.curScore() == 21)
            wnd.draw(blackjackText);
    }

    override void exit()
    {
        playerHand.finish();
        dealerHand.finish();
        deck.destroy();
        cardBack.destroy();
        foreach (button; buttons)
        {
            button.finish();
        }
        buttons.destroy();
        endText.destroy();
        bustText.destroy();
        blackjackText.destroy();
        this.destroy();
    }

    private void playerHit()
    {
        if (stood)
            return;
        if (deck.empty)
            deck.shuffle();

        playerHand.add(deck.draw());
        if (playerHand.hasBusted || (playerHand.curScore == 21))
            playerStand();
    }

    private void hit()
    {
        if (deck.empty)
            deck.shuffle();

        dealerHand.add(deck.draw());
    }

    private void playerStand()
    {
        stood = true;
        uint dealerScore;
        while ((dealerScore = dealerHand.curScore()) < 17)
            hit();

        const bool dealerBust = dealerHand.hasBusted();

        const uint playerScore = playerHand.curScore();
        const bool playerBust = playerHand.hasBusted();

        if (dealerBust)
        {
            if (playerBust)
                tie();
            else
                playerVictory();
        }
        else if (playerBust)
        {
            playerLoss();
        }
        else if (playerScore == dealerScore)
        {
            tie();
        }
        else if ((playerScore == 21) || (playerScore > dealerScore))
        {
            playerVictory();
        }
        else
        {
            playerLoss();
        }
    }

    private void tie()
    {
        setEnd("Draw");
    }

    private void playerVictory()
    {
        setEnd("Victory");
    }

    private void playerLoss()
    {
        setEnd("Defeat");
    }

    private void setEnd(string toWrite)
    {
        endText.setData(toWrite);
        endText.update();
        endText.setPosition((WndDim.width / 2) - (endText.width / 2),
                (WndDim.height / 2) - (endText.height / 2));

        buttons["Restart"].setPosition((WndDim.width / 2) - (buttons["Restart"].width / 2),
                (WndDim.height / 2) + endText.height + 5);
        Vector3!float base;
        base.x = buttons["Restart"].x;
        base.y = buttons["Restart"].y;
        base.z = buttons["Restart"].width;
        buttons["Menu"].setPosition(base.x - (base.z / 2) - buttons["Menu"].width, base.y);
        buttons["Quit"].setPosition(base.x + ((3 * base.z) / 2), base.y);

        ended = true;
    }
}
