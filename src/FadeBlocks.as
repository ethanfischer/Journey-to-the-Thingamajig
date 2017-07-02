package  
{
	import org.flixel.*;

	public class FadeBlocks extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempRock:FadeBlock;
		private var allofem:FlxGroup = new FlxGroup();
	
		private var scootFlag:Boolean;
		
		public function FadeBlocks()
		{
			super();
		}
		
		public function addFadeBlock(i_x:int, i_y:int, delay:Number, speed:Number):void
		{	
			x = i_x;
			y = i_y;
			tempRock = new FadeBlock(x, y, delay, speed);
			add(tempRock);
		}	
	}

}