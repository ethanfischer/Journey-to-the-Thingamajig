package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * Tutorial sign that displays text when player is nearby
 */
class Sign extends FlxSprite
{
	public var text:FlxText;
	private var message:String;

	public function new(x:Float, y:Float, message:String)
	{
		super(x, y);
		this.message = message;

		makeGraphic(32, 32, 0xFF8B4513); // Brown placeholder

		text = new FlxText(0, 0, 150, message);
		text.setFormat(null, 8, FlxColor.WHITE, CENTER);
		text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		text.visible = false;
		text.scrollFactor.set(1, 1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Show text when player is nearby
		if (Registry.player != null)
		{
			var dist = Math.sqrt(Math.pow(x - Registry.player.x, 2) + Math.pow(y - Registry.player.y, 2));
			text.visible = (dist < 64);

			// Position text above sign
			if (text.visible)
			{
				text.x = x - 59;  // Center the 150px text over 32px sign
				text.y = y - 30;  // Above the sign
			}
		}
	}

	override public function draw():Void
	{
		super.draw();
		text.draw();
	}
}
