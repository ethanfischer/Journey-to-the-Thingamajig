package  
{
	import org.flixel.*;

	public class Torches extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var tempTorch:Torch;
		
		
		public function Torches()
		{
			super();
		}
		
		public function addTorch(i_x:int, i_y:int, i_flameDance:int):void
		{	
			x = i_x;
			y = i_y;

			tempTorch = new Torch(x, y, i_flameDance);
			add(tempTorch);
		}
	}

}