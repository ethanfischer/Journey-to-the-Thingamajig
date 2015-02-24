package  
{
	import org.flixel.*;

	public class Reinforcements extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempReinforcement:Reinforcement;
		
		public function Reinforcements()
		{
			super();
		}
		
		public function addReinforcement(i_x:int, i_y:int):void
		{	
			x = i_x;
			y = i_y;
			tempReinforcement = new Reinforcement(x, y);
			add(tempReinforcement);
		}
	}

}