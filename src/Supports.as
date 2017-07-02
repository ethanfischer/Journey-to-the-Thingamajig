package  
{
	import org.flixel.*;

	public class Supports extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempSupport:Support;
		
		
		public function Supports()
		{
			super();
		}
		
		public function addSupport(i_x:int, i_y:int):void
		{	
			x = i_x;
			y = i_y;
			tempSupport = new Support(x, y);
			add(tempSupport);
		}
	}

}