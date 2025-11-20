package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Initialize FlxGame with screen dimensions and initial state
		// In HaxeFlixel, we create a FlxGame instance and add it to the display list
		// Parameters: gameWidth, gameHeight, initialState, zoom (optional), skipSplash (optional)
		// Using values: 400x200 (from Registry.as), zoom=2
		addChild(new FlxGame(400, 200, MainMenuState, 2, true));

		// forceDebugger = true;
	}
}
