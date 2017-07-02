package  
{
	import org.flixel.*;

	public class FadeBlock extends FlxSprite
	{
		private var player:Player;
		private var timer:Number;
		private var delay:Number;
		private	var killFlag:Boolean = false;
		private var speed:Number;
		private var faded:Boolean = false;
		
		[Embed(source = "../assets/drawerslide.mp3")] private var scootSFX:Class;
		[Embed(source="../map/fadeRock(brown).png")] private var rockPNG:Class;
		
		public function FadeBlock(x:int, y:int, i_delay:Number, i_speed:Number)
		{
			super(x * 16, y * 16 + 160); //no clue why I had to add 160
			
			speed = i_speed;
			delay = i_delay;
			
			
		
			loadGraphic(rockPNG, true, true, 16, 16);
			
			addAnimation("idle", [6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5], 16, false);
			addAnimation("faded", [6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7], 16, false);
			
			play("idle");
			
			immovable = true;
			active = true;
			
			timer = speed + delay;
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (faded) play("faded");
			else play("idle");
			
			//Fade Timer
			if (timer > 0)
			{
				timer -= FlxG.elapsed
			}
			if (timer <= 0)
			{
				switchFade();
				timer = speed;
			}
			
		}
		
		public function switchFade():void
		{
		//	if (this.onScreen()) //FlxG.play(scootSFX, .1);
			
			if (faded)
			{
				faded = false;
				solid = true;
				
			}
			else
			{
				faded = true;
				solid = false;
			}
		}
		
		
		
		//only here so reference in PlayState doesn't freak out
		public function knockback():void
		{
		}
	}
}