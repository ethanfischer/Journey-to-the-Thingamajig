package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	//import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	//import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	
	public class MainMenuState extends FlxState
	{
		[Embed(source = "../assets/menulake.png")] private var titlePagePNG:Class;
		[Embed(source = "../assets/menuBox.png")] private var menuBoxPNG:Class;	
		[Embed(source = "../assets/menu trees.png")] private var menuTreesPNG:Class;
		[Embed(source = "../assets/selectthing.png")] private var dotsPNG:Class;
		[Embed(source = "../assets/quack.mp3")] private var quack:Class;
		[Embed(source = "../assets/title.png")] private var titlePNG:Class;
		
		[Embed(source="../assets/the.png")] private var thePNG:Class;
		[Embed(source="../assets/quest.png")] private var questPNG:Class;
		[Embed(source="../assets/to .png")] private var toPNG:Class;
		[Embed(source = "../assets/nowhere.png")] private var thingamajigPNG:Class;
		[Embed(source = "../assets/stars.png")] private var starsPNG:Class;
		[Embed(source = "../assets/black.png")] private var blackPNG:Class;
		[Embed(source = "../assets/punch2.mp3")] private var punchSFX:Class;
		//[Embed(source = "../assets/Save an Enemy.mp3")] private var horns:Class;
	
		[Embed(source = "../assets/start.png")] private var startPNG:Class;
		//[Embed(source = "../assets/fadein_chord1.mp3")] private var fadeChord1:Class
		//[Embed(source = "../assets/fadein_chord2.mp3")] private var fadeChord2:Class
		//[Embed(source = "../assets/fadein_chord3.mp3")] private var fadeChord3:Class
		//[Embed(source = "../assets/forestsounds.mp3")] public var l1msc:Class;
		//[Embed(source = "../assets/jazz_slowswing(drumfade_outandin).mp3")] private var l1msc:Class;
		//[Embed(source="../assets/EFFG-Level-2-or-3-v2.mp3")] private var l1msc:Class;
		[Embed(source="../assets/time.mp3")] private var l1msc:Class;

		//private var fadeChordflag1:Boolean;
		//private var fadeChordflag2:Boolean;
		//private var fadeChordflag3:Boolean;
		
		
	 	private var dots:FlxSprite = new FlxSprite(Registry.screenWidth / 2 - 34, Registry.screenHeight / 1.325); //40 is how far down dots are
		
		private var level:Level1;
		private var title:FlxSprite;
		private var dolly:FlxSprite;
		//private var start:FlxButton;
		private var levelsText:FlxText;
		private var levelsBox:FlxButton;
		private var selector:int = 1;
		
		//private var the:FlxSprite;
		private var quest:FlxSprite;
		private var to:FlxSprite;
		private var thingamajig:FlxSprite;
		private var stars:FlxSprite;
		private var stars2:FlxSprite;
		private var black:FlxSprite;
		private var menuTrees:FlxSprite;
		private var punchFlag:Boolean;
		private var timer:Number = 6;
		private var start:FlxSprite;
		
		public function MainMenuState() 
		{
		}
		
		override public function create():void
		{
			//mute mode
			FlxG.volume = 0;
		
			Registry.checkpointFlag = false;
			//FlxG.play(quack);
			Registry.firstTimePlayingLevel = true;
			
			FlxG.playMusic(l1msc, 1);
			
			dots.loadGraphic(dotsPNG, true, false, 72, 6);
			dots.drag.y = 3900;
			dots.addAnimation("blink", [0, 2], 3, true);
			dots.play("blink");
			
			var t:FlxSprite = new FlxSprite(0, 0, titlePagePNG);
			
			
			quest = new FlxSprite(0, 0);
			quest.loadGraphic(questPNG, false, false, 600, 300);
			quest.alpha = 0;
			
			to = new FlxSprite(0, 0);
			to.loadGraphic(toPNG, false, false, 600, 300);
			to.alpha = 0;
			
			thingamajig = new FlxSprite(0, 0);
			thingamajig.loadGraphic(thingamajigPNG, false, false, 600, 300);
			thingamajig.alpha = 0;
			
			start = new FlxSprite(0, 40);
			start.loadGraphic(startPNG, false, false, 500, 250);
			start.alpha = 0;
			
			menuTrees = new FlxSprite(0, 0);
			menuTrees.loadGraphic(menuTreesPNG, false, false, 1200, 300);
			menuTrees.velocity.x = -30;
			
			stars = new FlxSprite(0, 0);
			stars.loadGraphic(starsPNG, false, false, 1200, 300);
			
			stars2 = new FlxSprite(0, 0);
			stars2.loadGraphic(starsPNG, false, false, 1200, 300);
			
			black = new FlxSprite(0, 0);
			black.loadGraphic(blackPNG, false, false, 600, 300);
			black.alpha = 0;
				
			Registry.stageCount = 0;
				
			//levelsBox = new FlxButton(Registry.screenWidth / 2 - 29, 200, "LEVELS", goToLevelMenu);
			//start = new FlxButton(Registry.screenWidth / 2 - 30, 185, "START", startIt);
			
			//levelsBox.makeGraphic(64, 20, 0x00000000);
			
			//start.makeGraphic(64, 20, 0x00000000);
			
			//levelsBox.label.color = 0xffffff;
			//levelsBox.alpha = 0;
			
			//start.label.color = 0xffffff;
			//start.alpha = 0;
			
			
			stars.velocity.x = -200;
			stars2.velocity.x = 200;
			
			add(black);
			add(t);
			add(stars);
			add(stars2);
			add(menuTrees);
			add(title);
			//add(the);
			add(quest);
			add(to);
			add(thingamajig);
			add(start);
			
		}
		
		override public function update():void
		{
			super.update();
			dots.play("blink");
			
			//title.alpha += .01;
			
			if (stars.x < -600) stars.x = 0;
			if (stars2.x > 0) stars2.x = -600;	
			if (menuTrees.x < -600) menuTrees.x = 0;
			
			if (timer > 0)
			{	
				if (timer < 6)
				{
					quest.alpha += .5;
					if (timer < 4)
					{
						to.alpha += .5;
						if (timer < 2)
						{
							thingamajig.alpha += .01;

						}
					}
				}
				timer -= FlxG.elapsed;
			}
			else if (timer < 0)
			{
				start.alpha += .02;
			}
			
			if (start.alpha == 1)
			{
				add(start);
				add(levelsBox);
				add(dots);
			}
			
			if (FlxG.keys.justPressed("DOWN") && selector < 2) 
			{
				dots.frame = 0;
				selector++;
				dots.velocity.y = 354;
				FlxG.play(quack);
			}
			else if (FlxG.keys.justPressed("UP") && selector > 1) 
			{
				dots.frame = 0;
				selector--;
				dots.velocity.y = -354;
				FlxG.play(quack);
			}
			
			if (FlxG.keys.Z || FlxG.keys.X || FlxG.keys.SPACE || FlxG.keys.ENTER)
			{
				if (selector == 1) 
				{
					FlxG.flash(0x99999900, .1);
					if (!punchFlag)
					{
						FlxG.play(punchSFX, 1, false, true);
						punchFlag = true;
					}
					FlxG.shake(.03, .1);
					FlxG.fade(0x000000, 0.5, changeState); 
				}
				else if (selector == 2) 
				{
					FlxG.fade(0x000000, 0.2, changeState);
				}
				//FlxG.play(quack);
			}
			
		}
		
		private function changeState():void
		{
			if (selector == 1) 
				{	
					FlxG.switchState(new PlayState);
				}
				else if (selector == 2) 
				{	
					FlxG.switchState(new LevelMenuState);
				}
			//FlxG.switchState(new DeathMenuState);
		}
		
		override public function destroy():void
		{
			FlxSpecialFX.clear();
			
			super.destroy();
		}
		
		private function goToLevelMenu():void
		{
			FlxG.switchState(new LevelMenuState);
		}
		
		private function startIt():void
		{
			Registry.stageCount = 0;
			
			//TODO put this logic at beginning of each level or in gamelevel and use FirstTimePlayinglevel flag to make sure you don't overlap[ the music
			if (Registry.stageCount == 1) FlxG.playMusic(Registry.l2msc, 1);
			if (Registry.stageCount == 2) FlxG.playMusic(Registry.l3msc, 1);
			if (Registry.stageCount == 3) FlxG.playMusic(Registry.l4msc, 1);
			if (Registry.stageCount == 4) FlxG.playMusic(Registry.l5msc, 1);
			if (Registry.stageCount == 5) FlxG.playMusic(Registry.l6msc, 1);
			if (Registry.stageCount == 6) FlxG.playMusic(Registry.l7msc, 1);
			
			Registry.musixFlag = true;
			FlxG.flash(0x000000, 1);
			Registry.chkptsUsed = 0;
			
			FlxG.switchState(new PlayState);
		}
	}
}