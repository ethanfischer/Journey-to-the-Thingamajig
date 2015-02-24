package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;

	public class Bots2 extends FlxGroup
	{
		public var x:int;
		public var y:int;
		private var player:Player;
		private var tempBot:Bot2;
		public var weapon:FlxWeapon;
		public var blades:FlxGroup = new FlxGroup;
		
		
		public function Bots2()
		{
			super();
		}
		
		public function addBot2(i_x:int, i_y:int, i_player:Player, facing:uint, bladeSpeed:int, i_active:Boolean = false, i_fireRate:int = 1, i_bullets:int = 4, i_updateForever:Boolean = false):void
		{	
			x = i_x;
			y = i_y + 4/16; //+ 4 because the bots fall a little bit to the ground otherwise
			
			player = i_player;
			
			weapon = new FlxWeapon("bladeLauncher");
			tempBot = new Bot2(x, y, player, weapon, facing, bladeSpeed, i_active, i_fireRate, i_bullets, i_updateForever);
			add(tempBot);
			blades.add(weapon.group);
			
		}
		
		
		
	}

}