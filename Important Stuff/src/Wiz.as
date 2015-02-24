package  
{
	import org.flixel.*;

	public class Wiz extends FlxSprite
	{
		[Embed(source="../map/wiz.png")] private var wizPNG:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var bounceTimer:Number;
		private var turnAroundTimer:Number;
		private var knockBackTimer:Number;
		private var player:Player;
		public var dTurnFlag:Boolean = false;
		private var shockedTimer:Number;
		private var shockedFlag:Boolean = false;
		
		
		
		public function Wiz(x:int, y:int)
		{
			super(x, y);
			
			offset.y = -2;
			loadGraphic(wizPNG, true, true, 24, 48);
			solid = true;
			
			addAnimation("idle", [0], 0, true);
			addAnimation("excited", [1, 2], 4, true);
			play("idle");
			scrollFactor.x = 1;
			
			acceleration.y = 500;
		}
	
		override public function update():void
		{
			super.update();
			
			
			if (onScreen() && !shockedFlag)
			{
				shockedTimer = 1.5;
				shockedFlag = true;
			}
			
			
			//Timer
			if (shockedTimer > 0)
			{
				shockedTimer -= FlxG.elapsed;
			}
			else if (shockedTimer < 0)
			{
				if (isTouching(FLOOR)) velocity.y = -110;
				play("excited");
			}
		}
		
		public function turnAround():void
		{
			if (!isDying)
			{
				if (facing == FlxObject.RIGHT)
				{
					facing = FlxObject.LEFT;
					////IMPLEMENT A PAUSED TURN AROUND/////////////////////////////////////////////////////////
					velocity.x = -30;
					play("idleRight");
				}
				else
				{
					facing = FlxObject.RIGHT;
					velocity.x = 30;
					play("idleLeft");
				}
			}
		}
		
		
	}

}