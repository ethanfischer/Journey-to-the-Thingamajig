package;

import flixel.FlxObject;
import flixel.group.FlxGroup;

/**
 * Group manager for Bot enemies
 * Handles spawning bots from tilemap and collision management
 */
class Bots extends FlxTypedGroup<Bot>
{
	public function new()
	{
		super();
	}

	/**
	 * Add a new bot at tile coordinates
	 * @param tileX X position in tiles
	 * @param tileY Y position in tiles
	 * @param facing Initial facing direction (FlxObject.LEFT or FlxObject.RIGHT)
	 * @param suicidal Whether bot will suicide-jump at player
	 */
	public function addBot(tileX:Int, tileY:Int, facing:Int = 0x0010, suicidal:Bool = false):Bot // 0x0010 = FlxObject.RIGHT
	{
		var bot = new Bot(tileX, tileY, facing, suicidal);
		add(bot);
		return bot;
	}

	/**
	 * Activate all bots that are on screen
	 */
	public function activateOnScreen():Void
	{
		for (bot in members)
		{
			if (bot != null && bot.exists && bot.isOnScreen())
			{
				bot.active = true;
			}
		}
	}
}
