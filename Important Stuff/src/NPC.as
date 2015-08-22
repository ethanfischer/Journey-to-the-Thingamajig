package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class NPC extends FlxSprite
	{
		[Embed(source = "../map/teddy.png")] private var NPCPNG:Class;
		[Embed(source = "../assets/here.mp3")] private var hereSFX:Class;
		private var hereSFXFLAG:Boolean;
		[Embed(source = "../assets/npcNoise2.mp3")] private var noise2:Class;
		private var noise2Flag:Boolean;
		[Embed(source = "../assets/bah.mp3")] private var bah:Class;
		[Embed(source = "../assets/bahfade.mp3")] private var bahfade:Class;
		[Embed(source = "../assets/trumpetfanfare_mom.mp3")] private var trumpet:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var bounceTimer:Number;
		private var knockBackTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		private var retreatFlag:Boolean = false;
		public var message:FlxText;
		public var messageCount:int = 0;
		private var text:String;
		public var meetTimer:Number;
		public var meetTimer2:Number;
		public var meetFlag:Boolean = false;
		
		public function NPC(x:int, y:int, i_facing:uint)
		{
			super(x * 16, y * 16);
			
			retreatFlag = false;
			
			message = new FlxText(x*16, y*16 - 30, 150, "");
		
			loadGraphic(NPCPNG, true, true, 16, 18);
			
			facing = i_facing;
			facing = FlxObject.RIGHT;
			
			immovable = true;
			solid = true;
			active = true;
			
			addAnimation("idle", [0], 20, true);
			addAnimation("dead", [0, 11, 12, 13], 60, false);
			addAnimation("punched", [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 0], 15, false);
			addAnimation("umbrella", [1, 2, 1, 2, 1, 2, 1, 2, 3, 0], 15, false);
			addAnimation("retreat", [14, 15, 16, 17, 16, 17, 16, 17] , 20, false);
			
			play("idle");
			
			dieTimer = 0;
			
			offset.y = -2;
			width = 3;
			offset.x = 8;
		}
		
		override public function kill():void
		{		
			isDying = true;
			
			acceleration.x = 0;
			drag.x = 100;
		
			removeSprite();
		}
		
		
		private function removeSprite():void
		{
			dieTimer = 3;
			play("dead");
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
				if (dieTimer < 1) this.alpha -= FlxG.elapsed * 5;
			}
			if (dieTimer < 0)
			{	
				exists = false;
			}
			
			if (meetTimer > 0)
			{
				meetFlag = true;
				meetTimer -= FlxG.elapsed;
				FlxG.music.volume = 0.5;
				Registry.gameLevel.cutscene.alpha += .02;
				//FREEZE THE PLAYER
				Registry.gameLevel.player.canPunch = false;
				FlxControl.player1.setCursorControl(false, false, false, false);
				if (meetTimer < 11) 
				{
					message.text = "!";
					if (!hereSFXFLAG)
					{
						FlxG.play(hereSFX);
						hereSFXFLAG = true;
					}
					
					if (meetTimer < 9)
					{
						if (!Registry.gameLevel.player.pickup) 
						{
							Registry.gameLevel.player.pickup = true;
							FlxG.play(trumpet);
							Registry.gameLevel.player.pickupTimer = 2;
						}
						Registry.hasFlower = true;
						Registry.gameLevel.not_a_flower.visible = true;
						if (!Registry.gameLevel.player.facingFlag) 
						{
							Registry.gameLevel.player.facing = FlxObject.RIGHT;
							Registry.gameLevel.player.facingFlag = true;
						}
						Registry.gameLevel.not_a_flower.niceToMeetYou();
						Registry.gameLevel.not_a_flower.x = Registry.gameLevel.player.x;
						message.text = "";
						if (meetTimer < 6)
						{
							message.text = "PRESS 'X' TO PUNCH";
							if (!noise2Flag)
							{
								FlxG.play(noise2);
								noise2Flag = true;
							}
							if (meetTimer < 3) 
							{
								//UNFREEZE PLAYER
								Registry.gameLevel.player.canIdle = true;
								Registry.gameLevel.player.canPunch = true;
								FlxControl.player1.setCursorControl(false, false, true, true);
								alpha -= FlxG.elapsed / 5;
								message.alpha -= FlxG.elapsed / 5;
								this.solid = false;
							}
						}
					}
				}
			}
			else if (meetTimer < 0)
			{	
				alpha -= FlxG.elapsed / 5;
				message.alpha -= FlxG.elapsed / 5;
				FlxG.music.volume = 1;
				meetTimer -= FlxG.elapsed;
				Registry.gameLevel.cutscene.alpha -= .03
				if (meetTimer < -1.5)
				{
					exists = false;
					message.exists = false;
					meetTimer = 0;
					Registry.gameLevel.player.facingFlag = false;
				}
			}
			
			
			//SECOND MEETING
			if (meetTimer2 > 0)
			{
				meetTimer2 -= FlxG.elapsed;
				
				if (meetTimer2 < 7)
				{
					if (meetTimer2 > 6.6) 
					{
						FlxG.play(trumpet);
						Registry.gameLevel.player.pickupTimer = 2;
						Registry.gameLevel.umbrella.visible = true;
						Registry.gameLevel.umbrella.x = Registry.gameLevel.player.x - 5;
					}
					if (meetTimer2 < 4)
					{
						if(meetTimer2 > 3.6) message.text = "";
						if (meetTimer2 < 2.6)
						{
							Registry.gameLevel.umbrella.exists = false;
						}
					}	
				}
				
			}	
		}
		
		
		public function bounce():void
		{
			kill();
		
			Registry.nmlTimescale = FlxG.timeScale;
			FlxG.timeScale = .3;
			bounceTimer = .01;
		}
		
		public function knockback():void
		{		
			velocity.y = -500;
			if (x > Registry.gameLevel.player.x)
			{
				velocity.x =  900;
			}
			else
			{
				velocity.x = -900;
			}
		}
		
		public function talk():void
		{
			play("punched");
			if (messageCount == 1)
			{
				message.text = "!";
				FlxG.play(bah);
				Registry.hasUmbrella = true;
				meetTimer2 = 8;
			}
			else if (messageCount == 3) //for some reason when you punch the NPC it calls talk() twice. This is terrible programming, but whatevs
			{
				message.text = "HOLD 'Z' TO USE IT";
				FlxG.play(hereSFX);
			}
			else if (messageCount == 5)
			{
				immovable = false;
				knockback();
				FlxG.play(bahfade);
				message.text = "";
			}
			messageCount += 1; 
		}
	}

}