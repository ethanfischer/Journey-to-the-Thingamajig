package  
{
	import org.flixel.*;

	public class Poofs extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempPoof:Poof;
		public var allthePoofs:Array = new Array(); //array of Poofs used to randomly select a chosen bot for retreat function
		
		
		
		
		public function Poofs()
		{
			super();
		}
		
		public function addPoof(i_x:int, i_y:int):void
		{	
			x = i_x;
			y = i_y;
			tempPoof = new Poof(x, y);
			add(tempPoof);
			//allthePoofs.push(tempPoof);
		}	
	}

}