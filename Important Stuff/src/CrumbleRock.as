package  
{
	import org.flixel.*;

	public class CrumbleRock extends FlxSprite
	{
		private var crumbleTimer:Number;
		private var crumbleTimerFlag:Boolean;
		private var explosionTimerFlag:Boolean;
		private var reappearTimer:Number = 0;
		private	var killFlag:Boolean = false;
		
		[Embed(source="../assets/rockBust.mp3")] private var bustSFX:Class;
		
		[Embed(source = "../map/crumbleRock.png")] private var crumbleRockPNG:Class;
		[Embed(source = "../assets/poof2.mp3")] private var poof2:Class;
		
		public function CrumbleRock(x:int, y:int)
		{
			super(x * 16, y * 16);
			
			offset.y = 0;
			
			loadGraphic(crumbleRockPNG, true, true, 16, 24);
			
			addAnimation("explode", [1,1,2, 3, 6], 18, false);
			addAnimation("idle", [1], 10, false);
			
			play("idle");
			
			immovable = true;
			active = false;

			width = 16;
			height = 24;
		}
		
		override public function update():void
		{
			super.update();
			
			
			//Crumble Timer
			if (crumbleTimer > 0)
			{
				crumbleTimer -= FlxG.elapsed;
				if (!explosionTimerFlag)
				{
					play("explode");
					explosionTimerFlag = true;
				}
			}
			if (crumbleTimer < 0)
			{
				visible = false;
				solid = false;
				reappearTimer = 1.5;
				crumbleTimer = 0;
			}
			
			if (reappearTimer > 0)
			{
				reappearTimer -= FlxG.elapsed;
			}
			if (reappearTimer < 0)
			{
				play("idle");
				visible = true;
				solid = true;
				reappearTimer = 0;
				explosionTimerFlag = false;
				crumbleTimerFlag = false;
			}
		
			
		}
		
		//only here so reference in PlayState doesn't freak out
		public function knockback():void
		{
		}
		
		public function crumble():void
		{
			if (!crumbleTimerFlag)
			{
				if(Registry.stageCount != 5)FlxG.play(poof2, 1, false, true);	
				crumbleTimer = .3;
				crumbleTimerFlag = true;
			}	
			
		}
	}
}