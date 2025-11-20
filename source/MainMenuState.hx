package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	private var titleText:FlxText;
	private var instructionText:FlxText;

	override public function create():Void
	{
		super.create();

		// Set background color
		bgColor = FlxColor.fromRGB(50, 100, 150);

		// Create title text
		titleText = new FlxText(0, 60, FlxG.width, "Journey to the Thingamajig");
		titleText.setFormat(null, 16, FlxColor.WHITE, CENTER);
		add(titleText);

		// Create instruction text
		instructionText = new FlxText(0, 120, FlxG.width, "Press SPACE to start\n(Minimal menu stub)");
		instructionText.setFormat(null, 12, FlxColor.WHITE, CENTER);
		add(instructionText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Simple input handling - space to start
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			// TODO: Switch to PlayState when it exists
			// For now, just show a message
			FlxG.camera.flash(FlxColor.WHITE, 0.2);
			instructionText.text = "PlayState not yet implemented\nPress ESC to restart";
		}

		// ESC to reload menu
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.resetState();
		}
	}
}
