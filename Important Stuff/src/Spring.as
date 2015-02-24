package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Ethan Fischer
	 */
	public class Spring extends FlxSprite
	{
		[Embed(source = "../assets/spring.png")] private var springPNG:Class;
		public var bounce:int;
		
		public function Spring(x:int, y:int, i_bounce:int) 
		{
			super(x, y);
			
			bounce = i_bounce;
			loadGraphic(springPNG, true, false, 32, 24);
			addAnimation("up", [3, 2, 1, 2, 3], 25, false); 
			addAnimation("idle", [1], 0, false);
			play("idle");
		}
		
	}

}