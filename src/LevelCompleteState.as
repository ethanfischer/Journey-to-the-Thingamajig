package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	//import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	//import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	
	public class LevelCompleteState extends FlxState
	{	
		private var levelMessage:FlxText;
		private var levelNumber:int;
		private var deathMessage:FlxText;
		private var totalDeathsMessage:FlxText;
		private var levelDeathsMessage:FlxText;
		private var spacebarMessage:FlxText;
		private var chkptsUsedText:FlxText;
		private var totalChkptsUsedText:FlxText;
		private var awardTimer:Number;
		private var timer:Number = 5;
		private var i_totalTime:Number;
		private var drumRollFlag:Boolean;
		
		[Embed(source="../assets/z_scoreappear.mp3")] private var bingbong:Class;
		//[Embed(source = "../assets/Dats Dat Kuuuush.mp3")] private var datsDatKush:Class;
		[Embed(source = "../assets/congrats.mp3")] private var datsDatKush:Class;
		[Embed(source = "../assets/cone.png")] private var cone:Class;
		[Embed(source = "../assets/cream1.png")] private var trophy1PNG:Class;
		[Embed(source = "../assets/cream2.png")] private var trophy2PNG:Class;
		[Embed(source = "../assets/cream3.png")] private var trophy3PNG:Class;
		[Embed(source = "../assets/drumroll.mp3")] private var drumRoll:Class;
		[Embed(source = "../assets/splat.mp3")] private var splat:Class;
		
		private var trophy:FlxSprite = new FlxSprite(0, 0);
		private var sFlag1:Boolean;
		private var sFlag2:Boolean;
		private var sFlag3:Boolean;
		
		//private var reveal:CenterSlideFX;
		
		public function LevelCompleteState() 
		{
		}
		
		override public function create():void
		{	
			//FlxG.music.stop();
			//FlxG.music.fadeOut(2);
			FlxG.flash(0x000000, 1, start);
			levelNumber = Registry.stageCount;
			
			
			
			deathMessage = new FlxText(Registry.screenWidth/2 - 95, 70, 320, "");
			deathMessage.size = 40; 
			
			levelDeathsMessage = new FlxText(Registry.screenWidth/2 - 25, 200, 320, "Deaths: " + Registry.deaths);
			levelDeathsMessage.size = 12;
			
			i_totalTime = Registry.playtime;
			totalDeathsMessage = new FlxText(Registry.screenWidth/2 - 25, 235, 320, "Time: " + FlxU.formatTime(i_totalTime));
			totalDeathsMessage.size = 12;
			
			totalChkptsUsedText = new FlxText(Registry.screenWidth/2 - 45, 245, 320, "Total Checkpoints: " + Registry.totalChkptsUsed);
			totalChkptsUsedText.size = 12;
				
			spacebarMessage = new FlxText(Registry.screenWidth/2 - 25, 260, 320, "PRESS SPACEBAR");
			spacebarMessage.size = 6;
		
			add(deathMessage);
			add(totalDeathsMessage);
			
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (timer > 0)
			{		
				if (timer < 4)
				{
					if (!drumRollFlag)
					{
						drumRollFlag = true;
						FlxG.play(drumRoll, 1);
					}
					
					trophy.loadGraphic(cone, false);
					add(trophy);
					if (timer < 3.5) 
					{
						trophy.loadGraphic(trophy1PNG);
						if (!sFlag1) 
						{
							FlxG.play(splat, 1);
							sFlag1 = true;
						}
						if (timer < 2.7 && Registry.playtime < Registry.sndPlace) 
						{
							trophy.loadGraphic(trophy2PNG, false);
							if (!sFlag2)
							{
								FlxG.play(splat, 1);
								sFlag2 = true;
							}
							if (timer < 1.9 && Registry.playtime < Registry.fstPlace) 
							{
								trophy.loadGraphic(trophy3PNG, false);
								if (!sFlag3)
								{
									FlxG.play(splat, 1);
									sFlag3 = true;
								}
							}
						}
					}
					
					
				}	
				totalDeathsMessage = new FlxText(Registry.screenWidth / 2 - 25, 230, 320, "Time: " + FlxU.formatTime(i_totalTime));
				totalDeathsMessage.size = 12;
				timer -= FlxG.elapsed;
			}
			else if (timer < 0)
			{
				Registry.playtime = 0;
				FlxG.fade(0xff000000, 1, changeState);
			}
			
			/*if (timer < 2.7 && timer > 2.4)
			{
				add(levelDeathsMessage);
				add(totalDeathsMessage);
			}
			
			else if (timer < 0)
			{
				Registry.deaths = 0;
				FlxG.fade(0xff000000, 1, changeState);
			}
			*/
			
		}
		
		private function changeState():void
		{
			
			Registry.gameStart = false;
			FlxG.switchState(new DeathMenuState);
		}
		
		private function start():void
		{
			timer = 5;
		}
		
		override public function destroy():void
		{
			FlxSpecialFX.clear();
			
			super.destroy();
		}
	
	}

}