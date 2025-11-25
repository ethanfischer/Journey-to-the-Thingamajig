package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Main gameplay state
 * Manages level loading, UI, and game flow
 */
class PlayState extends FlxState
{
	private var currentLevel:GameLevel;
	private var levelButton:FlxButton;
	private var debugText:FlxText;

	override public function create():Void
	{
		super.create();

		// Set up mouse cursor
		#if !FLX_NO_MOUSE
		FlxG.mouse.load(Registry.cursor, 1, 0, 0);
		FlxG.mouse.visible = true;
		#end

		// Load Level1
		loadLevel(1);

		// Set world bounds to level dimensions
		if (currentLevel != null) {
			FlxG.worldBounds.set(0, 0, currentLevel.width, currentLevel.height);
		}

		// Create UI buttons
		createUI();
	}

	private function loadLevel(levelNum:Int):Void
	{
		// Clear existing level
		if (currentLevel != null)
		{
			remove(currentLevel);
			currentLevel.destroy();
			currentLevel = null;
		}

		// Create new level based on level number
		switch (levelNum)
		{
			case 1:
				currentLevel = new Level1();
			default:
				trace("Level " + levelNum + " not implemented yet");
				currentLevel = new Level1(); // Default to Level1
		}

		// Add level to state
		add(currentLevel);

		// Update Registry
		Registry.gameLevel = currentLevel;
		Registry.stageCount = levelNum - 1;
	}

	private function createUI():Void
	{
		// "Levels" button to return to menu
		levelButton = new FlxButton(2, 1, "Levels", goToMainMenu);
		levelButton.label.color = FlxColor.GRAY;
		levelButton.scrollFactor.set(0, 0); // Fixed to camera
		add(levelButton);

		// Debug text for animation info
		debugText = new FlxText(2, 20, 300, "");
		debugText.scrollFactor.set(0, 0);
		debugText.color = FlxColor.WHITE;
		add(debugText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Collide player with foreground tilemap
		if (currentLevel != null && currentLevel.player != null)
		{
			if (currentLevel.foreground != null) {
				FlxG.collide(currentLevel.foreground, currentLevel.player);
			}

			// Collide entities with foreground
			if (currentLevel.bots != null) {
				FlxG.collide(currentLevel.bots, currentLevel.foreground);
			}
			if (currentLevel.rocks != null) {
				FlxG.collide(currentLevel.rocks, currentLevel.foreground);
			}

			// Player-entity overlaps
			if (currentLevel.bots != null) {
				FlxG.overlap(currentLevel.player, currentLevel.bots, hitBot);
			}
			if (currentLevel.checkpoints != null) {
				FlxG.overlap(currentLevel.player, currentLevel.checkpoints, hitCheckpoint);
			}
			if (currentLevel.reinforcements != null) {
				FlxG.overlap(currentLevel.player, currentLevel.reinforcements, hitReinforcement);
			}

			// Update debug text
			var p = currentLevel.player;
			var animName = p.animation.name != null ? p.animation.name : "null";
			var curAnim = p.animation.curAnim;
			var frame = curAnim != null ? curAnim.curFrame : -1;
			var frameIdx = p.animation.frameIndex;
			var jumpStr = Std.string(p._jump).substr(0, 5);
			debugText.text = "Anim: " + animName + " frame:" + frame + " idx:" + frameIdx + "\nvel.x: " + Std.int(p.velocity.x) + " _jump:" + jumpStr;
		}

		// ESC key to return to menu
		if (FlxG.keys.justPressed.ESCAPE)
		{
			goToMainMenu();
		}

		// Debug: R to restart level
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
	}

	private function goToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
		{
			FlxG.switchState(new MainMenuState());
		});
	}

	private function hitBot(player:Player, bot:Bot):Void
	{
		// If player falling onto bot, kill the bot
		if (player.velocity.y > 0 && player.y + player.height < bot.y + bot.height / 2)
		{
			bot.kill();
			player.velocity.y = -310; // Bounce (Flash used 310)
			FlxG.sound.play(AssetPaths.BOT_KILL_SFX);
		}
		else
		{
			// Bot hurts player
			// TODO: Implement player damage system
			trace("Player hit by bot!");
		}
	}

	private function hitCheckpoint(player:Player, checkpoint:Dynamic):Void
	{
		var cp:Checkpoint = cast checkpoint;
		if (cp.isEnd)
		{
			// Level complete!
			FlxG.sound.play(AssetPaths.POP_SFX);
			cp.kill();
			trace("Level complete - end bubble popped!");
			// TODO: Transition to level complete state
		}
		else
		{
			// Save checkpoint
			if (cp.popable)
			{
				cp.kill();
				Registry.checkpoint = cp.getMidpoint();
				Registry.checkpointFlag = true;
				FlxG.sound.play(AssetPaths.POP_SFX);
			}
		}
	}

	private function hitReinforcement(player:Player, reinforcement:Reinforcement):Void
	{
		reinforcement.collect();
	}

	override public function destroy():Void
	{
		currentLevel = null;
		levelButton = null;

		super.destroy();
	}
}
