package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	//import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	//import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	
	public class LevelMenuState extends FlxState
	{
		[Embed(source = "../assets/StartPage.png")] private var titlePagePNG:Class;
		[Embed(source = "../assets/menuBox.png")] private var menuBoxPNG:Class;
		[Embed(source = "../assets/l1.png")] private var l1PNG:Class;
		[Embed(source = "../assets/l2.png")] private var l2PNG:Class;
		[Embed(source = "../assets/levels.png")] private var levelsPNG:Class;
		[Embed(source = "../assets/bracket.png")] private var bracket:Class;
		[Embed(source = "../assets/selectthing.png")] private var dotsPNG:Class;	
		[Embed(source = "../assets/quack.mp3")] private var quack:Class;
		
	 	private var dots:FlxSprite = new FlxSprite(Registry.screenWidth / 2 - 29, Registry.screenHeight - 29);
		private var selector:int = 1;
		
		private var l1pic:FlxSprite;
		//private var l2pic:FlxSprite;
		
		private var lpics:Array = new Array;
		private var lpic:FlxSprite;
		private var lpicCount:int = 0;
		
		private var title:FlxSprite;
		private var back:FlxText;
		private var l1:FlxButton;
		private var l2:FlxButton;
		private var l3:FlxButton;
		private var l4:FlxButton;
		private var l5:FlxButton;
		private var l6:FlxButton;
		private var l7:FlxButton;
		private var currentButton:FlxButton;
		private var levelCount:int = 0;
		
		private var levels:Array;
		
		//private var reveal:CenterSlideFX;
		
		
		
		public function LevelMenuState() 
		{
		}
		
		override public function create():void
		{
		FlxG.play(quack);
			
		//Registry.checkpointFlag = false;	
			
		var t:FlxSprite = new FlxSprite(0, 0, titlePagePNG);
			
		//title = new FlxText(Registry.screenWidth / 2 - 25, Registry.screenHeight / 8, 320, "LEVELS");
		back = new FlxText(Registry.screenWidth / 2 -7, Registry.screenHeight - 20, 320, "BACK");
		
		l1 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 1", changeState);
		l2 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 2", changeState);
		l3 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 3", changeState);
		l4 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 4", changeState);
		l5 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 5", changeState);
		l6 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 6", changeState);
		l7 = new FlxButton(Registry.screenWidth / 2 - 25, Registry.screenHeight - 35, "LEVEL 7", changeState);
		
		dots.loadGraphic(dotsPNG, true, false, 72, 6);
		dots.drag.y = 4500;
		dots.addAnimation("blink", [0, 2], 3, true);
		dots.addAnimation("arrows", [1, 2], 3, true);
		dots.play("blink");
		
		l1pic = new FlxSprite(Registry.screenWidth / 2 - 250, 0);
		l1pic.loadGraphic(levelsPNG, false, false, 3500, 250, false);
		l1pic.drag.x = 64800;
		
		
		//l2pic = new FlxSprite(Registry.screenWidth / 2 - 350, 15);
		//l2pic.loadGraphic(bracket, false, false, 700, 250, false);
		
		
		
		lpics = [l1pic];//, l2pic];
		
		
		l1.makeGraphic(64, 20, 0x00000000);
		l2.makeGraphic(64, 20, 0x00000000);
		l3.makeGraphic(64, 20, 0x00000000);
		l4.makeGraphic(64, 20, 0x00000000);
		l5.makeGraphic(64, 20, 0x00000000);
		l6.makeGraphic(64, 20, 0x00000000);
		l7.makeGraphic(64, 20, 0x00000000);
		
		l1.label.color = 0xffffff;
		l2.label.color = 0xffffff;
		l3.label.color = 0xffffff;
		l4.label.color = 0xffffff;
		l5.label.color = 0xffffff;
		l6.label.color = 0xffffff;
		l7.label.color = 0xffffff;
		
		levels = [l1, l2, l3, l4, l5, l6, l7];
		
		//FlxG.mouse.load(Registry.cursor, 1, 0, 0);
			
		add(l1pic);
		//add(l2pic);
		add(dots);
		add(back);
		
		
		}
		
		override public function update():void
		{
			super.update();
			
			if (selector == 1) dots.play("arrows");
			else dots.play("blink");
			
			//use arrow keys to scroll through level titles
			if (levelCount < 6 && l1pic.velocity.x == 0 && FlxG.keys.RIGHT && selector == 1) 
			{
				levelCount += 1;
				// Registry.stageCount += 1;
				l1pic.velocity.x = -8000;
				FlxG.play(quack);
			}
			if (levelCount > 0 && l1pic.velocity.x == 0 && FlxG.keys.LEFT && selector == 1)
			{
				levelCount -= 1;
				// Registry.stageCount -= 1;
				l1pic.velocity.x = 8000;
				FlxG.play(quack);
			}
			
			if (FlxG.keys.justPressed("Z") || FlxG.keys.ENTER) 
			{
				if (selector == 1) changeState();
				else FlxG.switchState(new PlayState);
				FlxG.play(quack);
			}
			
			remove(currentButton);
			currentButton = levels[levelCount];
			add(currentButton);
			
			
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
			
			
			/*emove(lpic);
			lpic = lpics[lpicCount];
			add(lpic); */
			
	
			
		}
		
		private function changeState():void
		{
			/*if (Registry.stageCount == 1) FlxG.playMusic(Registry.l2msc, 1);
			if (Registry.stageCount == 2) FlxG.playMusic(Registry.l3msc, 1);
			if (Registry.stageCount == 3) FlxG.playMusic(Registry.l4msc, 1);
			if (Registry.stageCount == 4) FlxG.playMusic(Registry.l5msc, 1);
			if (Registry.stageCount == 5) FlxG.playMusic(Registry.l6msc, 1);
			if (Registry.stageCount == 6) FlxG.playMusic(Registry.l7msc, 1);*/
			Registry.stageCount = levelCount;
			Registry.checkpointFlag = false;
			Registry.musixFlag = true;
			FlxG.flash(0x000000, 1);
			Registry.chkptsUsed = 0;
			FlxG.switchState(new PlayState);

			if(Registry.stageCount == 1 && Registry.hasFlower)
			{
				FlxG.playMusic(Registry.l2msc);
			}
			else if(Registry.stageCount == 2 && !Registry.firstLevel3)
			{
				FlxG.playMusic(Registry.l3msc);
			}
			else if(Registry.stageCount == 3 && !Registry.firstLevel4)
			{
				FlxG.playMusic(Registry.l4msc);
			}
			else if(Registry.stageCount == 4 && Registry.hasUmbrella)
			{
				FlxG.playMusic(Registry.l5msc);
			}
			else if(Registry.stageCount == 5 && !Registry.firstLevel6)// TODO && !Registry.firstLevel6)
			{
				FlxG.playMusic(Registry.l6msc);
			}
			else if(Registry.stageCount == 6) //TODO && !Registry.firstLevel7)
			{
				FlxG.playMusic(Registry.l7msc);
			}
		}
		
		override public function destroy():void
		{
			FlxSpecialFX.clear();
			super.destroy();
		}
		
		
		
	}

}