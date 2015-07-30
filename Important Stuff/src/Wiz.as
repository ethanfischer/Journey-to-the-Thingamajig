package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;

	public class Wiz extends FlxSprite
	{
		[Embed(source = "../map/wiz.png")] private var wizPNG:Class;
		[Embed(source = "../assets/smash.mp3")] private var smash:Class;
		[Embed(source = "../assets/rumble_loud.mp3")] public var rumble:Class;
		 private var poofPNG:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var bounceTimer:Number;
		private var turnAroundTimer:Number;
		private var knockBackTimer:Number;
		public var dTurnFlag:Boolean = false;
		private var cut1Timer:Number; //timer for the first cutscene
		private var cut2Timer:Number = -100; //timer for the 2nd cutscene
		private var shockedFlag:Boolean = false;
		public var message:FlxText;
		public const BEHINDGIFT:int = 11170
		public var smokelets:Smokelets;
		public var impendingDoomFlag:Boolean = false;
		public var smushFlag:Boolean = false;
		public var smushTimer:Number;
		public var smushedFlag:Boolean;
		public var rumbleFlag:Boolean;
		
		public function Wiz(x:int, y:int)
		{
			super(x, y);
			
			offset.y = -2;
			loadGraphic(wizPNG, true, true, 24, 48);
			solid = true;
			
			addAnimation("think", [3], 0, false);
			addAnimation("look", [5], 0, false);
			addAnimation("idle", [0], 0, true);
			addAnimation("excited", [1, 2], 4, true);
			addAnimation("run", [4], 12, true);
			addAnimation("dead", [6], 0, true);
			play("think");
			
			scrollFactor.x = 1;
			
			acceleration.y = 500;
			
			message = new FlxText(x - 14, y - 24, 100, "");
		
			smokelets = new Smokelets();
			
			
		}
	
		override public function update():void
		{
			super.update();

			if (onScreen() && !shockedFlag)
			{
				cut1Timer = 14;
				shockedFlag = true;
			}
			//Timer
			if (cut1Timer > 0)
			{
				cut1Timer -= FlxG.elapsed;
				
				if (cut1Timer < 13)
				{
					if(cut1Timer > 12.5) message.text = "	  !";
					//message.centerOffsets();
					if(cut1Timer < 12 && cut1Timer > 11) play("look");
					if (cut1Timer < 11)
					{
						if (isTouching(FLOOR) && cut1Timer > 9.5) velocity.y = -110;
						play("excited");
						message.text = "Aw shucks!";
						//message.centerOffsets();
						if (cut1Timer <= 9.5 && cut1Timer > 1.5)
						{
							play("idle");
							message.text = "";
						}
						if (cut1Timer < 8)
						{
							message.text = "Ya made it!";
						}
						if (cut1Timer < 6.5)
						{
							message.text = "";
							
						}
						
							if (cut1Timer < 3)
							{
								message.text = "What'rya Waitin' for??"
								if (cut1Timer < 1.5) 
								{
									play("excited");
									message.size = 16; 
									message.x = x - 100;
									message.width = 4000;
									message.text = "COME SEE THE GIZMO!";
								}
							}
							
						
					}
				}
					
			}
			else if (cut1Timer < 0)
			{
				message.text = "";
				poof();
				Registry.wizUnfreeze = true;
				x = BEHINDGIFT;
				play("run");
				cut1Timer = 0;
				
			}
			
			//cutscene2
			if (cut2Timer > 0)
			{
				cut2Timer -= FlxG.elapsed;
				
				if (cut2Timer < .5)
				{
					message.size = 8;
					message.text = "Well, Come and git it!";
					message.width = 140;					
					Registry.wizUnfreeze2 = true;
					//Registry.gameLevel.player.moves = true;
					FlxControl.player1.setCursorControl(false, false, true, true);
					
				}
				
			}
			
			if (smushTimer > 0)
			{
				smushTimer -= FlxG.elapsed;
				if (smushTimer < .1)
				{
					play("dead");
					facing = RIGHT;
					x = BEHINDGIFT + 4;
					if (!smushedFlag) { 
						FlxG.play(smash, 1); 
						FlxG.shake(.08, .3);
						FlxG.music.stop();
						smushedFlag = true;
						}
				}
			}
			
			//AFTER GREETING YOU, WIZ MOVES OFFSCREEN TO RIGHT OF BIG PRESENT
			if (x == BEHINDGIFT && !impendingDoomFlag) //
			{
				velocity.x = 0;
				facing = FlxObject.LEFT;				
				if (cut2Timer == -100 && onScreen()) 
				{
					cut2Timer = 1;
				}
				Registry.giftExchange = true; //once wiz is on screen, turn on giftexchange cutscene
				message.x = x - 94
				message.y = y - 24;
				if (Registry.gameLevel.player.x >= x - 350) //rumble time
				{
					//freeze the player for the last time
					message.text = "";
					impendingDoomFlag = true;
					Registry.player.moves = false;
					Registry.player.velocity.x = 0;
					FlxG.shake(.1, 3, smush);
					if (!rumbleFlag) {FlxG.play(rumble, 1); rumbleFlag = true}
				
				}
				
			}
			
			
			
		}
		
		public function smush():void
		{
			
			smushFlag = true;
			
			Registry.player.moves = true;
			
			
		}
		
		public function poof():void
		{
			FlxG.flash(0x0000B9, 1);
			var rand1:int;
			var rand2:int;
			var randVelX:int;
			var randVelY:int;
			for (var i:int = 0; i < 500; i++)
			{
				rand1 = Math.random() * 10;
				rand2 = Math.random() * 20;
				randVelX = (Math.random() + 1) * 50;
				randVelY = (Math.random() + 1) * -5;
				smokelets.addSmokelet(x + rand1, y + 20 + rand2, true, randVelX, randVelY);
			}
		}
		
	}

}