package  
{
	import org.flixel.*;

	public class Rocks extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempRock:Rock;
		private var tallRock:TallRock;
		
		public function Rocks()
		{
			super();
		}
		
		public function addRock(i_x:int, i_y:int, i_player:Player, rockType:int):void
		{	
			x = i_x;
			y = i_y;
			player = i_player;
			
			if (rockType == 1)
			{
				tempRock = new Rock(x, y, player);
				add(tempRock);
			}
			else if (rockType == 2)
			{
				tallRock = new TallRock(x, y, player);
				add(tallRock);
			}
		}

	}

}