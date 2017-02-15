package
{
	import flash.geom.Point;
	import flash.system.Capabilities;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;

	public class PlayState extends FlxState
	{
		private var _gameLevel:GameLevel;
		private static var stages:Array;
		//private static var stageCount:int = Registry.stageCount; //what stage the user is currently on (0 means Level 1, 1 means Level 2, etc.)
		private var _level1:Class = Level1;
		private var _level2:Class = Level2;
		private var _level3:Class = Level3;
		private var _level4:Class = Level4;
		private var _level5:Class = Level5;	
		private var _level6:Class = Level6;
		private var _level7:Class = Level7;
		private var _finalLevel:Class = FinalLevel;
		private var _levelButton:FlxButton;
		private var _muteButton:FlxButton;
		private var _controlsButton:FlxButton;
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
		private var _jttt:FlxSprite;
		private var _blackScreen:FlxSprite;
		private var bouldletsFLag:Boolean;
		private var endTimer:Number;
		private var endTimerFlag:Boolean;
		private var fadeFlag:Boolean = false;
		private var fadeTimer:Number = 0;
		private var credits:FlxText;
		private var credits2:FlxText;
		private var trumpetFlag:Boolean;
		private var finalPlaytime:Number;
		private var endLevelFlag:Boolean = false;
		private var anyKeyJustPressed:Boolean = false;
		private var mouseTimer:Number = 0.0;

		
		

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
		[Embed(source = "../assets/menu.png")] private var _levelsPNG:Class;
		[Embed(source = "../assets/controlsButton.png")] private var _controlsPNG:Class;
		[Embed(source = "../assets/party_pop.mp3")] private var _partyPop:Class;
		[Embed(source = "../assets/foldpaper(openletter).mp3")] private var _openletter:Class;
		// [Embed(source = "../assets/jttt.png")] private var jtttPNG:Class;
		[Embed(source = "../assets/jttt400x200.png")] private var jtttPNG:Class;

		[Embed(source="../assets/black_screen.png")] private var blackScreenPNG:Class;

		//only here so reference in PlayState doesn't freak out
		public function PlayState()
		{
		}

		override public function create():void
		{
			stages = [_level1, _level2, _level3, _level4, _level5, _level6, _level7];

			FlxG.mouse.load(Registry.cursor, 1, 0, 0);
			// FlxG.mouse.visible = false;
			if(!Registry.pauseSounds) FlxG.volume = .5;

			_levelButton = new FlxButton(2, 1, "Levels", gotoMainMenu);
			_levelButton.loadGraphic(_levelsPNG, false, false, 56, 12);
			_levelButton.label.color = 0x777777;
			_levelButton.scrollFactor.x = 0;
			_levelButton.scrollFactor.y = 0;

			_controlsButton = new FlxButton(Registry.screenWidth - 125, -1, "", tweakControls);
			_controlsButton.loadGraphic(_controlsPNG, false, false, 500, 12);
			_controlsButton.scrollFactor.x = 0;
			_controlsButton.scrollFactor.y = 0;
			_controlsButton.label = new FlxText(250, 0, 300, "ctrls: " + Registry.controlsDescriptor);
			_controlsButton.label.color = 0x777777;
			//multiButton.label.setFormat(null,20,0x333333,"center");

			_muteButton = new FlxButton(Registry.screenWidth - 21, 13, "", mute, true);
			_muteButton.loadGraphic(_mutePNG, true, false, 12, 12);
			_muteButton.scrollFactor.x = 0;
			_muteButton.scrollFactor.y = 0;

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

			Registry.tmpTxt = _gameLevel.letterMsg.text;

		}

		override public function update():void
		{
			super.update();

			//"You can change the path the elephant and rider find themselves traveling on"

			handleMouse();

			//mute mode, music, volumne, silent
			if (Registry.muteMode) FlxG.volume = 0;
			FlxG.log(FlxG.volume);
			handlePause();

			if (!Registry.gameStart)
			{
				
				debugStuff();
				collisions();
				letter();
				bird();
				Registry.playtime += FlxG.elapsed; //keep track of how long user has played the current level
				Registry.totalPlaytime += FlxG.elapsed; //keep track of how long user has played the game
				//_playtimeMessage.text = "" + FlxU.formatTime(Registry.playtime, false); //display how long the user has played the current level

				letterTimer();
				
				//whiff sound effect
				if(Registry.gameLevel.player.canPunch && Registry.hasFlower && FlxG.keys.justPressed("X")) 
				{
					if(Registry.stageCount != 5) FlxG.play(whiffSFX);

				}
				handleStreamDrag();
				
				level7();
				fade(_gameLevel.black); //listen for the black to fade in level 2

				// tweakControls();
				helpfulHints();
				// stars();
				//butt();
			}
		}

		// private function stars():void
		// {
		// 	if(Registry.stageCount == 2)
		// 	{
		// 		// if (_gameLevel.stars.x < -600) _gameLevel.stars.x = 0;
		// 		// if (_gameLevel.stars2.x > 0) _gameLevel.stars2.x = -600;	
		// 	}
		// }

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
					if(Registry.stageCount != 5)FlxG.play(_botKillSFX);
				}
				else if (player.isDucking && Math.abs(player.velocity.x) > 50)
				{
					bot.knockback();
					if(Registry.stageCount != 5) FlxG.play(kickSFX);
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
		
		private function handlePause():void
		{
			if (FlxG.keys.ESCAPE || FlxG.keys.P)
			{
				FlxG.paused = !FlxG.paused;
			}
		}

		private function hitFire(player:Player, fire:Torch):void
		{
			if (player.getInvincible == false && player.y + 30 > fire.y + 5)
			{
				if (fire.flameOn && !(player.isDucking && fire.y + 24 < player.y + 16))
				{
					player.ouch(50, .6);
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

		private function handleMouse():void
		{
			if(!FlxG.keys.any())
			{
				mouseTimer += FlxG.elapsed; //if no keys are pressed for 1.5 seconds, the cursor becomes visible
				if(mouseTimer > 1.5)
				{
					// FlxG.mouse.visible = true;
				}
			}
			else
			{
				mouseTimer = 0; //reset cursor timer each time a key is pressed
				// FlxG.mouse.visible = false;
			}
		}

		private function collisions():void
		{
			//Collisions
				FlxG.collide(_gameLevel.player, _gameLevel.foreground);
				FlxG.collide(_gameLevel.player, _gameLevel.crumbleRocks, crumble);
				FlxG.collide(_gameLevel.player, _gameLevel.fadeBlocks);
				FlxG.collide(_gameLevel.player, _gameLevel.npc);
				FlxG.collide(_gameLevel.bots, _gameLevel.foreground);
				FlxG.collide(_gameLevel.bots, _gameLevel.crumbleRocks);
				FlxG.overlap(_gameLevel.bots, _gameLevel.rocks, botRock);
				FlxG.collide(_gameLevel.bots, _gameLevel.rocks, botRock);
				FlxG.overlap(_gameLevel.bots2, _gameLevel.rocks, botRock);
				FlxG.collide(_gameLevel.bots2, _gameLevel.rocks, botRock);
				FlxG.collide(_gameLevel.bots2, _gameLevel.foreground);
				FlxG.collide(_gameLevel.bots2, _gameLevel.crumbleRocks);
				FlxG.collide(_gameLevel.bots2.blades, _gameLevel.foreground, killBlade);
				FlxG.collide(_gameLevel.bots2.blades, _gameLevel.rocks, killBladeRock);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.foreground);
				FlxG.collide(_gameLevel.borgs, _gameLevel.foreground);
				FlxG.collide(_gameLevel.borgs, _gameLevel.rocks);
				FlxG.collide(_gameLevel.rocks, _gameLevel.player);
				FlxG.collide(_gameLevel.foreground, _gameLevel.rocks);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.rocks);
				FlxG.collide(_gameLevel.lilguy, _gameLevel.crumbleRocks);
				FlxG.collide(_gameLevel.npc, _gameLevel.foreground);
				FlxG.collide(_gameLevel.wiz, _gameLevel.foreground);
				FlxG.collide(_gameLevel.frog, _gameLevel.crumbleRocks);

				//Overlappings
				FlxG.overlap(_gameLevel.player, _gameLevel.reinforcements, hitReinforcement);
				FlxG.overlap(_gameLevel.player, _gameLevel.bots, hitBot);
				FlxG.overlap(_gameLevel.player, _gameLevel.bots2, hitBot);
				FlxG.overlap(_gameLevel.player, _gameLevel.borgs, hitBorg);
				FlxG.overlap(_gameLevel.player, _gameLevel.torches, hitFire);
				FlxG.overlap(_gameLevel.player, _gameLevel.lilguy, hitLilguy);
				FlxG.overlap(_gameLevel.hitBox, _gameLevel.bots, punchBot);
				FlxG.overlap(_gameLevel.hitBox, _gameLevel.bots2, punchBot);
				FlxG.overlap(_gameLevel.hitBox, _gameLevel.borgs, punchBorg);
				FlxG.overlap(_gameLevel.hitBox, _gameLevel.frog, punchFrog);
				FlxG.overlap(_gameLevel.player, _gameLevel.boulder, playerBoulder);

				//reform this
				if(Registry.stageCount == 3 && Registry.firstLevel4) FlxG.overlap(_gameLevel.player, _gameLevel.mail, hitMail);
				if(Registry.stageCount == 2 && Registry.firstLevel3) FlxG.overlap(_gameLevel.player, _gameLevel.mail, hitMail);
				if(Registry.stageCount == 5 && Registry.firstLevel6) FlxG.overlap(_gameLevel.player, _gameLevel.wizHat, hitHat);



				FlxG.overlap(_gameLevel.foreground, _gameLevel.torches, flameOn);
				FlxG.overlap(_gameLevel.player, _gameLevel.nomNoms, hitNomNom);
				FlxG.overlap(_gameLevel.bots, _gameLevel.nomNoms, hitNomNom);

				if (!FlxG.overlap(_gameLevel.player, _gameLevel.nomNoms)) _torchFlag = false; //eliminate torches turning on and off when overlaping switch

				FlxG.overlap(_gameLevel.player, _gameLevel.bots2.blades, hitBlade);
				FlxG.overlap(_gameLevel.bots, _gameLevel.bots2.blades, botHitBlade);		
				FlxG.overlap(_gameLevel.player, _gameLevel.streams, handleStreams);
				FlxG.overlap(_gameLevel.hitBox, _gameLevel.rocks, punchRock);

				if (Registry.stageCount == 4)
				{
					if(Registry.firstLevel5) FlxG.overlap(_gameLevel.hitBox, _gameLevel.npc, punchNPC);
				}
				if (Registry.stageCount == 1) FlxG.overlap(_gameLevel.hitBox, _gameLevel.npc, meetNPC);
								
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.bots, updateThings);
				FlxG.overlap(_gameLevel.player.screen, _gameLevel.bots2, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.rocks, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.crumbleRocks, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.borgs, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.torches, updateThings);
				FlxG.overlap(_gameLevel.player.screen2, _gameLevel.streams, updateThings);
				FlxG.overlap(_gameLevel.player, _gameLevel.spring, bouncePlayer);
				FlxG.overlap(_gameLevel.player, _gameLevel.spring2, bouncePlayer);
				FlxG.overlap(_gameLevel.player, _gameLevel.checkpoint, hitCheckpoint);
				if(Registry.stageCount == 6 && Registry.giftHasBeenExchanged) FlxG.overlap(_gameLevel.player, _gameLevel.checkpoint2, hitCheckpoint);
				FlxG.overlap(_gameLevel.player, _gameLevel.end, hitCheckpoint);

				
		}

		private function tweakControls():void
		{
			if(Registry.controlsDescriptor == "normal")
			{
				Registry.playerNormalAccel = 300;
				Registry.playerTurnAroundAccel = 1000;
				Registry.playerAirAccel = 1000;

				Registry.playerAirDecel = 200;
				Registry.playerNormalDecel = 300;
				// Registry.playerInitialSlideDecel = 70;
				// Registry.playerSlideDecel = 150;

				Registry.controlsDescriptor = "momentous";
				_controlsButton.label.text = "ctrls: " + Registry.controlsDescriptor;
			}
			else if (Registry.controlsDescriptor == "momentous")
			{
				Registry.playerNormalAccel = 1200;
				Registry.playerTurnAroundAccel = 4000;
				Registry.playerAirAccel = 2000;

				Registry.playerAirDecel = 400;
				Registry.playerNormalDecel = 1600;
				// Registry.playerInitialSlideDecel = 70;
				// Registry.playerSlideDecel = 150;

				Registry.controlsDescriptor = "tight";
				_controlsButton.label.text = "ctrls: " + Registry.controlsDescriptor;
			}
			else if (Registry.controlsDescriptor == "tight")
			{
				Registry.playerNormalAccel = 600;
				Registry.playerTurnAroundAccel = 2000;
				Registry.playerAirAccel = 1500;

				Registry.playerAirDecel = 300;
				Registry.playerNormalDecel = 600;
				// Registry.playerInitialSlideDecel = 70;
				// Registry.playerSlideDecel = 150;

				Registry.controlsDescriptor = "normal";
				_controlsButton.label.text = "ctrls: " + Registry.controlsDescriptor;
			}
		}

		private function helpfulHints():void
		{
			// if(Registry.playtime >10 && Registry.playtime < 10.1)
			// {
			// 	add(new FlxText(_gameLevel.player.x, _gameLevel.player.y - 10, 200, "Press 'J' for tight controls"));
			// }
		}

		private function addText():void
		{
			if(Registry.stageCount == 0) 
			{
				l1Text();
			}
			else if (Registry.stageCount == 2) 
			{
				if(FlxG.keys.Z || FlxG.keys.X || FlxG.keys.SPACE || FlxG.keys.ENTER || FlxG.keys.UP || FlxG.keys.DOWN)
				{
					l3Text();
				}
			}
			else if (Registry.stageCount == 3) 
			{
				if(FlxG.keys.Z || FlxG.keys.X || FlxG.keys.SPACE || FlxG.keys.ENTER || FlxG.keys.UP || FlxG.keys.DOWN)
				{
					l4Text();
				}
			}
			else if (Registry.stageCount == 5)
			{
				if(FlxG.keys.Z || FlxG.keys.X || FlxG.keys.SPACE || FlxG.keys.ENTER || FlxG.keys.UP || FlxG.keys.DOWN)
				{
					l6Text();
				}	
			}
		}

		private function l1Text():void
		{
			Registry.textCounter++;
			if(Registry.textCounter == 1)
			{
				Registry.tmpTxt = Registry.tmpTxt + "I don't know where it came from.\n\n";
			}
			else if(Registry.textCounter == 2)
			{
				Registry.tmpTxt = Registry.tmpTxt + "But I know one thing:";
			}
			else if(Registry.textCounter == 3)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\n...You have to see it.\n\n"
			}
			else if(Registry.textCounter == 4)
			{
				Registry.tmpTxt = Registry.tmpTxt + "P.S.\n"
									  			  + "Press 'ZX'"; 					
			}
			_gameLevel.letterMsg.text = Registry.tmpTxt;	
		}

		private function l3Text():void
		{
			Registry.textCounter++;
			//FlxG.log("l3Text textCount == " + Registry.textCounter);

			if (Registry.textCounter == 1)
			{
				Registry.tmpTxt = Registry.tmpTxt + " I forgot to mention something."; 					
			}	
			else if (Registry.textCounter == 2)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\nThis..."; 					
			}
			else if (Registry.textCounter == 3)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\n...thing."; 					
			}
			else if (Registry.textCounter == 4)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\nI don't know how you will react to it."; 					
			}
			else if (Registry.textCounter == 5)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\nJust..."; 					
			}
			else if (Registry.textCounter == 6)
			{
				Registry.tmpTxt = Registry.tmpTxt + "...hurry."; 					
			}
			else if (Registry.textCounter == 7)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\n\n Press 'ZX'"; 					
			}
			_gameLevel.letterMsg.text = Registry.tmpTxt;	
		}

		private function l4Text():void
		{
			Registry.textCounter++;
			//FlxG.log("l3Text textCount == " + Registry.textCounter);

			if (Registry.textCounter == 1)
			{
				Registry.tmpTxt = Registry.tmpTxt + "What"; 					
			}	
			else if (Registry.textCounter == 2)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\nthe"; 					
			}
			else if (Registry.textCounter == 3)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\nf";				
			}
			else if (Registry.textCounter == 4)
			{
				Registry.tmpTxt = Registry.tmpTxt + "u";					
			}
			else if (Registry.textCounter == 5)
			{
				Registry.tmpTxt = Registry.tmpTxt + "c"; 					
			}
			else if (Registry.textCounter == 6)
			{
				Registry.tmpTxt = "\n\nFOCUS."; 					
			}
			else if (Registry.textCounter == 7)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\n\nYOU'RE ALMOST HERE"; 					
			}
			else if (Registry.textCounter == 8)
			{
				Registry.tmpTxt = Registry.tmpTxt + "\n\n Press 'ZX'";
			}
			_gameLevel.letterMsg.text = Registry.tmpTxt;	
		}

		private function l6Text():void
		{
			// Registry.textCounter++;
			// if(Registry.textCounter == 1)
			// {
			// 	Registry.tmpTxt = "Press 'ZX'";
			// }
			
			_gameLevel.letterMsg.text = "Press 'ZX'";	
		}

		private function letter():void
		{
			//If the letter is on screen (it should be when first playing level 1 and when hitting the mail in level 4),
				// pressing z and x should make the letter fade away and the player animate putting the letter away
				//if(Registry.letterSequence && FlxG.keys.justPressed("z"))
				//{
				//	addText(Registry.tmpTxt);

				//}

				if (FlxG.keys.any() && !anyKeyJustPressed)
				{
					anyKeyJustPressed = true;

					// Do the stuff you want when any key is just pressed.
					addText();

				}
				else if (!FlxG.keys.any())
				{
					anyKeyJustPressed = false;
				}

				if (Registry.stageCount == 0 && Registry.letterSequence && FlxG.keys.any()) //teach them to use Z and X in level one
				{
					//_gameLevel.letterMsg.text =
					//Registry.tmpTxt = _gameLevel.letterMsg.text;
					
					
					if(FlxG.keys.Z && FlxG.keys.X)
					{
						_letterTimer = .5;
						_gameLevel.player.putAway();
						// _gameLevel.letterMsg.visible = false;
						Registry.letterSequence = false;
						Registry.gameLevel.player.moves = true;
					}
				}
				else if ((Registry.stageCount == 2 || Registry.stageCount == 3 || Registry.stageCount == 5) && Registry.letterSequence && (FlxG.keys.X && FlxG.keys.Z)) //after level one, any key will put the letter away
				{
					if(Registry.stageCount != 5) _letterTimer = .5;
					_gameLevel.player.putAway();
					Registry.letterSequence = false;
					Registry.gameLevel.player.moves = true;
				}
		}

		private function debugStuff():void
		{
			if (FlxG.keys.T)
				{
					FlxG.log("		***TEST***");
					
					//Player Position//
					/*trace(Registry.gameLevel.player.x, Registry.gameLevel.player.y);
					trace("Playtime: " + Registry.playtime
						+ "\nTotalPlaytime: " + Registry.totalPlaytime);*/
					FlxG.log("screenResX: " + Capabilities.screenResolutionX + "\n screenResY: " + Capabilities.screenResolutionY);
					
				}
		}

		private function bird():void
		{
				// Bird appears every 30 seconds in the forest levels
				if (Registry.stageCount < 3 && Registry.playtime > 1 && Registry.playtime % 30 > 0 
				&& Registry.playtime % 30 < 0.5) 
				{
					if(!(Registry.stageCount == 0 && Registry.gameLevel.letterMsg.visible)) add(_gameLevel.bird);
				}

				//reset the bird's position after it goes off screen
				if (_gameLevel.bird.x < -30)
				{
					_gameLevel.bird.x = Registry.screenWidth + 30;
					_gameLevel.bird.y = Registry.screenHeight /2 - 70;
					remove(_gameLevel.bird);
				}
		}

		private function letterTimer():void
		{
			if (_letterTimer > 0)
			{
				_letterTimer -= FlxG.elapsed;
				_gameLevel.letterMsg.alpha -= .2;
			}
			else if(_letterTimer < 0)
			{
				_gameLevel.letterMsg.kill();
				remove(_gameLevel.letterMsg);
			}
		}

		private function handleStreamDrag():void
		{
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

		private function butt():void
		{
			if(Registry.totalPlaytime > 5 && !Registry.buttAppeared)
			{
				//FlxG.log("buttTime!");
				add(_gameLevel.butt);
			}

		}

		// private function level2():void
		// {
		// 	if(Registry.hasFlower)
		// 	{
		// 		FlxG.playMusic(Registry.l2msc);
		// 	}
		// }

		private function level7():void
		{
			if (Registry.stageCount == 6) 
				{
			
					if (Registry.dropBouldlets) 
					{	
						add(_gameLevel.bouldlets);
						Registry.dropBouldlets = false;
					}
					if (Registry.gameLevel.wiz.smushFlag)
					{
						if(_gameLevel.player.x > _gameLevel.wiz.BEHINDGIFT - 300){
							_gameLevel.boulder.x = _gameLevel.wiz.BEHINDGIFT - 110;
							add(_gameLevel.boulder);
							Registry.gameLevel.wiz.smushFlag = false;
							_gameLevel.wiz.smushTimer = .4;
						}
					}

					if (Registry.theEnd) theEnd();
					
					//////////////////////
					//     Wiz cutscene //     		
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//		NOTE:I know there must be a much easier/more efficient way of handling cutscenes, 
					//	    	 but this is how I do it:
					//		-create a cutscene boolean in Registry. The cutscene can be triggered in any class that has access to Registry (which is every class I'm aware of)
					//		-because PlayState(this class) handles animations and generally everything that happens on stage, what happens in the cutscene happens here
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					//MEETING WIZ
					//if (!Registry.giftExchange) //giftExchange is turned on when Wiz is onScreen behind the big gift (gExch turned on in Wiz)
					//{
					if (!Registry.metWiz)
					{
						
						meetWiz();
					}
					//}
					
					//GIFT EXCHANGE
					if (Registry.giftExchange) //gift exchange cutscene happens after you greet the wiz (flagged in Wiz)
					{
						giftExchange();
						
					}
					add(_gameLevel.wiz.message); //the game is constantly refreshing wiz's message because the message updates in real time
				
				}
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
			checkpoint.kill();
			
			if (checkpoint.second) Registry.checkpointFlag2 = true;
			else Registry.checkpointFlag = true;
			
			if (checkpoint.end)
			{
				endLevel();
			}
			
		}

		private function hitReinforcement(player:Player, reinforcement:Reinforcement):void
		{
			reinforcement.kill();
			Registry.ballsCollected++;
			
			if (Registry.ballsCollected % 50 == 0 && Registry.ballsCollected > 0)
			{
				if (!trumpetFlag)
				{
					if(Registry.stageCount != 5) FlxG.play(_trumpetSFX);
					trumpetFlag = true;
				}
				add(new FlxText(_gameLevel.player.x, _gameLevel.player.y - 10, 200, Registry.ballsCollected + "th ball of pointlessness."));
			}
			//if (Registry.stageCount == 0 && player.x > 600) _gameLevel.pointsMessage.kill();
		}

		private function hitBlade(player:Player, blade:Bullet):void
		{
			if (player.y + player.height/2 <= blade.y)
			{
				player.bounce(310);
				if(Registry.stageCount != 5)FlxG.play(_gong);
				_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16 );
				blade.kill();

			}
			else if ((blade.y > player.y + 16) || !player.isDucking)
			{
				player.ouch(50);
				if(Registry.stageCount != 5)FlxG.play(_gong);
				_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16 );
				if(Registry.stageCount != 5)FlxG.play(_gong, .13, false);
				blade.kill();
			}
		}

		private function botHitBlade(bot:Bot, blade:Bullet):void
		{
			if(Registry.stageCount != 5)FlxG.play(_gong);
				_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16 );
				FlxG.play(_gong, .13, false);
				blade.kill();
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

		private function endLevel():void
		{
			
			if (!endLevelFlag) 
			{
				if (!_partyPopflag)
				{
					_partyPopflag = true;
					// if(Registry.stageCount != 5)
					FlxG.play(_partyPop);
				}
				_gameLevel.player.walkSFX.stop();
				_gameLevel.player.visible = false;
				this.clear();
				add(_gameLevel.blue);//??
				_gameLevel.blue.visible = true;//??
				if(Registry.stageCount > 0) _gameLevel.not_a_flower.visible = false; //??
				//FlxG.music.fadeOut(.4);
				
				//play next levels music
				if (Registry.stageCount == 0) 
				{
					//FlxG.playMusic(Registry.l2msc, .5);
					//FlxG.playMusic(Registry.water, 1);

				}
				/*if (Registry.stageCount == 1) FlxG.playMusic(Registry.l3msc, 1);
				if (Registry.stageCount == 2) FlxG.playMusic(Registry.l4msc, 1);
				if (Registry.stageCount == 3) FlxG.playMusic(Registry.l5msc, 1);
				if (Registry.stageCount == 4) FlxG.playMusic(Registry.l6msc, 1);*/
				if (Registry.stageCount == 5) FlxG.playMusic(Registry.l7msc, 1);
				endLevelFlag = true;
			}	
			
			FlxG.flash(0x00CCFF, 2, nextStage);
		}
		private function meetNPC(hitBox:FlxObject, npc:NPC):void
		{
			add(_gameLevel.npc.message);
			if(!_gameLevel.npc.meetFlag) 
			{
				_gameLevel.npc.meetTimer = 14;
				startFade(_gameLevel.black, 6);
				if(Registry.stageCount == 1) FlxG.playMusic(Registry.l2msc, .5);
			}
		}

		private function startFade(object:FlxSprite, fadeTime:Number):void
		{
			if(fadeFlag == false)
			{
				fadeFlag = true
				fadeTimer = fadeTime;
			}
		}

		private function fade(object:FlxSprite):void
		{
			
			if(fadeFlag)
			{
				fadeTimer -= FlxG.elapsed;
				object.alpha -= .003;
				if (fadeTimer < 0)
				{
					fadeFlag = false;
					// FlxG.log("faded");
				}
			}
		}

		private function punchBot(hitBox:FlxObject , bot:Bot):void
		{
			
			if (!bot.isBot2() && Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X") && Registry.hasFlower && !bot.isDying)
			{
				if(Registry.stageCount != 5) FlxG.play(punchSFX);
				bot.knockback();
			}
			else if (bot.isBot2() && FlxG.keys.justPressed("X"))
			{
				bot.dodge();
			}

		}
		
		private function punchFrog(hitBox:FlxObject, frog:Frog):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X") && Registry.hasFlower)
			{
				if(Registry.stageCount != 5)FlxG.play(punchSFX);
				frog.knockBack();
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
				if(Registry.stageCount != 5)FlxG.play(punchSFX); //this is extra loud for some reason?
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
			//FlxG.log("hit Mail");
			// add(_gameLevel.letterMsg);
			player.velocity.x = 0;

			//_gameLevel.player.moves = false;
			FlxG.play(_openletter);
			viewMail();
			//FlxG.fade(0x000000, .2, viewMail);
			mail.kill();
			if(Registry.stageCount == 2)
			{
				Registry.firstLevel3 = false;
				FlxG.playMusic(Registry.l3msc, 1);
			}
			if(Registry.stageCount == 3)
			{
				Registry.firstLevel4 = false;
				FlxG.playMusic(Registry.l4msc, 1);
			}
			// if(Registry.stageCount == 5)
			// {
			// 	Registry.firstLevel6 = false;
			// 	FlxG.playMusic(Registry.l6msc, 1);
			// }
		}

		private function hitHat(player:Player, hat:FlxSprite):void
		{
			//FlxG.log("hit Mail");
			// add(_gameLevel.letterMsg);
			player.velocity.x = 0;

			//_gameLevel.player.moves = false;
			// FlxG.play(_openletter);
			viewMail();
			//FlxG.fade(0x000000, .2, viewMail);
			hat.kill();
			
			if(Registry.stageCount == 5)
			{
				Registry.firstLevel6 = false;
				FlxG.playMusic(Registry.l6msc, 1);
			}
		}

		private function viewMail():void
		{
			FlxG.camera.stopFX();
			add(_gameLevel.letterMsg);
			_gameLevel.letterMsg.visible = true;
			//FlxG.flash(0x00000000, 1.4);
			_gameLevel.player.canPunch = false;

			Registry.letterSequence = true;
			Registry.gameLevel.player.moves = false;
			Registry.gameLevel.player.velocity.x = 0;
			
			if(Registry.stageCount == 5) Registry.gameLevel.player.play("hatIdle");
			else 
			{
				Registry.gameLevel.player.play("letterIdle");
			}
		}

		private function viewHat():void
		{
			FlxG.camera.stopFX();
			//FlxG.flash(0x00000000, 1.4);
			Registry.letterSequence = true;
			//_gameLevel.letterMsg.visible = true;
			Registry.gameLevel.player.moves = false;
			Registry.gameLevel.player.velocity.x = 0;
			Registry.gameLevel.player.play("hatIdle");
		}

		private function punchNPC(hitBox:FlxObject, npc:NPC):void
		{
			if (Registry.gameLevel.player.canPunch && FlxG.keys.justPressed("X"))
			{
				FlxG.shake(.02, .05);
				if(Registry.stageCount != 5)FlxG.play(kickSFX, 1);
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
				if(Registry.stageCount != 5) FlxG.play(_boing);
			}
		}

		public function killBlade(blade:Bullet, foreground:FlxTilemap):void
		{
			if (blade.onScreen()) 
			{
				if(Registry.stageCount != 5)	FlxG.play(_poof, 1, false, true);
			}

			_gameLevel.poofs.addPoof(blade.x - blade.width, blade.y - 16);
			blade.kill();
		}

		public function killBladeRock(blade:Bullet, rock:Rock):void //this is a shameless copy of the above function. I probably could have tweaked the above function to take a generic GameObject or something and work for both foreground objects and rock objects, but this was quick and easy and I just want to be done...
		{
			if (blade.onScreen()) 
			{
				if(Registry.stageCount != 5)	FlxG.play(_poof, 1, false, true);
			}

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
				if (_gameLevel.player.x > (thing.x + 500)) thing.active = false; //when player is far enough to right of thing (as happens when user progresses through every level), the thing should stop being active
				else thing.active = true;
			}
		}


		public function gotoMainMenu():void
		{
			Registry.musixFlag = false;
			Registry.gameStart = true;
			FlxG.switchState(new LevelMenuState);
		}

		private function mute():void
		{
			if (Registry.pauseSounds)
			{
				_muteButton.frame = 0;
				FlxG.volume = Registry.volume;
				Registry.pauseSounds = false;
				FlxG.music.play();
			}
			else
			{
				_muteButton.frame = 2;
				FlxG.pauseSounds();
				FlxG.music.stop();
				Registry.pauseSounds = true;
				Registry.volume = FlxG.volume;
				FlxG.volume = 0;
			}
		}
		
		public function playerBoulder(player:Player, boulder:Boulder):void
		{
			player.x -= 5;
		}
		
		public function theEnd():void
		{
			if (!endTimerFlag) 
			{ 
				_blackScreen = new FlxSprite(0, 0);
				_blackScreen.loadGraphic(blackScreenPNG,false, false, 1200, 600);
				_blackScreen.scrollFactor.x = 0;
				_blackScreen.scrollFactor.y = 0;
				_blackScreen.moves = false;
				_blackScreen.alpha = 0;
				add(_blackScreen);
				
				credits = new FlxText(0, Registry.screenHeight / 8, Registry.screenWidth);
				credits.size = 16;
				credits.centerOffsets();
				credits.scrollFactor.x = 0;
				credits.scrollFactor.y = 0;
				credits.alpha = 0;
				credits.alignment = "center";
				credits.height = Registry.screenHeight;
				add(credits);
				
				credits2 = new FlxText(0, Registry.screenHeight / 8, Registry.screenWidth);
				credits2.size = 16;
				credits2.centerOffsets();
				credits2.scrollFactor.x = 0;
				credits2.scrollFactor.y = 0;
				credits2.alpha = 0;
				credits2.alignment = "center";
				credits2.height = Registry.screenHeight;
				add(credits2);
				
				_jttt = new FlxSprite(Registry.screenWidth/15 - 25, Registry.screenHeight/20);
				_jttt.loadGraphic(jtttPNG,false, false, 517, 174);
				_jttt.scrollFactor.x = 0;
				_jttt.scrollFactor.y = 0;
				_jttt.moves = false;
				_jttt.alpha = 0;
				add(_jttt);
				// FlxG.log("playingmusic");
				
				
				
				endTimer = 82; 
				endTimerFlag = true;
			}
			if (endTimer > 0) 
			{
				endTimer -= FlxG.elapsed;
			}
			
			if (endTimer < 75 && endTimer > 70) 
			{
				if(endTimer > 74.85) FlxG.playMusic(Registry.endMsc, .5);
				_jttt.alpha += .01;
				finalPlaytime = Registry.totalPlaytime;

			}
			if (endTimer < 72 && endTimer > 66)
			{
				credits.text = "\n\n\n\n\nby Ethan Fischer";
				credits.alpha += .01;
			}
			if (endTimer < 66 && endTimer > 65)
			{
				_jttt.alpha -= .05;
				// credits.text = "\n\n\n\n\nby Ethan Fischer";
				credits.alpha -= .05;
			}
			if (endTimer < 65 && endTimer > 55)
			{
				// credits.alpha -= .05;
				credits2.size = 8;
				credits2.alpha += .01;
				credits2.text = "Music:"
				+"\n1. Time -- Komiku"
				+"\n2. Playhouse -- Buddy Rich Big Band"
				+"\n3. We Insist -- Zoe Keating"
				+"\n4. Mind on the Fritz -- Prof.Logik"
				+"\n5. A Wonderful Guy - Oscar Peterson Trio"
				+"\n6. The Holiday -- So I'm An Islander"
				+"\n7. Epic Piece -- Ethan Berg"
				+"\n8. The End -- Ethan Fischer";
			}
			if (endTimer < 55 && endTimer > 52)
			{
				credits2.alpha -= .1;
				credits.size = 8;
				credits.text = "Thank you to everyone who helped me make this better.";
				credits.alpha += .05;
			}
			if (endTimer < 52 && endTimer > 45)
			{
				credits.alpha -= .1;
				credits2.text = "Thanks for playing";
				credits2.alpha += .05;
				_blackScreen.alpha += .01;
			}
		
			if (endTimer < 45 && endTimer > 42)
			{
				credits2.alpha -= .1;
			}
			if (endTimer < 42 && endTimer > 40)
			{
				credits.y = 120;
				credits.text = "Total Playtime";
				credits.alpha += .01;	
			}
			if (endTimer < 40 && endTimer > 36)
			{
				credits2.y = 140;
				credits2.text = FlxU.formatTime(finalPlaytime, false);
				credits.alpha += .01;
				credits2.alpha += .01;
			}
			if (endTimer < 36)
			{
				credits.alpha -= .001;
				credits2.alpha -= .001;

			}
		}
		
		private function youBeatTheGame():void
		{
			// FlxG.volume = .1;
			Registry.pauseSounds = false;
			//FlxG.switchState(new MainMenuState);
		}
		
		public function makeStage():void
		{
			_gameLevel = new stages[Registry.stageCount];
			Registry.gameLevel = _gameLevel;

			add(_gameLevel);
			add(_gameLevel.backbackground);
			add(_gameLevel.background);

			if(Registry.stageCount == 1 || Registry.stageCount == 4)
			{
				add(_gameLevel.sparkle);
				add(_gameLevel.sparkle2);
				add(_gameLevel.sparkle3);
				add(_gameLevel.sparkle4);
				add(_gameLevel.sparkle5);
				add(_gameLevel.sparkle6);
				add(_gameLevel.sparkle7);
				add(_gameLevel.sparkle8);
				add(_gameLevel.sparkle9);
				add(_gameLevel.sparkle10);
				add(_gameLevel.sparkle11);
				add(_gameLevel.sparkle12);
				add(_gameLevel.sparkle13);
				add(_gameLevel.sparkle14);
				add(_gameLevel.sparkle15);
				add(_gameLevel.sparkle16);
				add(_gameLevel.sparkle17);
				add(_gameLevel.sparkle18);
				// add(_gameLevel.sparkle);				
			}

			if (Registry.firstTimePlayingLevel)
			{
				Registry.firstTimePlayingLevel = false;
				_gameLevel._levelNumber.text = new int(Registry.stageCount + 1).toString();
				add(_gameLevel._levelNumber);
				_gameLevel._levelNumber.velocity.x = 350;
			}

			
			
			if (Registry.stageCount == 6) 
			{
				Registry.playerInitialSlideDecel = 40;
				Registry.playerSlideDecel = 140;
				add(_gameLevel.smokelets);
				add(_gameLevel.particles);
				add(_gameLevel.focusPoint);
			}
			else
			{
				Registry.playerInitialSlideDecel = 80;
				Registry.playerSlideDecel = 280;				
			}

			add(_gameLevel.foreground);
			if (Registry.stageCount == 6) add(_gameLevel.thingamajig);
			add(_gameLevel.wiz);
			add(_gameLevel.supports);
			add(_gameLevel.rocks);
			add(_gameLevel.reinforcements);
			add(_gameLevel.fadeBlocks);
			add(_gameLevel.borgs);
			add(_gameLevel.sign);
			add(_gameLevel.sign2);
			add(_gameLevel.bots);
			add(_gameLevel.poofs);
			add(_gameLevel.hitBox);
			if (Registry.stageCount == 0 && Registry.firstLevel1) add(_gameLevel.pointsMessage);

			if(!Registry.hasUmbrella)
			{
				if(Registry.stageCount == 1 || Registry.stageCount == 4) 
				{
					add(_gameLevel.npc); //if player already has umbrella, don't add the creature
				}
			}

			add(_gameLevel.lilguy);
			add(_gameLevel.bots2);
			add(_gameLevel.poofs);
			add(_gameLevel.worm1);
			add(_gameLevel.worm2);
			add(_gameLevel.worm3);

			// FlxG.log("stagecount = " && Registry.stageCount);
			if (Registry.stageCount == 2) 
			{
				if(Registry.firstLevel3)
				{
					add(_gameLevel.mail); //if playing level 4 for first time, add the mail for player to hit
				}			
				add(_gameLevel.stars);
				_gameLevel.stars.addStars();
			}
			
			if(Registry.stageCount == 3 && Registry.firstLevel4) add(_gameLevel.mail); //if playing level 4 for first time, add the mail for player to hit
			
			if(Registry.stageCount == 5 && Registry.firstLevel6)
			{
				add(_gameLevel.wizHat);
				// FlxG.log(_gameLevel.wizHat.x);
			}

			add(_gameLevel.torches);
			add(_gameLevel.bots2.blades);
			add(_gameLevel.not_a_flower);
			add(_gameLevel.spring);
			add(_gameLevel.spring2);
			add(_gameLevel.player);

			if (Registry.deaths % 24== 0 && Registry.deaths != 0)
			{
				add(_gameLevel.frog); //only add frog every 7 deaths or so
				add(_gameLevel.frog.message);
			}
			
			add(_gameLevel.checkpoint);
			add(_gameLevel.end);
			add(_gameLevel.crumbleRocks);
			add(_gameLevel.nomNoms);
			add(_gameLevel.streams);
			
			if(Registry.stageCount == 6)add(_gameLevel.wiz.smokelets);
			add(_gameLevel.foreforeground);
			add(_muteButton);
			add(_levelButton);
			add(_controlsButton);
			
			createHealthBar(); //creates and adds player's health bar. Called here because it should appear over top of everything else
			//createPlaytimeMessage(); //creates and adds playtime message

			if (Registry.firstLevel1 && Registry.stageCount == 0) //if playing level 1 for first time, make the user read the damn letter //added last so it's over top of everything else
			{
				add(_gameLevel.letterMsg);
				Registry.letterSequence = true;
				_gameLevel.letterMsg.visible = true;
				Registry.firstLevel1 = false;
				_gameLevel.player.moves = false;
			}
			
			/*if (Registry.firstLevel3 && Registry.stageCount == 2) //if playing level 3 for first time, make the user read the damn letter //added last so it's over top of everything else
			{
				add(_gameLevel.letterMsg);
				Registry.letterSequence = true;
				_gameLevel.letterMsg.visible = true;
				Registry.firstLevel3 = false;
				_gameLevel.player.moves = false;
			}*/
			if (Registry.stageCount == 1) 
			{
				if(Registry.hasFlower) _gameLevel.npc.exists = false; //if you already have the boxing glove, don't let the thing appear
				else add(_gameLevel.black);
			}
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
			// trace("nextstage()");
			Registry.stageCount++;
			Registry.checkpointFlag = false;
			Registry.textCounter = 0;
			Registry.deathMessageFlag = false;
			Registry.firstTimePlayingLevel = true;
			
			//Registry.musixFlag = true;
			FlxG.flash(0x000000, 1);
			Registry.chkptsUsed = 0;
			FlxG.switchState(new PlayState);
			//Registry.musixFlag = false;
			/////////////////////////////////////////////////////////////DON"T LET MUSIC STOP. FIGURE OUT A WAY TO DO SMOOTH TRANSITION
		}
		
		//////////////////////////////////////////////////////////////
		//						CUTSCENES							//
		//////////////////////////////////////////////////////////////
		public function meetWiz():void
		{
			
			if (!Registry.metWiz) //once player is free, set this to true
			{
			
				if (_gameLevel.player.x > _gameLevel.focusPoint.x) 
				{
			
					FlxG.camera.follow(_gameLevel.focusPoint); //have the camera pan over to the right to reveal the wizard
					
					_gameLevel.focusPoint.velocity.x = 600; //the speed of the panning
					if (Registry.wizUnfreeze == false) 
					{
						streamDrag = false;
						FlxControl.player1.setCursorControl(false, false, false, false);
						//_gameLevel.player.moves = false; //freeze the player
						_gameLevel.player.velocity.x = 0;
					}
					//once wiz is on screen, he will go through his shenanagins, then you will unfreeze 
				}
				else if (_gameLevel.focusPoint.x >= _gameLevel.focusDestination.x)
				{
					if (Registry.wizUnfreeze == true)
					{
						//_gameLevel.player.moves = true; //unfreeze the player, allowing player to move to next cutscene (giftExchange)
						FlxControl.player1.setCursorControl(false, false, true, true);
						if (_gameLevel.player.x > _gameLevel.focusDestination.x)
						{
							FlxG.camera.follow(_gameLevel.player, FlxCamera.STYLE_PLATFORMER); //The camera will follow the player
							_gameLevel.focusPoint.velocity.x = 0; //make sure focus point isn't moving (yet)
							_gameLevel.focusPoint.x = _gameLevel.wiz.BEHINDGIFT - (Registry.screenWidth * 0.6); //set up fPoint for giftExchange()
							_gameLevel.focusDestination.x = _gameLevel.wiz.BEHINDGIFT;
							
							//exit meetWiz() and never come back
							Registry.metWiz = true; //once player.moves is set to true and camera is following player, metWiz is set to true
							return;
						}
					}
					_gameLevel.focusPoint.velocity.x = 0; //focus point.x is consequently set to focusDestination.x when it passes focusDestination
					
				} 
			}
			
		}
		
		public function giftExchange():void
		{
			if (_gameLevel.player.x > _gameLevel.focusPoint.x) 
			{
				FlxG.camera.follow(_gameLevel.focusPoint); //have the camera pan over to the right to reveal the thingamajig and wiz
				
				_gameLevel.focusPoint.velocity.x = 600; //the speed of the panning
				if (Registry.wizUnfreeze2 == false) 
				{
					//_gameLevel.player.moves = false; //freeze the player 
					FlxControl.player1.setCursorControl(false, false, false, false);
					_gameLevel.player.velocity.x = 0;
				}
				//once wiz is on screen, he will go through his shenanagins, then you will unfreeze 
			}
			else if (_gameLevel.focusPoint.x >= _gameLevel.focusDestination.x) //stop camera when fPoint > fDest
			{
				_gameLevel.focusPoint.velocity.x = 0; //focus point.x is consequently set to focusDestination.x when it passes focusDestination
			} 
		}
		
	}
}
