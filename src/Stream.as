package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Ethan Fischer
	 */
	public class Stream extends FlxSprite
	{
		[Embed(source = "../assets/stream.png")] private var streamPNG:Class;
		public var flowLeft:Boolean;
		public var type:String;
		
		public function Stream(x:int, y:int, i_flowLeft:Boolean, i_type:String) 
		{
			super(x * 16, y * 16);
			
			active = false;
			
			flowLeft = i_flowLeft;
			type = i_type;
			
			loadGraphic(streamPNG, true, false, 16, 16);
			offset.y = -10;

			addAnimation("flowLeft", [0, 1, 2, 3], 17, true);
			addAnimation("flowRight", [3, 2, 1, 0], 17, true);
			addAnimation("fall", [4, 5, 6, 7], 17, true);
			addAnimation("fallRight", [15,14,13,12], 17, true);
			addAnimation("drop", [8, 9], 17, true);
			addAnimation("dropRight", [16, 17], 17, true);
			addAnimation("crash", [10, 11], 17, true);
			addAnimation("fast", [0, 1, 2, 3], 30, true);
			
			if (type == "fall") play("fall");
			else if (type == "fallRight") play("fallRight");
			else if (type == "drop")  play("drop");
			else if (type == "dropRight")  play("dropRight");
			else if (type == "crash") play("crash");
			else if (type == "fast") play("fast");
			else if (flowLeft) play("flowLeft");
			else play("flowRight");
		}
		
	}

}