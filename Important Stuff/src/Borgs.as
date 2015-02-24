package  
{
	import org.flixel.*;

	public class Borgs extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempBorg:Borg;
		
		
		public function Borgs()
		{
			super();
		}
		
		public function addBorg(i_x:int, i_y:int, i_player:Player, facing:uint):void
		{	
			x = i_x;
			y = i_y;
			player = i_player;
			tempBorg = new Borg(x, y, player, facing);
			tempBorg.facing = facing;
			add(tempBorg);
		}
	}

}