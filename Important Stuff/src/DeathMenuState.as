package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	//import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	//import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	
	public class DeathMenuState extends FlxState
	{	
		private var levelMessage:FlxText;
		private var levelNumber:int;
		private var deathMessage:FlxText;
		private var spacebarMessage:FlxText;
		private var timer:Number;
		//private var reveal:CenterSlideFX;
		[Embed(source = "../assets/quack.mp3")] private var quack:Class;
		[Embed(source = "../assets/writing.mp3")] private var writing:Class;
		//Level1,3
		[Embed(source = "../assets/forestsounds.mp3")] public var forestSounds:Class;
		//Level2
		[Embed(source = "../assets/forestsounds2.mp3")] public var forestSounds2:Class;
		//Level4
		[Embed(source = "../assets/river.mp3")] private var water:Class;
		//Level 5
		//[Embed(source = "../assets/distant_thunder.mp3")] public var dwarfDance:Class; //mountain ambience mode
		 [Embed(source="../assets/howler_monkeys_thunder.mp3")]public var dwarfDance:Class;
		
		[Embed(source = "../assets/rumble.mp3")] public var rumble:Class;
		
		public function DeathMenuState() 
		{
		}
		
		override public function create():void
		{			
			deathMessage = new FlxText(Registry.screenWidth/5, Registry.screenHeight/14, 320, "" + levelNumber);
			deathMessage.size = 180; 
			deathMessage.alignment = "center";
			
			//FlxG.play(writing, 1, false);
			//if (Registry.stageCount == 0) FlxG.playMusic(forestSounds, 1);
			if (Registry.stageCount == 1) FlxG.playMusic(forestSounds2, 1);
			if (Registry.stageCount == 2) FlxG.playMusic(forestSounds, 1);
			if (Registry.stageCount == 3) FlxG.playMusic(water, 1);
			if (Registry.stageCount == 4) FlxG.playMusic(water, 1);
			if (Registry.stageCount == 5) FlxG.playMusic(dwarfDance, 1);
			if (Registry.stageCount == 6) FlxG.playMusic(rumble, 1);
			
			Registry.musixFlag = true;
			FlxG.flash(0x000000, 1);
			Registry.chkptsUsed = 0;
			
			//handle level names here
			if (Registry.stageCount == 0) deathMessage.text = "1";
			else if (Registry.stageCount == 1) deathMessage.text = "2";
			else if (Registry.stageCount == 2) deathMessage.text = "3";
			else if (Registry.stageCount == 3) deathMessage.text = "4";
			else if (Registry.stageCount == 4) deathMessage.text = "5";
			else if (Registry.stageCount == 5) deathMessage.text = "6";
			else if (Registry.stageCount == 6) deathMessage.text = "7";
			else deathMessage.text = "?";
			
			add(deathMessage);	
			timer = 1.5;
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (timer > 0)
			{
				timer -= FlxG.elapsed;
			}
			if (timer < 0)
			{
				Registry.deaths = 0;
				FlxG.fade(0xff000000, .5, changeState);
			}
			
			/*if (!Registry.gameStart)
			{
				if (!Registry.deathMessageFlag) FlxG.music.fadeOut(.5);
			} */
			
			
			
		}
		
		private function changeState():void
		{
			FlxG.switchState(new PlayState);
		}
		
		override public function destroy():void
		{
			FlxSpecialFX.clear();
			
			super.destroy();
		}
		
	}

}