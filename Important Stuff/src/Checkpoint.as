package
{
	import org.flixel.*;

	public class Checkpoint extends FlxSprite
	{
		[Embed(source = "../assets/checkpoint.png")] private var CheckpointPNG:Class;
		[Embed(source = "../assets/pop.mp3")] private var pop:Class;
		[Embed(source = "../assets/ending.png")] private var endPNG:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		public var aliveTimer:Number = 0;
		public var dieFlag:Boolean = false;
		public var end:Boolean;
		
		public function Checkpoint(x:int, y:int, i_end:Boolean = false)
		{
			super(x*16, y*16);
			
			//player = Registry.gameLevel.player;
			
			end = i_end;
			if (end)
			{
				loadGraphic(endPNG, true, true, 32, 32);
			}
			else loadGraphic(CheckpointPNG, true, true, 16, 16);
			facing = FlxObject.RIGHT;
			width = 16;
			height = 16;
			
			
			solid = true;
			active = true;
			
			addAnimation("run", [3, 4, 0, 1, 2, 1, 0, 4], 2, true);
			addAnimation("fall", [2], 12, true);
			addAnimation("pop", [5,5,5,5,6,7, 10], 7, false);
			
			play("run");
			
	
			
			
		}
		
		override public function kill():void
		{		
			if (!dieFlag)
			{
				play("pop");
				if (!end) FlxG.play(pop);
				isDying = true;
				dieTimer = 1.7;
				dieFlag = true;
			}
		}
	
		override public function update():void
		{
			super.update();
			
			
			
			
			////////////////////////////
			//		   TIMERS		  //
			////////////////////////////
			
			if (dieTimer > 0)
			{
				dieTimer -= FlxG.elapsed;
			}
			if (dieTimer < 0)
			{	
				exists = false;
			}
		}
		
		
		
		
		
	}

}
		
		
	

	