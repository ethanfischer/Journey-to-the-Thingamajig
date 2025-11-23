package;

import flixel.group.FlxGroup;

/**
 * Group manager for Rock obstacles
 */
class Rocks extends FlxTypedGroup<Rock>
{
	public function new()
	{
		super();
	}

	/**
	 * Add a new rock at tile coordinates
	 */
	public function addRock(tileX:Int, tileY:Int):Rock
	{
		var rock = new Rock(tileX, tileY);
		add(rock);
		return rock;
	}
}
