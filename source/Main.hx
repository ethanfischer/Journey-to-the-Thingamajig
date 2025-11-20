package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Initialize FlxGame with screen dimensions, initial state, zoom, and frame rates
		// In HaxeFlixel, we create a FlxGame instance and add it to the display list
		// Parameters: width, height, initialState, zoom (optional), updateFramerate, drawFramerate
		// Using hardcoded values: 400x200 (from Registry.as)
		addChild(new FlxGame(400, 200, MainMenuState, 2, 30, 30));

		// forceDebugger = true;
	}
}
