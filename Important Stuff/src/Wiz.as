package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;

	public class Wiz extends FlxSprite
	{
		[Embed(source = "../assets/wiz.png")] private var wizPNG:Class;
		[Embed(source = "../assets/smash.mp3")] private var smash:Class;
		[Embed(source = "../assets/rumble_loud.mp3")] public var rumble:Class;
		[Embed(source = "../assets/wiz_laugh.mp3")] public var wizLaugh:Class;
		[Embed(source = "../assets/wiz_laugh2.mp3")] public var wizLaugh2:Class;
		[Embed(source = "../assets/wiz_laugh3.mp3")] public var wizLaugh3:Class;
		[Embed(source = "../assets/wiz_laugh_long.mp3")] public var wizLaughLong:Class;
		[Embed(source = "../assets/magic.mp3")] public var magic:Class;
		
		private var wizLaughFlag:Boolean = false;
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
		// public const BEHINDGIFT:int = 11170
		public var smokelets:Smokelets;
		public var impendingDoomFlag:Boolean = false;
		public var smushFlag:Boolean = false;
		public var smushTimer:Number;
		public var smushedFlag:Boolean;
		public var rumbleFlag:Boolean;
		[Embed(source = "../assets/fanfare.mp3")] private var fanfare:Class;
		private var fanfareFlag:Boolean = false;
		
		public function Wiz(x:int, y:int)
		{
			super(x, y);
			
			offset.y = -2;
			loadGraphic(wizPNG, true, true, 24, 48);
			solid = true;
			
			addAnimation("think", [3], 0, false);
			addAnimation("look", [5], 0, false);
			addAnimation("idle", [0], 0, true);
			addAnimation("excited", [1, 2, 1, 2, 1,1,1,1,1,1,1,1,1,1], 4, true);
			addAnimation("exuberant", [1, 2], 6, true);
			addAnimation("ecstatic", [1, 2], 8, true);
			addAnimation("run", [4], 12, true);
			addAnimation("dead", [6], 0, true);
			play("think");
			
			scrollFactor.x = 1;
			
			acceleration.y = 500;
			
			message = new FlxText(x - 68, y - 24, 100, "");
			message.alignment = "right";
		
			smokelets = new Smokelets();
			
			
		}
	
		override public function update():void
		{
			super.update();

			if (onScreen() && !shockedFlag)
			{
				cut1Timer = 12;
				shockedFlag = true;
			}
			//Timer
			if (cut1Timer > 0)
			{
				cut1Timer -= FlxG.elapsed;
				
				if (cut1Timer < 11)
				{
					if (!fanfareFlag)
					{
						FlxG.play(fanfare);
						fanfareFlag = true;
					}
					if(cut1Timer > 10.5) message.text = "!\t";
					if(cut1Timer < 10 && cut1Timer > 9) play("look");
					if (cut1Timer < 9)
					{
						if (isTouching(FLOOR) && cut1Timer > 7.5) {
						
						play("excited");
						if (!wizLaughFlag)
						{
							FlxG.play(wizLaugh);
							wizLaughFlag = true;
						}
						message.text = "Shucks!";
						}
						if (cut1Timer <= 7.5 && cut1Timer > 6)
						{
							wizLaughFlag = false;
							play("idle");
							message.text = "";
						}
						if (cut1Timer < 6 && cut1Timer > 4.5)
						{
							if (!wizLaughFlag)
							{
								FlxG.play(wizLaugh2);
								wizLaughFlag = true;
							}
							play("exuberant");
							message.text = "You came!";
						}
						if (cut1Timer < 4.5 && cut1Timer > 3)
						{
							wizLaughFlag = false;
							play("idle");
							message.text = "";
						}
						
						if (cut1Timer < 3 && cut1Timer > 1.5)
						{
							if (!wizLaughFlag)
							{
								FlxG.play(wizLaugh);
								wizLaughFlag = true;
							}
							play("ecstatic");
							message.text = "What are ya waiting for??"
						}
						if (cut1Timer < 1.5 && cut1Timer > 1)
						{
							message.text = "";
							wizLaughFlag = false;
						}
						if (cut1Timer < 1) 
						{
							if (!wizLaughFlag)
							{
								FlxG.play(wizLaughLong);
								wizLaughFlag = true;
							}
							
							play("excited");
							if(isTouching(FLOOR))velocity.y = -110;
							
							//message.y = y - 44;
							
							message.text = "COME SEE IT!";
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
				wizLaughFlag = false;
				
			}
			
			//cutscene2
			if (cut2Timer > 0)
			{
				// FlxG.log(cut2Timer);
				cut2Timer -= FlxG.elapsed;
			}
			if (cut2Timer < 0 && cut2Timer > -10)
			{
				message.text = "Come see it!";
				if (!wizLaughFlag)
				{
					FlxG.play(wizLaugh2);
					wizLaughFlag = true;
				}
				Registry.wizUnfreeze2 = true;
				//Registry.gameLevel.player.moves = true;
				FlxControl.player1.setCursorControl(false, false, true, true);
				Registry.noGoingBack = 11170 - Registry.screenWidth + 60;
				cut2Timer = 0;
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
						FlxG.shake(.02, .6, end);
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
					cut2Timer = 5.5;
					// cut2Timer = 1.5;
				}

				Registry.giftExchange = true; //once wiz is on screen, turn on giftexchange cutscene
				message.x = x - 94
				message.y = y - 24;
				if (Registry.gameLevel.player.x >= x - Registry.screenWidth * 1.5) //rumble time
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
		
		private function end():void
		{
			FlxG.pauseSounds();
			Registry.pauseSounds = true;
			// FlxG.volume = 0;
			FlxG.playMusic(Registry.silence, .5);
			Registry.theEnd = true;
		}
		
		public function poof():void
		{
			FlxG.flash(0x0000B9, 1);
			FlxG.play(magic);
			var rand1:int;
			var rand2:int;
			var randAclX:int;
			var randVelY:int;
			for (var i:int = 0; i < 500; i++)
			{
				rand1 = Math.random() * 10;
				rand2 = Math.random() * 20;
				randAclX = (Math.random()) * 200;
				randVelY = (Math.random() + 1) * -5;
				smokelets.addSmokelet(x + rand1, y + 20 + rand2, true, randAclX, randVelY);
			}
		}
		
	}

}