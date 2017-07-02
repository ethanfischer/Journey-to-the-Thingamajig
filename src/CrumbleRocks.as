package  
{
	import org.flixel.*;

	public class CrumbleRocks extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempRock:CrumbleRock;
		
		public function CrumbleRocks()
		{
			super();
		}
		
		public function addCrumbleRock(i_x:int, i_y:int):void
		{	
			x = i_x;
			y = i_y;
			tempRock = new CrumbleRock(x, y);
			add(tempRock);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}