package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Initialize FlxGame with screen dimensions and initial state
		// FlxGame(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash)
		// Using 400x200 game resolution, 60fps
		var game = new FlxGame(400, 200, MainMenuState, 60, 60, true);
		addChild(game);

		// Add FPS counter
		addChild(new openfl.display.FPS(10, 10, 0xFFFFFF));

		// forceDebugger = true;
	}
}
