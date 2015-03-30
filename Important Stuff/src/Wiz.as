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
		public var message:FlxText;
		
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
			
			message = new FlxText(x+14, y- 20, 80, "");
			
		}
	
		override public function update():void
		{
			super.update();
			
			
			if (onScreen() && !shockedFlag)
			{
				shockedTimer = 15;
				shockedFlag = true;
			}
			
			
			//Timer
			if (shockedTimer > 0)
			{
				shockedTimer -= FlxG.elapsed;
			
				if (shockedTimer < 14)
				{
					message.text = "!";
					if (shockedTimer < 12 && shockedTimer > 10)
					{
						if (isTouching(FLOOR)) velocity.y = -110;
						play("excited");
						message.x = x - 40;
						message.text = "YOU MADE IT!!!!!!!!";
					}
					else if (shockedTimer <= 10)
					{
						play("idle");
						message.text = "Come.";
						if (shockedTimer < 8)
						{
							message.text = "We must hurry if we want to see it.";
							if (shockedTimer < 5)
							{
								play("excited");
								velocity.y = -60;
								message.text = "You are not going to believe your eyes!";
							}
						}
						
					}
				}
					
			}
			else if (shockedTimer < 0)
			{

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