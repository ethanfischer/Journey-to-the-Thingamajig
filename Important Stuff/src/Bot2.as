package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Bot2 extends Bot
	{
		[Embed(source = "../assets/bot2.png")] private var bot2PNG:Class;
		[Embed(source = "../assets/botKillSFX.mp3")] private var botKillSFX:Class;
		[Embed(source = "../assets/blade2.png")] private var blade:Class;
		[Embed(source = "../assets/drawerslide.mp3")] private var fireSoundEffect:Class;
	
		
		public var fireSFX:FlxSound;
		private var dieTimer:Number;
		private var player:Player;
		private var knockbackTimer:Number;
		private var knockbackTimerFlag:Boolean;
		private var canKnockback:Boolean = false;
		public var weapon:FlxWeapon;
		public var direction:uint;
		public var updateForever:Boolean;
		private var dodgeTimer:Number = 0;
		
		public function Bot2(x:int, y:int, i_player:Player, i_weapon:FlxWeapon, i_facing:uint, bladeSpeed:int, i_active:Boolean = false, fireRate:int = 1, bullets:int = 4, i_updateForever:Boolean = false)
		{
			super(x, y, i_player, FlxObject.RIGHT);
			
			fireSFX = new FlxSound();
			fireSFX.loadEmbedded(fireSoundEffect, false, true);
			fireSFX.volume = 0;
			
			weapon = i_weapon;
			updateForever = i_updateForever;
			var bulletBoundRect:FlxRect = new FlxRect((x * 16) - 800, (y * 16) + 4, 1600, 8);
			
			weapon.setParent(this, "x", "y", 0, 0, true);
			weapon.makeAnimatedBullet(bullets, blade, 16, 2, [0, 1], 25, true, 5, 3);
			weapon.bulletLifeSpan = 20000;
			weapon.setBulletSpeed(bladeSpeed);
			weapon.setFireRate((2950 + (bladeSpeed * 3.125)) / fireRate);
			weapon.setBulletBounds(bulletBoundRect);
			weapon.setFireCallback(meh, fireSFX);

			player = i_player;
			
			loadGraphic(bot2PNG, true, true, 16, 24);
			
			facing = i_facing;
			
			solid = true;
			active = i_active;
			
			addAnimation("idle", [0,1], 30, true);
			addAnimation("dead", [11], 1, false);
			addAnimation("dodge", [14], 0, false);
			
			play("idle");
			
			dieTimer = 0;
			
			acceleration.y = 500;
			velocity.x = 0;
		}
		
		override public function update():void
		{
			super.update();
			
			if (!isDying)
			{
				velocity.x = 0;
			}
			
			if (!isDying)
			{
				if(isTouching(FLOOR)) weapon.fire(); //don't shoot before they land
				
				if (Registry.pauseSounds) this.fireSFX.volume = 0;
				if (Registry.stageCount == 2 && (this.x > 2110 && this.x < 2120)) this.fireSFX.volume = 0.05; //for those three guys in level 3
				else if(this.onScreen()) fireSFX.volume = 1;
				else fireSFX.volume = .2; 
			}

			if(dodgeTimer > 0)
			{
				dodgeTimer -= FlxG.elapsed;
			}
			else if (dodgeTimer < 0)
			{
				dodgeTimer = 0;
				play("idle");
			}
			
			
		
			
		}

		override public function dodge():void
		{
			play("dodge");
			dodgeTimer = .2;
		}

		override public function isBot2():Boolean
		{
			return true;
		}
		
		override public function retreat():void
		{
			
		}
		
		override public function turnAround():void
		{
			//do nothing. Bot2 can't turn around
		}
		
		private function meh():void
		{
			//empty function
		}
	}

}