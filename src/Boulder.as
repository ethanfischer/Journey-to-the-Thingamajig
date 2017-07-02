package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Boulder extends FlxSprite
	{
		[Embed(source = "../assets/boulder.png")] private var boulderPNG:Class;
		private var splodeFlag:Boolean = false;
		public var sploded:Boolean = false;
		
		public function Boulder() 
		{
			super(100, -100);
			loadGraphic(boulderPNG, false, false, 171, 112);
			//velocity.y = 10;
			offset.y = -17;
			acceleration.y = 5000;
			solid = true;
			drag.x = 10000;
			mass = 10000;
			addAnimation("splode", [1, 2] , 15, true);
			
			
		}
		override public function update():void
		{
			super.update();
			
		}
		
	}

}