package  
{
	import org.flixel.*;

	public class Stars extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var tempStar:Star;
		
		public function Stars()
		{
			super();
		}
		
		public function addStars():void
		{	
			var i:int;
			for(i= 0; i < 50; i++)
			{
				tempStar = new Star(500, 100);
				add(tempStar);
			}
		}
	}
}