package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * Tutorial sign that displays text when player is nearby
 */
class Sign extends FlxSprite
{
	private var text:FlxText;
	private var message:String;

	public function new(x:Float, y:Float, message:String)
	{
		super(x, y);
		this.message = message;

		makeGraphic(32, 32, 0xFF8B4513); // Brown placeholder

		text = new FlxText(x - 50, y - 20, 150, message);
		text.setFormat(null, 8, 0xFFFFFF, CENTER);
		text.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Show text when player is nearby
		if (Registry.player != null)
		{
			var dist = Math.sqrt(Math.pow(x - Registry.player.x, 2) + Math.pow(y - Registry.player.y, 2));
			text.visible = (dist < 64);
		}
	}

	override public function draw():Void
	{
		super.draw();
		if (text.visible) text.draw();
	}
}
