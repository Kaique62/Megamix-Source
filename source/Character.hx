package;

import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = false;
		

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');


			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('dodge','boyfriend dodge', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
		//Garcello
		case 'garcello':
			// GARCELLO ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/garcello_assets', 'shared');
			frames = tex;
			animation.addByPrefix('idle', 'garcello idle dance', 24);
			animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
			animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
			animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
			animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

			addOffset('idle');
			addOffset("singUP", 0, 0);
			addOffset("singRIGHT", 0, 0);
			addOffset("singLEFT", 0, 0);
			addOffset("singDOWN", 0, 0);

			playAnim('idle');												
		case 'garcellotired':
			// GARCELLO TIRED ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/garcellotired_assets', 'shared');
			frames = tex;
			animation.addByPrefix('idle', 'garcellotired idle dance', 24, false);
			animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24, false);
			animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24, false);
			animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24, false);
			animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24, false);

			animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24, false);
			animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24, false);
			animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24, false);
			animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24, false);

			addOffset('idle');
			addOffset("singUP", 0, 0);
			addOffset("singRIGHT", 0, 0);
			addOffset("singLEFT", 0, 0);
			addOffset("singDOWN", 0, 0);
			addOffset("singUP-alt", 0, 0);
			addOffset("singRIGHT-alt", 0, 0);
			addOffset("singLEFT-alt", 0, 0);
			addOffset("singDOWN-alt", 0, 0);

			playAnim('idle');
		case 'garcellodead':
			// GARCELLO DEAD ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/garcellodead_assets', 'shared');
			frames = tex;
			animation.addByPrefix('idle', 'garcello idle dance', 24);
			animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
			animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
			animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
			animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

			animation.addByPrefix('garTightBars', 'garcello coolguy', 15);

			addOffset('idle');
			addOffset("singUP", 0, 0);
			addOffset("singRIGHT", 0, 0);
			addOffset("singLEFT", 0, 0);
			addOffset("singDOWN", 0, 0);
			addOffset("garTightBars", 0, 0);

			playAnim('idle');

		case 'garcelloghosty':
			// GARCELLO DEAD ANIMATION LOADING CODE
			tex = Paths.getSparrowAtlas('characters/garcelloghosty_assets', 'shared');
			frames = tex;
			animation.addByPrefix('idle', 'garcello idle dance', 24);
			animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
			animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
			animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
			animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);

			animation.addByPrefix('garFarewell', 'garcello coolguy', 15);

			addOffset('idle');
			addOffset("singUP", 0, 0);
			addOffset("singRIGHT", 0, 0);
			addOffset("singLEFT", 0, 0);
			addOffset("singDOWN", 0, 0);
			addOffset("garTightBars", 0, 0);

			playAnim('idle');
		//Myra
		case 'myra':
			tex = Paths.getSparrowAtlas('myra/myra_assets');
			frames = tex;

			animation.addByPrefix('idle', "MyraIdle", 24, false);
			animation.addByPrefix('singUP', "MyraUp", 24, false);
			animation.addByPrefix('singRIGHT', 'MyraRight', 24, false);
			animation.addByPrefix('singLEFT', 'MyraLeft', 24, false);
			animation.addByPrefix('singDOWN', "MyraDown", 24, false);

			animation.addByPrefix('singUP-alt', 'MyraAAA', 24, false);
			animation.addByPrefix('singRIGHT-alt', 'MyraRight', 24, false);
			animation.addByPrefix('singLEFT-alt', 'MyraLaugh', 24, false);
			animation.addByPrefix('singDOWN-alt', 'MyraDown', 24, false);

			addOffset('idle');
			addOffset("singUP", 0, 0);
			addOffset("singRIGHT", 0);
			addOffset("singLEFT", 0);
			addOffset("singDOWN", 0, 0);
			addOffset("singUP-alt", 0, 0);
			addOffset("singRIGHT-alt", 0);
			addOffset("singLEFT-alt", 0);
			addOffset("singDOWN-alt", 0, 0);

			playAnim('idle');
	//Sonic.exe
			case 'sonic':

				tex = Paths.getSparrowAtlas('characters/SonicAssets');
				frames = tex;
				animation.addByPrefix('idle', 'SONICmoveIDLE', 24);
				animation.addByPrefix('singUP', 'SONICmoveUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICmoveRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICmoveOWN', 24); //Matheus Pilantra
				animation.addByPrefix('singLEFT', 'SONICmoveLEFT', 24);

				animation.addByPrefix('singDOWN-alt', 'SONIClaugh', 24);
				
				animation.addByPrefix('singLAUGH', 'SONIClaugh', 24);

	
				addOffset('idle');
				addOffset("singUP", 2, 47);
				addOffset("singRIGHT", 13,49);
				addOffset("singLEFT",172, -16);
				addOffset("singDOWN",96, -20);
				addOffset("singLAUGH", 83, -33);

				addOffset("singDOWN-alt", 70, -27);
	
				playAnim('idle');
			case 'sonicfun':

				tex = Paths.getSparrowAtlas('characters/SonicFunAssets');
				frames = tex;
				animation.addByPrefix('idle', 'SONICFUNIDLE', 24);
				animation.addByPrefix('singUP', 'SONICFUNUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICFUNOWN', 24);
				animation.addByPrefix('singLEFT', 'SONICFUNLEFT', 24);
	
				addOffset('idle', -21, 189);
				addOffset("singUP", 22, 126);
				addOffset("singRIGHT", -80, 43);
				addOffset("singLEFT", 393, -60);
				addOffset("singDOWN", 15, -67);
					
	
				playAnim('idle');
			case 'sonicLordX':
				frames = Paths.getSparrowAtlas('characters/SONIC_X');
				animation.addByPrefix('idle', 'sonicX IDLE', 24, false);
				animation.addByPrefix('singUP', 'sonicx UP', 24, false);
				animation.addByPrefix('singDOWN', 'sonicx OWN', 24, false);
				animation.addByPrefix('singLEFT', 'sonicx LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'sonicx RIGHT', 24, false);
					
				addOffset('idle');
				addOffset("singUP", 5, 92);
				addOffset("singRIGHT", 24, -38);
				addOffset("singLEFT",51, -15);
				addOffset("singDOWN", 16, -62);
	
				antialiasing = true;

				playAnim('idle');
			//Monika
			case 'monika':
				frames = Paths.getSparrowAtlas('characters/monika');
				animation.addByPrefix('idle', 'Monika Idle', 24, false);
				animation.addByPrefix('singUP', 'Monika UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Monika LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Monika RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Monika DOWN NOTE', 24, false);

				animation.addByPrefix('idle-alt', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP-alt', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Angry Senpai DOWN NOTE', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Angry Senpai RIGHT NOTE', 24, false);


				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
				case 'duet':
					frames = Paths.getSparrowAtlas('characters/Duet_Assets', 'shared');
					animation.addByPrefix('idle', 'Duet Idle', 24, false);
					animation.addByPrefix('singUP', 'Duet Monika UP NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'Duet Monika LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'Duet Monika RIGHT NOTE', 24, false);
					animation.addByPrefix('singDOWN', 'Duet Monika DOWN NOTE', 24, false);
	
					animation.addByPrefix('singUP-alt', 'Duet Senpai UP NOTE', 24, false);
					animation.addByPrefix('singDOWN-alt', 'Duet Senpai DOWN NOTE', 24, false);
					animation.addByPrefix('singLEFT-alt', 'Duet Senpai LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'Duet Senpai RIGHT NOTE', 24, false);
	
					animation.addByPrefix('cutsceneidle', 'cutscene idle', 24, false);
					animation.addByPrefix('cutscenetransition', 'cutscene transition', 24, false);
	

	
					playAnim('idle');
	
					setGraphicSize(Std.int(width * 6));
					updateHitbox();
	
					antialiasing = false;
	
				case 'monika-angry':
					frames = Paths.getSparrowAtlas('characters/Monika_Finale', 'shared');
					animation.addByPrefix('idle', 'MONIKA IDLE', 24, false);
					animation.addByPrefix('singUP', 'MONIKA UP NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'MONIKA LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'MONIKA RIGHT NOTE', 24, false);
					animation.addByPrefix('singDOWN', 'MONIKA DOWN NOTE', 24, false);
	
					animation.addByPrefix('singUP-alt', 'MONIKA UP GLITCH', 24, false);
					animation.addByPrefix('singLEFT-alt', 'MONIKA LEFT GLITCH', 24, false);
					animation.addByPrefix('singRIGHT-alt', 'MONIKA RIGHT GLITCH', 24, false);
					animation.addByPrefix('singDOWN-alt', 'MONIKA DOWN GLITCH', 24, false);
	

	
					playAnim('idle');
	
					setGraphicSize(Std.int(width * 6));
					updateHitbox();
	
					antialiasing = false;
			case 'playablesenpai':
				frames = Paths.getSparrowAtlas('characters/playablesenpai', 'shared');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'miss Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss Senpai DOWN NOTE', 24, false);

				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "senpai retry", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);

				//I'M TILTED I HAD T OMODIDFY SENPAI'S STUPD PECKIN SPRITE SHEET JUST SO HE DIES WITHOUT CRASHING THE GAME, IF I DIDN'T HAVE LUMATIC ON MY SIDE I WOULD OF LOST IT HOURS AGO SO THANK YOU STUPID CODE FOR NOT WORKING SMILE
				//Lumatic says "Jorge and Senpai have a big forehead tho"


				addOffset('idle', 50, 200);
				addOffset("singUP", 55, 237);
				addOffset("singRIGHT", 50, 200);
				addOffset("singLEFT",90, 200);
				addOffset("singDOWN", 64, 200);
	
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				flipX = true;
	
				playAnim('idle');
	
				antialiasing = false;
				
			case 'bf-pixelangry':
					frames = Paths.getSparrowAtlas('characters/bfPixelangry', 'shared');
					animation.addByPrefix('idle', 'BF IDLE', 24, false);
					animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
					animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
					animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
					animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
					animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
	

	
					setGraphicSize(Std.int(width * 6));
					updateHitbox();
	
					playAnim('idle');
	
					width -= 100;
					height -= 100;
	
					antialiasing = false;
	
					flipX = true;
				case 'nogf-pixel':
					tex = Paths.getSparrowAtlas('characters/nogfPixel', 'shared');
					frames = tex;
					animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
					animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	

	
					playAnim('danceRight');
	
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
	
			case 'gf-doki':
				tex = Paths.getSparrowAtlas('characters/gfdoki', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);



				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
		//Jamey!!!1!1!1	
		case 'jamey1':
			frames = Paths.getSparrowAtlas('jamey/DADDY_DEAREST1');
			animation.addByPrefix('idle', 'BF idle dance', 24, false);
			animation.addByPrefix('singUP', 'BF NOTE UP', 24, false);
			animation.addByPrefix('singLEFT', 'BF NOTE RIGHT', 24, false);
			animation.addByPrefix('singRIGHT', 'BF NOTE LEFT', 24, false);
			animation.addByPrefix('singDOWN', 'BF NOTE DOWN', 24, false);


			addOffset('idle', -5, -80);
			addOffset("singUP", -29, -30);
			addOffset("singLEFT", 12, -53);
			addOffset("singRIGHT", -38, -70);
			addOffset("singDOWN", -10, -110);

			playAnim('idle');

			flipX = true;

			antialiasing = false;
		case 'jamey2': 
			frames = Paths.getSparrowAtlas('jamey/Monster_Assets1');
			animation.addByPrefix('idle', 'BF idle dance', 24, false);
			animation.addByPrefix('singUP', 'BF NOTE UP', 24, false);
			animation.addByPrefix('singLEFT', 'BF NOTE LEFT', 24, false);
			animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT', 24, false);
			animation.addByPrefix('singDOWN', 'BF NOTE DOWN', 24, false);

			animation.addByPrefix('singDOWN-alt', 'BF dies', 24, false);

			addOffset('idle', 0, -80);
			addOffset("singUP", -6, -30);
			addOffset("singRIGHT", 0, -53);
			addOffset("singLEFT", -10, -70);
			addOffset("singDOWN", 0, -110);
			addOffset("singDOWN-alt", 0, -80);
			playAnim('idle');

			flipX = true;

			antialiasing = false;
	//Whitty
			case 'gf-whitty':
				tex = Paths.getSparrowAtlas('GF_Standing_Sway', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('sad', 'Sad', 24, false);
				animation.addByPrefix('danceLeft', 'Idle Left', 24, false);
				animation.addByPrefix('danceRight', 'Idle Right', 24, false);
				animation.addByPrefix('scared', 'Scared', 24, false);

				addOffset('sad', -140, -153);
				addOffset('danceLeft', -140, -153);
				addOffset('danceRight', -140, -153);
				addOffset('scared', -140, -153);

				playAnim('danceRight');
			case 'gf-whitty-zoom':
				tex = Paths.getSparrowAtlas('GF_Standing_ZOOOOOOOOOOOOOOM', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('sad', 'Sad', 24, false);
				animation.addByPrefix('danceLeft', 'Idle Left', 24, false);
				animation.addByPrefix('danceRight', 'Idle Right', 24, false);
				animation.addByPrefix('scared', 'Scared', 24, false);

				addOffset('sad', -140, -153);
				addOffset('danceLeft', -140, -153);
				addOffset('danceRight', -140, -153);
				addOffset('scared', -140, -153);

				playAnim('danceRight');
			case 'whitty': // whitty reg (lofight,overhead)
				tex = Paths.getSparrowAtlas('WhittySprites', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				addOffset('idle', 0,0 );
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);	
			case 'whittycrazy': // whitty crazy (ballistic)
				tex = Paths.getSparrowAtlas('WhittyCrazy', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('idle', 'Whitty idle dance', 24);
				animation.addByPrefix('singUP', 'Whitty Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'whitty sing note right', 24);
				animation.addByPrefix('singDOWN', 'Whitty Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Whitty Sing Note LEFT', 24);

				addOffset('idle', 50);
				addOffset("singUP", 50, 85);
				addOffset("singRIGHT", 100, -75);
				addOffset("singLEFT", 50);
				addOffset("singDOWN", 75, -150);
			case 'wide': // W I D E
				tex = Paths.getSparrowAtlas('wide', 'bonusWeek');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24);
				animation.addByPrefix('singLEFT', 'dad sing note right', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24);
	
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
	
				playAnim('idle');
		//QT
			case 'qt':
				// QT = Cutie
				tex = Paths.getSparrowAtlas('qt', 'qt');
				frames = tex;
				animation.addByPrefix('idle', 'Final_Idle', 18, false); //How long until I get called out for using a weird framerate for the animation?
				animation.addByPrefix('singUP', 'Final_Up', 14, false);
				animation.addByPrefix('singRIGHT', 'Final_Right', 14, false);
				animation.addByPrefix('singDOWN', 'Final_Down', 14, false);
				animation.addByPrefix('singLEFT', 'Final_Left', 14, false);

				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz


				addOffset('idle', 3,-350);
				addOffset("singUP", 11, -305);
				addOffset("singRIGHT", -14, -312);
				addOffset("singDOWN", 24, -275);
				addOffset("singLEFT", -62, -328);
				

				playAnim('idle');
			case 'qt_annoyed':
				//For second song
				tex = Paths.getSparrowAtlas('qt_annoyed', 'qt');
				frames = tex;
				animation.addByPrefix('idle', 'Final_Idle', 18, false);
				animation.addByPrefix('singUP', 'Final_Up', 14, false);
				animation.addByPrefix('singRIGHT', 'Final_Right', 14, false);
				animation.addByPrefix('singDOWN', 'Final_Down', 14, false);
				animation.addByPrefix('singLEFT', 'Final_Left', 14, false);

				//glitch animations
				animation.addByPrefix('singUP-alt', 'glitch_up', 18, false);
				animation.addByPrefix('singDOWN-alt', 'glitch_down', 14, false);
				animation.addByPrefix('singLEFT-alt', 'glitch_left', 14, false);
				animation.addByPrefix('singRIGHT-alt', 'glitch_right', 14, false);


				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz

				addOffset('idle', 3,-350);
				addOffset("singUP", 22, -315);
				addOffset("singRIGHT", -13, -324);
				addOffset("singDOWN", 29, -284);
				addOffset("singLEFT", -62, -333);
				//alt animations
				addOffset("singUP-alt", 18, -308);
				addOffset("singRIGHT-alt", -13, -324);
				addOffset("singDOWN-alt", 29, -284);
				addOffset("singLEFT-alt", 7, -321);
				
				playAnim('idle');
			case 'robot':
				//robot = kb = killerbyte
				tex = Paths.getSparrowAtlas('robot', 'qt');
				frames = tex;

				animation.addByPrefix('danceRight', "KB_DanceRight", 26, false);
				animation.addByPrefix('danceLeft', "KB_DanceLeft", 26, false);
				animation.addByPrefix('singUP', "KB_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB_Right', 24, false);


				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz

				addOffset('danceRight',119,-96);
				addOffset('danceLeft',160,-105);
				addOffset("singLEFT", 268, 37);
				addOffset("singRIGHT", -110, -161);
				addOffset("singDOWN", 184, -182);
				addOffset("singUP", 173, 52);
			//Bluescreen section characters:
			case 'gf_404':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets_404', 'qt');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'bf_404':
				var tex = Paths.getSparrowAtlas('BOYFRIEND_404', 'qt');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				animation.addByPrefix('dodge','boyfriend dodge', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
				
			case 'robot_404':
				tex = Paths.getSparrowAtlas('robot_404', 'qt');
				frames = tex;

				animation.addByPrefix('danceRight', "KB404_DanceRight", 25, false);
				animation.addByPrefix('danceLeft', "KB404_DanceLeft", 25, false);
				animation.addByPrefix('singUP', "KB404_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB404_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB404_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB404_Right', 24, false);

				addOffset('danceRight',119,-96);
				addOffset('danceLeft',160,-105);
				addOffset("singLEFT", 268, 37);
				addOffset("singRIGHT", -110, -161);
				addOffset("singDOWN", 184, -182);
				addOffset("singUP", 173, 52);

			case 'robot_404-TERMINATION':
				tex = Paths.getSparrowAtlas('robot_404-angry', 'qt');
				frames = tex;

				animation.addByPrefix('idle', "KB404ALT_idleBabyRage", 27, false);
				animation.addByPrefix('singUP', "KB404ALT_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB404ALT_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB404ALT_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB404ALT_Right', 24, false);

				addOffset('idle',168,-129);
				addOffset("singLEFT", 268, 37);
				addOffset("singRIGHT", -110, -161);
				addOffset("singDOWN", 184, -182);
				addOffset("singUP", 173, 52);

			case 'qt-kb':

				tex = Paths.getSparrowAtlas('bonus/qt-kbV2', 'qt');
				frames = tex;


				animation.addByPrefix('danceRight', "danceRightNormal", 26, false);
				animation.addByPrefix('danceLeft', "danceLeftNormal", 26, false);

				//kb
				animation.addByPrefix('danceRight-kb', "danceRightKB", 26, false);
				animation.addByPrefix('danceLeft-kb', "danceLeftKB", 26, false);
				animation.addByPrefix('singUP-kb', 'singUpKB', 24, false);
				animation.addByPrefix('singDOWN-kb', 'singDownKB', 24, false);
				animation.addByPrefix('singLEFT-kb', 'singLeftKB', 24, false);
				animation.addByPrefix('singRIGHT-kb', 'singRightKB', 24, false);
				//qt + kb PLACEHOLDER
				animation.addByPrefix('singUP', "singUpTogether", 24, false);
				animation.addByPrefix('singDOWN', "singDownTogether", 24, false);
				animation.addByPrefix('singLEFT', 'singLeftTogether', 24, false);
				animation.addByPrefix('singRIGHT', 'singRightTogether', 24, false);
				//qt
				animation.addByPrefix('singUP-alt', 'singUpQT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'singDownQT', 24, false);
				animation.addByPrefix('singLEFT-alt', 'singLeftQT', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'singRightQT', 24, false);

				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz

				addOffset('danceRight-kb',67,-115);
				addOffset('danceLeft-kb',108,-123);
				addOffset("singUP-kb", 115, 38);
				addOffset("singDOWN-kb", 138, -194);
				addOffset("singLEFT-kb", 214, 23);
				addOffset("singRIGHT-kb", -158, -178);	

				addOffset('danceRight',120,-101);
				addOffset('danceLeft',160,-110);

				addOffset("singUP", 151, 52);
				addOffset("singDOWN", 140, -196);
				addOffset("singLEFT", 213, 21);	
				addOffset("singRIGHT", -163, -172);	
				
				addOffset("singUP-alt", 164, -68);
				addOffset("singDOWN-alt", 99, -168);
				addOffset("singLEFT-alt", 133, -75);
				addOffset("singRIGHT-alt", 16, -135);

			case 'qt-meme':
				// QT = Cutie
				tex = Paths.getSparrowAtlas('qt_meme', 'qt');
				frames = tex;
				animation.addByPrefix('idle', 'godIdle', 24, false);
				animation.addByPrefix('singUP', 'godUp', 24, false);
				animation.addByPrefix('singRIGHT', 'godRight', 24, false);
				animation.addByPrefix('singDOWN', 'godDown', 24, false);
				animation.addByPrefix('singLEFT', 'godLeft', 24, false);

				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz


				addOffset('idle', 0,-177);
				addOffset("singUP", -1, -162);
				addOffset("singRIGHT", 52, -172);
				addOffset("singDOWN", 0, -177);
				addOffset("singLEFT", 64, -171);
				
				playAnim('idle');

			case 'robot_classic':

				tex = Paths.getSparrowAtlas('classic/robot_classic', 'qt');
				frames = tex;

				animation.addByPrefix('danceRight', "KB_DanceRight", 26, false);
				animation.addByPrefix('danceLeft', "KB_DanceLeft", 26, false);
				animation.addByPrefix('singUP', "KB_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB_Right', 24, false);

				addOffset('danceRight',176,-126);
				addOffset('danceLeft',160,-122);
				addOffset("singLEFT", 208, -193);
				addOffset("singRIGHT", 70, -140);
				addOffset("singDOWN", 184, -202);
				addOffset("singUP", 173, -18);

			case 'robot_classic_404':

				tex = Paths.getSparrowAtlas('classic/robot_classic_404', 'qt');
				frames = tex;

				animation.addByPrefix('danceRight', "KB404_DanceRight", 25, false);
				animation.addByPrefix('danceLeft', "KB404_DanceLeft", 25, false);
				animation.addByPrefix('singUP', "KB404_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB404_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB404_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB404_Right', 24, false);

				addOffset('danceRight',119,-96);
				addOffset('danceLeft',160,-105);
				addOffset("singLEFT", 268, 37);
				addOffset("singRIGHT", -110, -161);
				addOffset("singDOWN", 184, -182);
				addOffset("singUP", 173, 52);

			case 'qt_classic':
				tex = Paths.getSparrowAtlas('classic/qt_classic', 'qt');
				frames = tex;
				animation.addByPrefix('idle', 'QT_sprite_test-idle', 48, false);
				animation.addByPrefix('singUP', 'QT_sprite_test-up', 48, false);
				animation.addByPrefix('singRIGHT', 'QT_sprite_test-right', 48, false);
				animation.addByPrefix('singDOWN', 'QT_sprite_test-down', 48, false);
				animation.addByPrefix('singLEFT', 'QT_sprite_test-left', 48, false);

				addOffset('idle', 3,-117);
				addOffset("singUP", 33, -76);
				addOffset("singRIGHT", 0, -141);
				addOffset("singDOWN", 54, -144);
				addOffset("singLEFT", -48, -104);
				
				playAnim('idle');
				
			//bob
			case 'glitched-bob':
				tex = Paths.getSparrowAtlas('bob/ScaryBobAaaaah');
				frames = tex;
				animation.addByPrefix('idle', "idle???-", 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
			case 'bob':
				tex = Paths.getSparrowAtlas('bob/bob_asset');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);

				addOffset('idle');

				flipX = true;

				case 'gloop-bob':
					tex = Paths.getSparrowAtlas('bob/oohscary');
					frames = tex;
					animation.addByPrefix('idle', "bob_idle", 24, false);
					animation.addByPrefix('singUP', 'bob_UP', 24, false);
					animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
					animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
					animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
					animation.addByPrefix('Transform', 'bob_transform', 24, false);
	
					addOffset('idle');
	
					flipX = false;
				
			case 'angrybob':
				tex = Paths.getSparrowAtlas('bob/angrybob_asset');
				frames = tex;
				animation.addByPrefix('idle', "bob_idle", 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_LEFT', 24, false);

				addOffset('idle');

				flipX = true;
			
			case 'hellbob':
				if (FlxG.save.data.happybob)
				{
					tex = Paths.getSparrowAtlas('bob/happy/hellbob_assets');
				}
				else
				{
					tex = Paths.getSparrowAtlas('bob/hellbob_assets');
				}
				frames = tex;
				animation.addByPrefix('idle', "bobismad", 24);
				animation.addByPrefix('singUP', 'lol', 24, false);
				animation.addByPrefix('singDOWN', 'lol', 24, false);
				animation.addByPrefix('singUPmiss', 'lol', 24);
				animation.addByPrefix('singDOWNmiss', 'lol', 24);

				//addOffset('idle', 0, 27);

				playAnim('idle');

				flipX = true;
			case 'ron':
				tex = Paths.getSparrowAtlas('bob/Tankman');
				frames = tex;
				animation.addByPrefix('idle', "Idle", 24);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('cheer', 'Ugh', 24, false);
				addOffset('idle');
				addOffset("singUP", 42, 38);
				addOffset("singLEFT", 98, -27);
				addOffset("singRIGHT", -89, -51);
				addOffset("singDOWN", 40, -120);
				addOffset("Ugh", 71, -40);
			case 'little-man':
					tex = Paths.getSparrowAtlas('Small_Guy');
					frames = tex;
					animation.addByPrefix('idle', "idle", 24);
					animation.addByPrefix('singUP', 'up', 24, false);
					animation.addByPrefix('singDOWN', 'down', 24, false);
					animation.addByPrefix('singLEFT', 'left', 24, false);
					animation.addByPrefix('singRIGHT', 'right', 24, false);
					addOffset('idle');
					addOffset("singUP", -10, 8);
					addOffset("singLEFT", -8, 0);
					addOffset("singRIGHT", 0, 2);
					addOffset("singDOWN", 0, -10);
			case 'pizza':
					tex = Paths.getSparrowAtlas('littleman/PizzaMan');
					frames = tex;
					animation.addByPrefix('idle', "PizzasHere", 29);
					animation.addByPrefix('fall', "PizzasHere", 29);
					animation.addByPrefix('singUP', 'Up', 29, false);
					animation.addByPrefix('singDOWN', 'Down', 29, false);
					animation.addByPrefix('singLEFT', 'Left', 29, false);
					animation.addByPrefix('singRIGHT', 'Right', 29, false);
					addOffset('idle');
			case 'tankman':
					tex = Paths.getSparrowAtlas('tankman/tankmanCaptain');
					frames = tex;
					animation.addByPrefix('idle', "Tankman Idle Dance", 24);
					animation.addByPrefix('oldSingUP', 'Tankman UP note ', 24, false);
					animation.addByPrefix('singUP', 'Tankman UP note ', 24, false);
					animation.addByPrefix('oldSingDOWN', 'Tankman DOWN note ', 24, false);
					animation.addByPrefix('singDOWN', 'Tankman DOWN note ', 24, false);
					animation.addByPrefix('singLEFT', 'Tankman Right Note ', 24, false);
					animation.addByPrefix('singRIGHT', 'Tankman Note Left ', 24, false);

					animation.addByPrefix('ughAnim', 'TANKMAN UGH', 24, false);
					animation.addByPrefix('prettyGoodAnim', 'PRETTY GOOD', 24, false);

					addOffset('idle');
					addOffset("singUP", 24, 56);
					addOffset("oldSingUP", 24, 56);
					addOffset("singRIGHT", -1, -7);
					addOffset("singLEFT", 100, -14);
					addOffset("singDOWN", 98, -90);
					addOffset("oldSingDOWN", 98, -90);
					addOffset("prettyGoodAnim", 45, 20);
					playAnim('idle');
					flipX = true;																																					
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-doki' | 'nogf-pixel' | 'gf-whitty' | 'gf-whitty-zoom':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					case 'robot' | 'robot_404' | 'robot_classic' | 'robot_classic_404':
						danced = !danced;
	
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}