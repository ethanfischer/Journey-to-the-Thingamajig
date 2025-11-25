package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Tutorial sign that displays text when player is nearby
 * Extends FlxGroup to contain both sprite and text (like Flash version)
 */
class Sign extends FlxGroup
{
	public var message:FlxText;
	private var signSprite:FlxSprite;
	private var signX:Float;
	private var signY:Float;

	public function new(x:Float, y:Float, text:String, messageX:Float, messageY:Float)
	{
		super();

		signX = x;
		signY = y;

		// Sign doesn't have a visible sprite in Flash - just the text
		// We keep the sprite for position tracking but make it invisible
		signSprite = new FlxSprite(x, y);
		signSprite.makeGraphic(1, 1, 0x00000000); // Invisible 1x1 pixel
		signSprite.visible = false;
		add(signSprite);

		// Create text message
		message = new FlxText(messageX, messageY, 150, text);
		message.setFormat(null, 8, FlxColor.WHITE, CENTER);
		message.visible = false;
		add(message);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Show text when player is nearby (Flash bounds check)
		if (Registry.player != null)
		{
			var px = Registry.player.x;
			var py = Registry.player.y;

			// Flash check: player.x > x - 34 && player.x < x + 50
			//             player.y > y - 50 && player.y < y + 50
			if (px > signX - 34 && px < signX + 50 && py > signY - 50 && py < signY + 50)
			{
				message.visible = true;
			}
			else
			{
				message.visible = false;
			}
		}
	}
}
