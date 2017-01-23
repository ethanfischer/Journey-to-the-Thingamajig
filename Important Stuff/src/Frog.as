package  
{
	import org.flixel.*;

	public class Frog extends FlxSprite
	{
		[Embed(source = "../assets/Frog.png")] private var FrogPNG:Class;
		[Embed(source = "../assets/frog.mp3")] private var ribbit:Class;
		[Embed(source = "../assets/frog_death.mp3")] private var frogDeath:Class;
		public var message:FlxText;
		private var insults:Array = new Array();
		private var retreatFlag:Boolean;
		private var speakFlag:Boolean;
		
		public function Frog(x:int, y:int)
		{
			super(x, y);
			
			loadGraphic(FrogPNG, true, true, 16, 16);
			facing = FlxObject.LEFT;
			width = 16;
			height = 16;
			solid = true;
			offset.y = -1;
			addAnimation("idle", [0,0,0,0,0,0,1,1,2,1,0,0,1,2,1,0,0,0,0,0,0,0,0,0,0,0,0], 20, true);
			addAnimation("retreat", [3], 0, false);
			
			message = new FlxText(x, y, 100);
			message.alignment = "center";
			
			insults.push("Give up");
			insults.push("Suck much?");
			insults.push("Just quit");
			insults.push("Wow.");
			insults.push("Be better");
			insults.push("Embarassing");
			insults.push("You're bad");
			insults.push("Stop playing");
			insults.push("No skill");
			insults.push("You blow");
			
			play("idle");
		
			acceleration.y = 800;
		}
		
		override public function update():void
		{
			super.update();
			
			if (y > 500) kill();
			
			if (insultZone()) speak();
			else message.text = "";
			
			
			if (retreatZone()) retreat();
		
		}
		
		public function speak():void
		{
			if (speakFlag) return;
			message.x = x - 50;
			message.y = y - 25;
			var rand:int = int(Math.random() * 9);
			message.text = insults[rand];
			speakFlag = true;
			FlxG.play(ribbit);
		}
		
		private function insultZone():Boolean
		{
			if (Registry.gameLevel.player.x > x - 200 && Registry.gameLevel.player.x < x + 200
			&& Registry.gameLevel.player.y > y - 75 && Registry.gameLevel.player.y < y + 75)
			{
				return true;
			}
			else return false;
		}
		
		private function retreatZone():Boolean
		{
			if (Registry.gameLevel.player.x > x - 75 && Registry.gameLevel.player.x < x + 75
			&& Registry.gameLevel.player.y > y - 75 && Registry.gameLevel.player.y < y + 75 &&
			Registry.gameLevel.player.velocity.x  > 80) return true;
			else return false;
		}
		
		public function retreat():void
		{		
			if (retreatFlag) return;
			play("retreat");
			if(!(Registry.stageCount == 3 && Registry.checkpointFlag)) message.text = "";
			facing = FlxObject.RIGHT;
			velocity.y = -75;
			velocity.x = 100;
			retreatFlag = true;
			solid = false;
			
		}
		
		public function knockBack():void
		{
			velocity.x = 400;
			velocity.y = -300;
			solid = false;
			angle = 45;
			FlxG.play(frogDeath);
		}
	}

}