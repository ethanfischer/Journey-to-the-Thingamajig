package;

import flixel.group.FlxGroup;

/**
 * Group manager for Reinforcement collectibles
 */
class Reinforcements extends FlxTypedGroup<Reinforcement>
{
	public function new()
	{
		super();
	}

	/**
	 * Add a reinforcement at tile coordinates
	 */
	public function addReinforcement(tileX:Int, tileY:Int):Reinforcement
	{
		var r = new Reinforcement(tileX * 16, tileY * 16);
		add(r);
		return r;
	}
}
