package  
{
	import org.flixel.*;

	public class Support extends FlxSprite
	{
		private var player:Player;
		private var timer:Number;
		private	var killFlag:Boolean = false;
		private var number:int;
 
		
		[Embed(source="../map/Support.png")] private var SupportPNG:Class;
		
		public function Support(x:int, y:int)
		{
			if (Registry.stageCount == 5) number = 160
			else number = 0
			
			super(x * 16, y * 16 + number);
			
			
			loadGraphic(SupportPNG, true, true, 16, 16);
			
			addAnimation("explode", [1, 2, 3], 9, false);
			addAnimation("idle", [1], 10, false);
			
			play("idle");
			
			immovable = true;
			active = false;
			
			timer = 0;
		}
		
		override public function update():void
		{
			super.update();
			
			//Death Timer
			if (timer > 0)
			{
				timer -= FlxG.elapsed;
				play("explode");
			}
			if (timer < 0)
			{
				exists = false;
			}
			
		}
		
		override public function kill():void
		{
			solid = false;

			if (!killFlag)
			{
				timer = .3;
				killFlag = true;
			}
		}
		
		//only here so reference in PlayState doesn't freak out
		public function knockback():void
		{
		}
	}
}