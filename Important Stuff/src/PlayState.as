package
{
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;

	public class PlayState extends FlxState
	{
		private var _gameLevel:GameLevel;
		private static var stages:Array;
		private static var stageCount:int = Registry.stageCount; //what stage the user is currently on (0 means Level 1, 1 means Level 2, etc.)
		private var _level1:Class = Level1;
		private var _level2:Class = Level2;
		private var _level3:Class = Level3;
		private var _level4:Class = Level4;
		private var _level5:Class = Level5;
		private var _level6:Class = Level6;
		private var _level7:Class = Level7;
		private var _menuButton:FlxButton;
		private var _muteButton:FlxButton;
		public var healthBar:FlxHealthBar;
		private var _amountOfDeathsMessage:FlxText;
		private var _playtimeMessage:FlxText;
		private var _torchFlag:Boolean = false;
		private var _randBot:Bot;
		public var streamDrag:Boolean = false;
		private var _streamLeft:Boolean = true;
		private var _shakeFlag:Boolean;
		private var _letterTimer:Number;
		private var _npcTextTime:Number;
		private var _partyPopflag:Boolean;
		private var _splosion:Poof;
		private var _splat:FlxSprite = new FlxSprite(0, 0);

		[Embed(source = "../assets/punch2.mp3")] public var punchSFX:Class;
		[Embed(source = "../assets/kick.mp3")] public var kickSFX:Class;
		[Embed(source = "../assets/swing&aMiss.mp3")] public var whiffSFX:Class;
		[Embed(source = "../assets/NomNomcollect.mp3")] public var nomNomSFX:Class;
		[Embed(source = "../assets/botKillSFX2.mp3")] private var _botKillSFX:Class;
		[Embed(source = "../assets/boing.mp3")] private var _boing:Class;
		[Embed(source = "../assets/applause.mp3")] private var _applause:Class;
		[Embed(source = "../assets/poof.mp3")] private var _poof:Class;
		[Embed(source="../assets/dropMug.mp3")] private var _gong:Class;
		[Embed(source = "../assets/clinkclankspin.mp3")] private var _clinkspinSFX:Class;
		[Embed(source = "../assets/trumpetfanfare_mom.mp3")] private var _trumpetSFX:Class;
		[Embed(source = "../assets/mute.png")] private var _mutePNG:Class;
		[Embed(source = "../assets/menu.png")] private var _menuPNG:Class;
		[Embed(source = "../assets/splat.png")] private var __splatPNG:Class;
		[Embed(source = "../assets/party_pop.mp3")] private var _partyPop:Class;
		[Embed(source = "../assets/foldpaper(openletter).mp3")] private var _openletter:Class;

		//only here so reference in PlayState doesn't freak out
		//HI
		public function PlayState()
		{
		}

		override public function create():void
		{
			stages = [_level1, _level2, _level3, _level4, _level5, _level6, _level7];

			if(!Registry.pauseSounds) FlxG.volume = .5;

			_menuButton = new FlxButton(2, 2, "Main Menu", gotoMainMenu);
			_menuButton.loadGraphic(_menuPNG, false, false, 56, 12);
			_menuButton.label.color = 0xFFFFFF;
			_menuButton.scrollFactor.x = 0;
			_menuButton.scrollFactor.y = 0;

			_muteButton = new FlxButton(Registry.screenWidth - 21, 13, "", mute, true);
			_muteButton.loadGraphic(_mutePNG, true, false, 12, 12);
			_muteButton.scrollFactor.x = 0;
			_muteButton.scrollFactor.y = 0;

			_splat.scrollFactor.x = 0;
			_splat.scrollFactor.y = 0;

			if (Registry.gameStart)
			{
				FlxG.flash(0x00000000, 1);
				Registry.gameStart = false;
			}
			else
			{
				FlxG.flash(0x00000000, .2);
			}
			makeStage(); //initializes and adds all the stuff

			//	Tell flixel how big our game world is
			FlxG.worldBounds = new FlxRect(0, 0, _gameLevel.width, _gameLevel.height);
			//	Don't let the camera wander off the edges of the map
			FlxG.camera.setBounds(0, 0, _gameLevel.width, _gameLevel.height);
			//	The camera will follow the player
			FlxG.camera.follow(_gameLevel.player, FlxCamera.STYLE_PLATFORMER);
		}

		override public function update():void
		{
			super.update();

			if (!Registry.gameStart)
			{
				//Collisions
				FlxG.collide(_gameLevel.player, _gameLevel.foreground);
				FlxG.collide(_gameLevel.player, _gameLevel.crumbleRocks, crumble);
				FlxG.collide(_gameLevel.player, _gameLevel.fadeBlocks);
				FlxG.collide(_gameLevel.player, _gameLevel.npc);
				FlxG.collide(_gameLevel.bots, _gameLevel.foreground);
				if (Registry.stageCount == 6) FlxG.collide(_gameLevel.bots, _gameLevel.bots);
				FlxG.collide(_gameLevel.bots, _gameLevel.crumbleRocks);
				FlxG.overlap(_gameLevel.bots, _gameLevel.rocks, botRock);
				FlxG.collide(_gameLevel.bots, _gameLevel.rocks, botRock);
				FlxG.collide(_gameLevel.bots2, _gameLevel.foreground);
				FlxG.collide(_gameLevel.bots2, _gameLevel.crumbleRocks);
				FlxG.collide(_gameLevel.bots2.blades, _gameLevel.foreground, killBlade);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.foreground);
				FlxG.collide(_gameLevel.borgs, _gameLevel.foreground);
				FlxG.collide(_gameLevel.borgs, _gameLevel.rocks);
				FlxG.collide(_gameLevel.rocks, _gameLevel.player);
				FlxG.collide(_gameLevel.foreground, _gameLevel.rocks);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.rocks);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.crumbleRocks);
				FlxG.collide(_gameLevel.npc, _gameLevel.foreground);

				//Overlappings
				FlxG.overlap(_gameLevel.player, _gameLevel.reinforcements, hitReinforcement);
				FlxG.overlap(_gameLevel.player, _gameLevel.bots, hitBot);
				FlxG.overlap(_gameLevel.player, _gameLevel.bots2, hitBot);
				FlxG.overlap(_gameLevel.player, _gameLevel.borgs, hitBorg);
				FlxG.overlap(_gameLevel.player, _gameLevel.torches, hitFire);
				FlxG.overlap(_gameLevel.player, _gameLevel.lilguy, hitLilguy);

				if(Registry.stageCount == 3 && Registry.firstLevel4) FlxG.overlap(_gameLevel.player, _gameLevel.mail, hitMail);

				FlxG.overlap(_gameLevel.foreground, _gameLevel.torches, flameOn);
				FlxG.overlap(_gameLevel.player, _gameLevel.nomNoms, hitNomNom);
				FlxG.overlap(_gameLevel.bots, _gameLevel.nomNoms, hitNomNom);

				if (!FlxG.overlap(_gameLevel.player, _gameLevel.nomNoms)) _torchFlag = false; //eliminate torches turning on and off when overlaping switch

				FlxG.overlap(_gameLevel.player, _gameLevel.bots2.blades, hitBlade);
				FlxG.overlap(_gameLevel.player, _gameLevel.streams, handleStreams);
				FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.rocks, punchRock);

				if (Registry.stageCount == 4) FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.npc, punchNPC);

				FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.bots, punchBot);
				FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.bots2, punchBot);
				FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.borgs, punchBorg);

				if (Registry.stageCount == 1) FlxG.overlap(_gameLevel.player.hitBox, _gameLevel.npc, meetNPC);

				FlxG.overlap(_gameLevel.player.screen, _gameLevel.bots, updateThings);
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.bots2, updateThings);
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.rocks, updateThings);
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.crumbleRocks, updateThings);
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.borgs, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.torches, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.streams, updateThings);
				FlxG.overlap(_gameLevel.player, _gameLevel.spring, bouncePlayer);
				FlxG.overlap(_gameLevel.player, _gameLevel.spring2, bouncePlayer);
				FlxG.overlap(_gameLevel.player, _gameLevel.checkpoint, hitCheckpoint);
				FlxG.overlap(_gameLevel.player, _gameLevel.end, hitCheckpoint);

				//If the letter is on screen (it should be when first playing level 1 and when hitting the mail in level 4),
				// pressing space should make the letter fade away and the player animate putting the letter away
				if ((Registry.stageCount == 0 || Registry.stageCount == 3) && Registry.letterSequence && FlxG.keys.SPACE)
				{
					_letterTimer = .5;
					_gameLevel.player.putAway();
					Registry.letterSequence = false;
				}

				if (!Registry.musixFlag) //flag needed to prevent music from playing a million times (since this is in update())
				{
					FlxG.playMusic(Registry.musix, 1);
					Registry.musixFlag = true;
				}

				// Bird appears every 30 seconds in the forest levels
				if (Registry.stageCount <3 && Registry.playtime > 1 && Registry.playtime % 30 > 0 && Registry.playtime % 30 < 0.5) add(_gameLevel.bird);

				//reset the bird's position after it goes off screen
				if (_gameLevel.bird.x < -30)
				{
					_gameLevel.bird.x = Registry.screenWidth + 30;
					_gameLevel.bird.y = Registry.screenHeight /2 - 70;
					remove(_gameLevel.bird);
				}

				//playtime
				Registry.playtime += FlxG.elapsed; //keep track of how long user has played the current level
				Registry.totalPlaytime += FlxG.elapsed; //keep track of how long user has played the game
				_playtimeMessage.text = "" + FlxU.formatTime(Registry.playtime, false); //display how long the user has played the current level

				//letterTimer
				if (_letterTimer > 0)
				{
					_letterTimer -= FlxG.elapsed;
					_gameLevel.letter.alpha -= .2;
				}
				else if(_letterTimer < 0)
				{
					_gameLevel.letter.kill();
					remove(_gameLevel.letter);
				}

				//whiff sound effect
				if(Registry.gameLevel.player.canPunch && Registry.hasFlower && FlxG.keys.justPressed("X"))
				{
					FlxG.play(whiffSFX);
				}

				//streamDrag
				if (streamDrag)
				{
					if (_streamLeft) _gameLevel.player.x -= 2; //if water is flowing left, make the player flow left
					else
					{
						if (Registry.stageCount == 6) _gameLevel.player.x += 3; // vice versa
						else _gameLevel.player.x += 2
					}
				}
				if (!FlxG.overlap(_gameLevel.player, _gameLevel.streams)) //if player isn't in water
				{
					if (!((!_streamLeft && FlxG.keys.RIGHT) || (FlxG.keys.LEFT && _streamLeft))) //and they're not carrying momentum from stream, no more streamDrag
					{
						streamDrag = false;
					}
				}
			}
		}

		private function hitBot(player:Player, bot:Bot):void
		{
			if (bot.isDying)
			{
				return;
			}
			else
			{
				if ((player.velocity.y >= 0) && player.y + player.height < bot.y + 12)
				{
					player.bounce(310);
					bot.bounce();
					FlxG.play(_botKillSFX);
				}
				else if (player.isDucking && Math.abs(player.velocity.x) > 50)
				{
					bot.knockback();
					FlxG.play(kickSFX);
				}
				else
				{
					if (player.getInvincible == false && player.y + 30 > bot.y + 10)
					{
						player.ouch(34);
						player.y -= 3;

						if (player.x > bot.x)
						{
							player.x += 15;
							player.facing = FlxObject.LEFT;
						}
						else
						{
							player.x -= 15;
							player.facing = FlxObject.RIGHT;
						}
					}
				}
			}
		}

		private function hitBorg(player:Player, borg:Borg):void
		{
			if (!player.isDying && !borg.isDying)
			{
				borg.chargeBool = false;
				borg.turnAround();
				player.ouch(50);
				if (borg.chargeDirection == "left")
				{
					player.velocity.x = -400;
					player.bounce(200);
					player.knockback = true;
					player.speed = 400;
				}
				else if (borg.chargeDirection == "right")
				{
					player.velocity.x = 400;
					player.bounce(200);
					player.knockback = true;
					player.speed = 400;
				}
			}
		}

		private function hitFire(player:Player, fire:Torch):void
		{
			if (player.getInvincible == false && player.y + 30 > fire.y + 5)
			{
				if (fire.flameOn && !(player.isDucking && fire.y + 24 < player.y + 16))
				{
					player.ouch(50);
					player.y -= 3;

					if (player.x > fire.x)
					{
						player.x += 15;
						player.facing = FlxObject.LEFT;
					}
					else
					{
						player.x -= 15;
						player.facing = FlxObject.RIGHT;
					}
				}
			}
		}

		//turn all the torches on or off
		//this is only way I know how to apply a function to a bunch of things at the same time
		private function flameOn(foreground:FlxTilemap, torch:Torch):void
		{
			if (Registry.torchesOn) torch.flameOn = true;
			else torch.flameOn = false;
		}

		private function hitNomNom(thing:FlxSprite, nomNom:NomNom):void
		{
			if (thing is Bot)
			{
				FlxG.play(nomNomSFX);
				nomNom.spinTimer = .75;
				FlxG.play(_clinkspinSFX, .6, false, true);
				if (Registry.torchesOn)
				{
					Registry.torchesOn = false; //turn torches off
				}
				else if (Registry.torchesOn == false)
				{
					Registry.torchesOn = true; //turn em on
				}
			}
			else if (nomNom.crossedIt)
			{
				FlxG.play(nomNomSFX);
				nomNom.spinTimer = .75;
				FlxG.play(_clinkspinSFX, .6, false, true);
				if (Registry.torchesOn)
				{
					Registry.torchesOn = false; //turn torches off
				}
				else if (Registry.torchesOn == false)
				{
					Registry.torchesOn = true; //turn em on
				}
			}
		}

		private function hitCheckpoint(player:Player, checkpoint:Checkpoint):void
		{
			Registry.checkpointFlag = true;
			if (checkpoint.end)
			{
				if (!_partyPopflag)
				{
					_partyPopflag = true;
					FlxG.play(_partyPop);
				}
				checkpoint.kill();
				_gameLevel.player.walkSFX.stop();
				_gameLevel.player.visible = false;
				this.clear();
				add(_gameLevel.blue);
				_gameLevel.blue.visible = true;
				if(Registry.stageCount > 0) _gameLevel.not_a_flower.visible = false;
				FlxG.music.fadeOut(.4);
				FlxG.flash(0x00CCFF, 3, nextStage);
			}
			else if (!_shakeFlag)
			{
				_shakeFlag = true;
				FlxG.flash(0xFFCCCC, .3);
				checkpoint.kill();
			}
		}

		private function hitReinforcement(player:Player, reinforcement:Reinforcement):void
		{
			reinforcement.kill();
		}

		private function hitBlade(player:Player, blade:Bullet):void
		{
			if (player.y + player.height/2 <= blade.y)
			{
				player.bounce(310);
				FlxG.play(_gong);
				_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16 );
				blade.kill();

			}
			else if ((blade.y > player.y + 16) || !player.isDucking)
			{
				player.ouch(50);
				FlxG.play(_gong);
				_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16 );
				FlxG.play(_gong, .13, false);
				blade.kill();
			}
		}

		private function hitLilguy(player:Player, lilguy:LilGuy):void
		{
			if (!lilguy.isDying)
			{
				FlxG.play(nomNomSFX);
				lilguy.kill();
				Registry.character = "bot";
				Registry.swap = true;
				Registry.swapX = Registry.gameLevel.player.x;
				Registry.swapY = Registry.gameLevel.player.y;
				Registry.swapVelX = Registry.gameLevel.player.velocity.x;
				Registry.swapVelY = Registry.gameLevel.player.velocity.y;
				Registry.gameLevel.player.walkSFX.stop();
				FlxG.resetState();
			}
		}

		private function createHealthBar():void
		{
			healthBar = new FlxHealthBar(_gameLevel.player, 30, 3, 0, 100, true);
			healthBar.createFilledBar(0x00000000, 0x90FF0000, false);
			healthBar.y = 7;
			healthBar.x = Registry.screenWidth -37;
			healthBar.scrollFactor.x = 0;
			healthBar.scrollFactor.y = 0;
			add(healthBar);
		}

		private function createAmountOfDeathsMessage():void
		{
			_amountOfDeathsMessage = new FlxText(Registry.screenWidth - 90, 3, 320, "Level " + (Registry.stageCount + 1) + "\n" + "Deaths: " + Registry.deaths);
			_amountOfDeathsMessage.size = 8;
			_amountOfDeathsMessage.scrollFactor.x = 0;
			_amountOfDeathsMessage.scrollFactor.y = 0;
			add(_amountOfDeathsMessage);
		}

		private function createPlaytimeMessage():void
		{
			_playtimeMessage = new FlxText(Registry.screenWidth - 63, 3, 320, "" + Registry.playtime);
			_playtimeMessage.size = 8;
			_playtimeMessage.scrollFactor.x = 0;
			_playtimeMessage.scrollFactor.y = 0;
			add(_playtimeMessage);
		}
		private function meetNPC(hitBox:FlxObject, npc:NPC):void
		{
			add(_gameLevel.npc.message);
			if(!_gameLevel.npc.meetFlag) _gameLevel.npc.meetTimer = 12;
		}

		private function punchBot(hitBox:FlxObject , bot:Bot):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X") && Registry.hasFlower && !bot.isDying)
			{
				FlxG.play(punchSFX);
				bot.knockback();
			}
		}

		//only here so reference in PlayState doesn't freak out
		private function nothing():void
		{
		}

		private function punchBorg(hitBox:FlxObject , borg:Borg):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X") && !borg.isDying)
			{
				FlxG.play(punchSFX); //this is extra loud for some reason?
				borg.knockback();
				FlxG.shake(.03, .1, nothing, true, 1);
			}
		}

		private function punchRock(hitBox:FlxObject, rock:FlxObject):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X") && Registry.hasFlower)
			{
				FlxG.shake(.02, .1);
				rock.kill();
			}
		}

		private function botRock(bot:Bot, rock:FlxObject):void //when bots fly towards rocks, destroy rocks
		{
			if (bot.velocity.x > 50 || bot.velocity.x < -50)
			{
				if (bot.velocity.x > 50) bot.velocity.x -= 80;
				else if (bot.velocity.x < -50) bot.velocity.x -= -80;
				FlxG.shake(.02, .1);
				rock.kill();

			}
		}

		private function hitMail(player:Player, mail:Mail):void
		{
			add(_gameLevel.letter);
			_gameLevel.player.moves = false;
			FlxG.play(_openletter);
			FlxG.fade(0x000000, .2, viewMail);
			mail.kill();
			Registry.firstLevel4 = false;
		}

		private function viewMail():void
		{
			FlxG.camera.stopFX();
			FlxG.flash(0x00000000, 1.4);
			Registry.letterSequence = true;
			_gameLevel.letter.visible = true;
		}

		private function punchNPC(hitBox:FlxObject, npc:NPC):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X"))
			{
				if (stageCount == 4)
				{
					FlxG.shake(.02, .05);
					FlxG.play(kickSFX, 1);
				}
				add(_gameLevel.npc.message);
				npc.talk();
				add(_gameLevel.umbrella);
			}
		}

		public function crumble(player:Player, crumblerock:CrumbleRock):void
		{
			crumblerock.crumble();
		}

		public function bouncePlayer(player:Player, spring:Spring):void
		{
			if (player.y + player.height < spring.y + 16 && player.velocity.y > 0)
			{
				player.bounce(spring.bounce);
				spring.play("up");
				FlxG.play(_boing);
			}
		}

		public function killBlade(blade:Bullet, foreground:FlxTilemap):void
		{
			if (blade.onScreen()) FlxG.play(_poof, 1, false, true);

			_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16);
			blade.kill();
		}

		public function handleStreams(player:Player, stream:Stream):void
		{
			if (stream.type == "drop") null;
			else
			{
				streamDrag = true;
			}
			if (stream.flowLeft) _streamLeft = true;
			if (!stream.flowLeft && stream.type == "normal") _streamLeft = false;
		}

		public function updateThings(screen:FlxSprite, thing:FlxObject):void //this is supposed to optimze my game. Don't know if actually does.
		{
			var thatBot:Bot2; //in Level 7, there's one bot that shouldn't stop updating once you get past it
			if (thing is Bot2) thatBot = Bot2(thing); //since you can only check if the bot2 should update forever, typecast the thing
			if (thing is Bot2 && thatBot.updateForever) //if it is the updating forever bot, don't do anything
			{
			}
			else
			{
				if (_gameLevel.player.x > thing.x && !thing.onScreen()) thing.active = false; //when player is far enough to right of thing (as happens when user progresses through every level), the thing should stop being active
				else thing.active = true;
			}
		}


		public function gotoMainMenu():void
		{
			FlxG.music.stop();
			Registry.musixFlag = false;
			Registry.gameStart = true;
			FlxG.switchState(new MainMenuState);
		}

		private function mute():void
		{
			if (Registry.pauseSounds)
			{
				_muteButton.frame = 0;
				FlxG.volume = .1;
				Registry.pauseSounds = false;
				FlxG.music.play();
			}
			else
			{
				_muteButton.frame = 2;
				FlxG.pauseSounds();
				FlxG.music.stop();
				Registry.pauseSounds = true;
				FlxG.volume = 0;
			}
		}

		public function makeStage():void
		{
			_gameLevel = new stages[Registry.stageCount];
			Registry.gameLevel = _gameLevel;

			add(_gameLevel);
			add(_gameLevel.backbackground);
			add(_gameLevel.background);
			
			if (Registry.stageCount == 6) 
			{
				add(_gameLevel.smokelets);
				add(_gameLevel.particles);
				if ((int(Registry.playtime)) % 20 == 0 && Registry.playtime != 0) 
				{	
					_gameLevel.bouldlets.setAll("active", true);
					add(_gameLevel.bouldlets);
				}
			}
			
			add(_gameLevel.foreground);
			add(_gameLevel.supports);
			add(_gameLevel.rocks);
			add(_gameLevel.reinforcements);
			add(_gameLevel.fadeBlocks);
			add(_gameLevel.borgs);
			add(_gameLevel.sign);
			add(_gameLevel.sign2);
			add(_gameLevel.bots);
			add(_gameLevel.poofs);

			if(!Registry.hasUmbrella && (Registry.stageCount == 1 || Registry.stageCount == 4)) add(_gameLevel.npc); //if player already has umbrella, don't add the creature

			add(_gameLevel.lilguy);
			add(_gameLevel.bots2);
			add(_gameLevel.poofs);
			add(_gameLevel.worm1);
			add(_gameLevel.worm2);
			add(_gameLevel.worm3);

			if (stageCount == 3 && Registry.firstLevel4) add(_gameLevel.mail); //if playing level 4 for first time, add the mail for player to hit

			add(_gameLevel.torches);
			add(_gameLevel.bots2.blades);
			add(_gameLevel.not_a_flower);
			add(_gameLevel.spring);
			add(_gameLevel.spring2);
			add(_gameLevel.player);
			add(_gameLevel.checkpoint);
			add(_gameLevel.end);
			add(_gameLevel.crumbleRocks);
			add(_gameLevel.nomNoms);
			add(_gameLevel.streams);
			add(_gameLevel.foreforeground);
			add(_muteButton);
			createHealthBar(); //creates and adds player's health bar. Called here because it should appear over top of everything else
			createPlaytimeMessage(); //creates and adds playtime message

			if (Registry.firstLevel1 && Registry.stageCount == 0) //if playing level 1 for first time, make the user read the damn letter //added last so it's over top of everything else
			{
				add(_gameLevel.letter);
				Registry.letterSequence = true;
				_gameLevel.letter.visible = true;
				Registry.firstLevel1 = false;
				_gameLevel.player.moves = false;
			}
			if (Registry.stageCount == 1 && Registry.hasFlower) _gameLevel.npc.exists = false; //if you already have the boxing glove, don't let the thing appear

			if (Registry.pauseSounds) _muteButton.frame = 2; //when sounds are muted, make the audio graphic look muted
			else _muteButton.frame = 0; //otherwise make it look normal

			//select a bot from the bots to be the "chosen one"
			_randBot = Bot(FlxG.getRandom(Registry.gameLevel.bots.alltheBots));
			_randBot.specialOne = true;

			if (Registry.swap) //if you happen to run into the li'l guy, swap the robot out for the girl
			{
				Registry.gameLevel.player.x = Registry.swapX;
				Registry.gameLevel.player.y = Registry.swapY;
				Registry.swap = false;
				FlxG.play(_trumpetSFX);
			}

		}

		//load the next stage
		public function nextStage():void
		{
			Registry.stageCount++;
			Registry.checkpointFlag = false;
			Registry.deathMessageFlag = false;
			//Registry.stageCount = stageCount;
			FlxG.switchState(new LevelCompleteState);
			Registry.musixFlag = false;
			/////////////////////////////////////////////////////////////DON"T LET MUSIC STOP. FIGURE OUT A WAY TO DO SMOOTH TRANSITION
		}
	}
}
