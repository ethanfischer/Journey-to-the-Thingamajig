package  
{
	import org.flixel.*;

	public class Reinforcement extends FlxSprite
	{
		private var player:Player;
		private var timer:Number;
		private	var killFlag:Boolean = false;
		
		//[Embed(source="../assets/Rubber Band Hit.mp3")] private var reinforcementSFX:Class;
		//[Embed(source="../assets/guitar_E9.mp3")] private var reinforcementSFX:Class;
		[Embed(source = "../assets/NomNomcollect.mp3")] private var reinforcementSFX:Class;
		
		[Embed(source="../map/Reinforcement.png")] private var ReinforcementPNG:Class;
		
		public function Reinforcement(x:int, y:int)
		{
			super(x * 16, y * 16);
			
			offset.y = 0;
			visible = true;
			
			loadGraphic(ReinforcementPNG, true, true, 16, 16);
			
			addAnimation("explode", [8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11], 10, false);
			addAnimation("idle", [1,2,3,4,5,6,7,7], 9, true);
			
			play("idle");
			
			immovable = true;
			active = true;
			
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
			
			/* if (Registry.pauseSounds)
			{
				reinforcementSFX = null;
			} */
			
		}
		
		override public function kill():void
		{
			solid = false;
			FlxG.play(reinforcementSFX);
			
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