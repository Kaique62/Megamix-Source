package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import ui.Mobilecontrols;
import flixel.addons.display.FlxBackdrop;
import ui.FlxVirtualPad;

import openfl.Assets;
import sys.io.File;
#if windows
import Discord.DiscordClient;
#end
#if sys
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var doof:DialogueBox;
	var doof2:dialogues.MonikaDialogueBox;
	var doof3:dialogues.MonikaDialogueBox;
	var doof4:dialogues.MonikaDialogueBox;
	var doofMonika:DialogueBox;
	var doofWhitty:dialogues.WhittyDialogueBox;
	var doofMyra:dialogues.MyraDialogueBox;
	var doofGarcello:dialogues.GarcelloDialogueBox;
	var doofJamey:dialogues.JameyDialogueBox;
	var doofQT:dialogues.QTDialogueBox;
	var doofBob:dialogues.BobDialogueBox;

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	var daSection:Int = 1;

	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;
	private var SplashNote:NoteSplash;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra1:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra2:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra3:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var noteSplashOp:Bool; //chadbross is cool
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var graves_assets:FlxSprite;
	var ghosts_assets:FlxSprite;
	var funpillarts1ANIM:FlxSprite;
	var hands:FlxSprite;
	var tree:FlxSprite;
	var eyeflower:FlxSprite;
	var blackFuck:FlxSprite;
	var startCircle:FlxSprite;
	var startText:FlxSprite;
	var daJumpscare:FlxSprite = new FlxSprite(0, 0);
	var wBg:FlxSprite;
	var nwBg:FlxSprite;
	var wstageFront:FlxSprite;


	//QT Week
	var hazardRandom:Int = 1; //This integer is randomised upon song start between 1-5.
	var cessationTroll:FlxSprite;
	var streetBG:FlxSprite;
	var qt_tv01:FlxSprite;
	//For detecting if the song has already ended internally for Careless's end song dialogue or something -Haz.
	var qtCarelessFin:Bool = false; //If true, then the song has ended, allowing for the school intro to play end dialogue instead of starting dialogue.
	var qtCarelessFinCalled:Bool = false; //Used for terminates meme ending to stop it constantly firing code when song ends or something.
	//For Censory Overload -Haz
	var qt_gas01:FlxSprite;
	var qt_gas02:FlxSprite;
	public static var cutsceneSkip:Bool = false;
	//For changing the visuals -Haz
	var streetBGerror:FlxSprite;
	var streetFrontError:FlxSprite;
	var dad404:Character;
	var gf404:Character;
	var boyfriend404:Boyfriend;
	var qtIsBlueScreened:Bool = false;
	//Termination-playable
	var bfDodging:Bool = false;
	var bfCanDodge:Bool = false;
	var bfDodgeTiming:Float = 0.22625;
	var bfDodgeCooldown:Float = 0.1135;
	var kb_attack_saw:FlxSprite;
	var kb_attack_alert:FlxSprite;
	var pincer1:FlxSprite;
	var pincer2:FlxSprite;
	var pincer3:FlxSprite;
	var pincer4:FlxSprite;
	public static var deathBySawBlade:Bool = false;
	var canSkipEndScreen:Bool = false; //This is set to true at the "thanks for playing" screen. Once true, in update, if enter is pressed it'll skip to the main menu.

	var noGameOver:Bool = false; //If on debug mode, pressing 5 would toggle this variable, making it impossible to die!

	//qt mod is big as fuck

	//Bob
	var bobmadshake:FlxSprite;
	var RonTurn:Bool = true;
	var bobsound:FlxSound;	
	var IsNoteSpinning:Bool = false;
	var windowX:Float = Lib.application.window.x;
	var windowY:Float = Lib.application.window.y;
	var SpinAmount:Float = 0;
	var screenBudget:FlxSprite;


	var space:FlxBackdrop;
	var oldspace:FlxSprite;
	var whiteflash:FlxSprite;
	var blackScreen:FlxSprite;

	private var shakeCam:Bool = false;
	private var shakeCam2:Bool = false;
	var spinArray:Array<Int>;
	var camLocked:Bool = true;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end

	var _pad:ui.FlxVirtualPad;


	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		spinArray = [272, 276, 336, 340, 400, 404, 464, 468, 528, 532, 592, 596, 656, 660, 720, 724, 789, 793, 863, 867, 937, 941, 1012, 1016, 1086, 1090, 1160, 1164, 1531, 1535, 1607, 1611, 1681, 1685, 1754, 1758];

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		

		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart")); 
		
		if (!executeModchart && openfl.utils.Assets.exists("assets/data/" + SONG.song.toLowerCase()  + "/modchart.lua"))
			{
				var path = Paths.luaAsset(SONG.song.toLowerCase()  + "/modchart");
				var luaFile = openfl.Assets.getBytes(path);
	
				FileSystem.createDirectory(Main.path + "assets");
				FileSystem.createDirectory(Main.path + "assets/data");
				FileSystem.createDirectory(Main.path + "assets/data/" + SONG.song.toLowerCase());
	
	
				File.saveBytes(Paths.lua(SONG.song.toLowerCase()  + "/modchart"), luaFile);
	
				executeModchart = FileSystem.exists(Paths.lua(SONG.song.toLowerCase()  + "/modchart"));
			}
	
			trace('modcharts are $executeModchart');

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.alpha = 0.6;
		grpNoteSplashes.add(sploosh);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		whiteflash = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.WHITE);
		whiteflash.scrollFactor.set();


		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'headache':
				dialogue = CoolUtil.coolTextFile(Paths.txt('headache/headacheDialogue'));
			case 'nerves':
				dialogue = CoolUtil.coolTextFile(Paths.txt('nerves/nervesDialogue'));
			case 'release':
				dialogue = CoolUtil.coolTextFile(Paths.txt('release/releaseDialogue'));
			case 'fading':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fading/fadingDialogue'));
			case 'cackle':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cackle/cackleDialogue'));
			case 'bones':
				dialogue = CoolUtil.coolTextFile(Paths.txt('bones/bonesDialogue'));
			case 'mystic':
				dialogue = CoolUtil.coolTextFile(Paths.txt('mystic/mysticDialogue'));
			case 'hocus-pocus':
				dialogue = CoolUtil.coolTextFile(Paths.txt('hocus-pocus/hocus-pocusDialogue'));		
		    case 'high-school-conflict':
				dialogue = CoolUtil.coolTextFile(Paths.txt('high-school-conflict/high-school-conflictDialogue'));
				extra3 = CoolUtil.coolTextFile(Paths.txt('high-school-conflict/high-school-conflictEndDialogue')); 
			case 'bara-no-yume':
				extra1 = CoolUtil.coolTextFile(Paths.txt('bara-no-yume/bara no yume-Dialogue'));
				extra3 = CoolUtil.coolTextFile(Paths.txt('bara-no-yume/bara no yume-EndDialogue')); 
			case 'your-demise':
				dialogue = CoolUtil.coolTextFile(Paths.txt('your-demise/your-demiseDialogue'));
				extra2 = CoolUtil.coolTextFile(Paths.txt('your-demise/your-demiseEndDialogue'));
				extra3 = CoolUtil.coolTextFile(Paths.txt('your-demise/FinalCutsceneDialouge'));
			case 'fixel':
				dialogue = CoolUtil.coolTextFile(Paths.txt('fixel/fixelDialogue'));
			case 'genesismk2':
				dialogue = CoolUtil.coolTextFile(Paths.txt('genesismk2/genesismk2Dialogue'));
			case 'overbearing':
				dialogue = CoolUtil.coolTextFile(Paths.txt('overbearing/overbearingDialogue'));
			case 'lo-fight':
				dialogue = CoolUtil.coolTextFile(Paths.txt('lo-fight/pleaseSubscribe'));
			case 'overhead':
				dialogue = CoolUtil.coolTextFile(Paths.txt('overhead/pleaseSubscribe'));		//This is so big wth
			case 'ballistic':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ballistic/pleaseSubscribe'));
			case 'carefree':
				dialogue = CoolUtil.coolTextFile(Paths.txt('carefree/carefreeDialogue'));
			case 'careless':
				dialogue = CoolUtil.coolTextFile(Paths.txt('careless/carelessDialogue'));
			case 'cessation':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cessation/finalDialogue'));
			case 'censory-overload':
				dialogue = CoolUtil.coolTextFile(Paths.txt('censory-overload/censory-overloadDialogue'));
			case 'terminate':
				dialogue = CoolUtil.coolTextFile(Paths.txt('terminate/terminateDialogue'));								
			case 'sunshine':
				dialogue = CoolUtil.coolTextFile(Paths.txt('sunshine/DumbDialogPhloxMade'));
			case 'withered':
				dialogue = CoolUtil.coolTextFile(Paths.txt('withered/DumbDialogPhloxMade'));
			case 'run':
				dialogue = CoolUtil.coolTextFile(Paths.txt('run/DumbDialogPhloxMade'));
			case 'ron':
				dialogue = CoolUtil.coolTextFile(Paths.txt('ron/ronDialogue'));
			case 'trouble':
				dialogue = CoolUtil.coolTextFile(Paths.txt('trouble/assfart'));
			case 'onslaught':
				dialogue = CoolUtil.coolTextFile(Paths.txt('onslaught/help'));											
		}

			switch(SONG.stage)
			{
				case 'halloween': 
				{
					curStage = 'spooky';
					halloweenLevel = true;
	
					var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');
	
					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');

					if (FlxG.save.data.bg){
						add(halloweenBG);
					}				
	
					isHalloween = true;
				}
				case 'philly': 
						{
						curStage = 'philly';
	
						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
						bg.scrollFactor.set(0.1, 0.1);					
						
	
						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
						city.scrollFactor.set(0.3, 0.3);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();				
						
	
						phillyCityLights = new FlxTypedGroup<FlxSprite>();					
						if(FlxG.save.data.bg){
							add(phillyCityLights);
						}
	
						for (i in 0...5)
						{
								var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
								light.scrollFactor.set(0.3, 0.3);
								light.visible = false;
								light.setGraphicSize(Std.int(light.width * 0.85));
								light.updateHitbox();
								phillyCityLights.add(light);
						}
	
						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));			
					
	
						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
	
						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
						FlxG.sound.list.add(trainSound);
	
						// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
	
						var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
						if	(FlxG.save.data.bg){
							add(bg);
							add(city);
							add(phillyCityLights);
							add(streetBehind);
							add(phillyTrain);
							add(street);
						}
				}
				case 'limo':
				{
						curStage = 'limo';
						defaultCamZoom = 0.90;
	
						var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
						skyBG.scrollFactor.set(0.1, 0.1);
						add(skyBG);
	
						var bgLimo:FlxSprite = new FlxSprite(-200, 480);
						bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
						bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
						bgLimo.animation.play('drive');
						bgLimo.scrollFactor.set(0.4, 0.4);
						
						if(FlxG.save.data.distractions){
							grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
							
		
							for (i in 0...5)
							{
									var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
									dancer.scrollFactor.set(0.4, 0.4);
							}
						}
	
						var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
						overlayShit.alpha = 0.5;
						// add(overlayShit);
	
						// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
	
						// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
	
						// overlayShit.shader = shaderBullshit;
	
						var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');
	
						limo = new FlxSprite(-120, 550);
						limo.frames = limoTex;
						limo.animation.addByPrefix('drive', "Limo stage", 24);
						limo.animation.play('drive');
						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
	
						fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
						// add(limo);

						if(FlxG.save.data.bg){
						add(skyBG);
						add(bgLimo);
						add(grpLimoDancers);
						}
				}
				case 'mall':
				{
						curStage = 'mall';
	
						defaultCamZoom = 0.80;
	
						var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
	
	
						upperBoppers = new FlxSprite(-240, -90);
						upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.scrollFactor.set(0.33, 0.33);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						upperBoppers.updateHitbox();
	
	
						var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));	
						bgEscalator.scrollFactor.set(0.3, 0.3);
						bgEscalator.active = false;
						bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
						bgEscalator.updateHitbox();
	
						var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
						tree.scrollFactor.set(0.40, 0.40);
						add(tree);
	
						bottomBoppers = new FlxSprite(-300, 140);
						bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
	
	
						var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
						fgSnow.active = false;
	
						santa = new FlxSprite(-840, 150);
						santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
						santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
						if(FlxG.save.data.bg){
						add(bg);
						add(upperBoppers);
						add(bgEscalator);
						add(tree);
						add(bottomBoppers);
						add(fgSnow);
						add(santa);							
						}					
				}
				case 'mallEvil':
				{
						curStage = 'mallEvil';
						var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
	
						var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
						evilTree.scrollFactor.set(0.2, 0.2);
	
						var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						if(FlxG.save.data.bg){
						add(bg);
						add(evilTree);
						add(evilSnow);
						}
				}
				case 'school':
				{
						curStage = 'school';
	
						// defaultCamZoom = 0.9;
	
						var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
						bgSky.scrollFactor.set(0.1, 0.1);
	
						var repositionShit = -200;
	
						var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
						bgSchool.scrollFactor.set(0.6, 0.90);
	
						var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
						bgStreet.scrollFactor.set(0.95, 0.95);
	
						var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
						fgTrees.scrollFactor.set(0.9, 0.9);
	
						var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
						var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
						bgTrees.frames = treetex;
						bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
						bgTrees.animation.play('treeLoop');
						bgTrees.scrollFactor.set(0.85, 0.85);
	
						var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
						treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
						treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
						treeLeaves.animation.play('leaves');
						treeLeaves.scrollFactor.set(0.85, 0.85);
	
						var widShit = Std.int(bgSky.width * 6);
	
						bgSky.setGraphicSize(widShit);
						bgSchool.setGraphicSize(widShit);
						bgStreet.setGraphicSize(widShit);
						bgTrees.setGraphicSize(Std.int(widShit * 1.4));
						fgTrees.setGraphicSize(Std.int(widShit * 0.8));
						treeLeaves.setGraphicSize(widShit);
	
						fgTrees.updateHitbox();
						bgSky.updateHitbox();
						bgSchool.updateHitbox();
						bgStreet.updateHitbox();
						bgTrees.updateHitbox();
						treeLeaves.updateHitbox();
	
						bgGirls = new BackgroundGirls(-100, 190);
						bgGirls.scrollFactor.set(0.9, 0.9);
	
						if (songLowercase == 'roses' || songLowercase == 'bara-no-yume')
							{
								if(FlxG.save.data.distractions){
									bgGirls.getScared();
								}
							}
	
						bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						bgGirls.updateHitbox();
						if(FlxG.save.data.bg){
							add(bgSky);
							add(bgSchool);
							add(bgStreet);
							add(fgTrees);
							add(bgTrees);		
							add(treeLeaves);
							add(bgGirls);
						}
				}
				case 'schoolEvil':
				{
					if (SONG.song.toLowerCase () == 'your demise')
						{
							curStage = 'schoolEvil';
							defaultCamZoom = 0.9;
		
							var posX = 50;
							var posY = 200;
		
							//finalebgmybeloved
							var oldspace:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('finalebgmybeloved'));
							oldspace.antialiasing = false;
							oldspace.scale.set(1.65, 1.65);
							oldspace.scrollFactor.set(0.1, 0.1);
							
		
							add(space = new FlxBackdrop(Paths.image('weeb/FinaleBG_1','week6')));
							space.velocity.set(-10, 0);
							space.antialiasing = false;
							space.scrollFactor.set(0.1, 0.1);
							space.scale.set(1.65, 1.65);
		
							var bg:FlxSprite = new FlxSprite(70, posY).loadGraphic(Paths.image('weeb/FinaleBG_2','week6'));
							bg.antialiasing = false;
							bg.scale.set(2.3, 2.3);
							bg.scrollFactor.set(0.4, 0.6);
							
		
							var stageFront:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/FinaleFG','week6'));
							stageFront.antialiasing = false;
							stageFront.scale.set(1.5, 1.5);
							stageFront.scrollFactor.set(1, 1);

							if (FlxG.save.data.bg){
									add(oldspace);
									add(bg);
									add(stageFront);	
							}	
												
						}
						else{
							curStage = 'schoolEvil';
	
							var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
							var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
		
							var posX = 400;
							var posY = 200;
		
							var bg:FlxSprite = new FlxSprite(posX, posY);
							bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
							bg.animation.addByPrefix('idle', 'background 2', 24);
							bg.animation.play('idle');
							bg.scrollFactor.set(0.8, 0.9);
							bg.scale.set(6, 6);
							
							if (FlxG.save.data.bg){
								add(bg);	
								}

		
							/* 
									var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
									bg.scale.set(6, 6);
									// bg.setGraphicSize(Std.int(bg.width * 6));
									// bg.updateHitbox();
									add(bg);
									var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
									fg.scale.set(6, 6);
									// fg.setGraphicSize(Std.int(fg.width * 6));
									// fg.updateHitbox();
									add(fg);
									wiggleShit.effectType = WiggleEffectType.DREAMY;
									wiggleShit.waveAmplitude = 0.01;
									wiggleShit.waveFrequency = 60;
									wiggleShit.waveSpeed = 0.8;
								*/
		
							// bg.shader = wiggleShit.shader;
							// fg.shader = wiggleShit.shader;
		
							/* 
										var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
										var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
										// Using scale since setGraphicSize() doesnt work???
										waveSprite.scale.set(6, 6);
										waveSpriteFG.scale.set(6, 6);
										waveSprite.setPosition(posX, posY);
										waveSpriteFG.setPosition(posX, posY);
										waveSprite.scrollFactor.set(0.7, 0.8);
										waveSpriteFG.scrollFactor.set(0.9, 0.8);
										// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
										// waveSprite.updateHitbox();
										// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
										// waveSpriteFG.updateHitbox();
										add(waveSprite);
										add(waveSpriteFG);
								*/
						}
							
				}
				case 'stage':
					{
							defaultCamZoom = 0.9;
							curStage = 'stage';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							
		
							var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
							stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
							stageCurtains.updateHitbox();
							stageCurtains.scrollFactor.set(1.3, 1.3);
							stageCurtains.active = false;
		
							if (FlxG.save.data.bg){
							add(bg);
							add(stageFront);
							add(stageCurtains);
							}
					}
					case 'garAlley':
						{
								defaultCamZoom = 0.9;
								curStage = 'garAlley';
	  
								var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebg'));
								if	(FlxG.save.data.antiaslising){
									bg.antialiasing = true;
								}
								else if	(!FlxG.save.data.antiaslising){
									bg.antialiasing = false;
								}
								bg.scrollFactor.set(0.7, 0.7);
								bg.active = false;
								
	  
								var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStage'));
								if	(FlxG.save.data.antiaslising){
									bgAlley.antialiasing = true;
								}
								else if	(!FlxG.save.data.antiaslising){
									bgAlley.antialiasing = false;
								}
								bgAlley.scrollFactor.set(0.9, 0.9);
								bgAlley.active = false;

								if (FlxG.save.data.bg){
								add(bg);
								add(bgAlley);
								}
						  }
						case 'garAlleyDead':
						{
								defaultCamZoom = 0.9;
								curStage = 'garAlleyDead';
	  
								var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgAlt'));
								bg.scrollFactor.set(0.7, 0.7);
								bg.active = false;
								
	  
								var smoker:FlxSprite = new FlxSprite(0, -290);
								smoker.frames = Paths.getSparrowAtlas('garcello/garSmoke');
								smoker.setGraphicSize(Std.int(smoker.width * 1.7));
								smoker.alpha = 0.3;
								smoker.animation.addByPrefix('garsmoke', "smokey", 13);
								smoker.animation.play('garsmoke');
								smoker.scrollFactor.set(0.7, 0.7);
								
	  
								var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStagealt'));
								bgAlley.scrollFactor.set(0.9, 0.9);
								bgAlley.active = false;
								
	  
								var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('garcello/gardead'));
								corpse.scrollFactor.set(0.9, 0.9);
								corpse.active = false;

								if (FlxG.save.data.bg){
								add(bg);
								add(smoker);
								add(bgAlley);
								add(corpse);
								}
						  }
						case 'garAlleyDip':
						{
								defaultCamZoom = 0.9;
								curStage = 'garAlleyDip';
	  
								var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('garcello/garStagebgRise'));
								bg.scrollFactor.set(0.7, 0.7);
								bg.active = false;
								
	  
								var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('garcello/garStageRise'));
								bgAlley.scrollFactor.set(0.9, 0.9);
								bgAlley.active = false;
								
	  
								var corpse:FlxSprite = new FlxSprite(-230, 540).loadGraphic(Paths.image('garcello/gardead'));
								corpse.scrollFactor.set(0.9, 0.9);
								corpse.active = false;

								if (FlxG.save.data.bg){
								add(bg);
								add(bgAlley);
								add(corpse);
								}
						  }		
				case 'graveyard': 
				{
						curStage = 'graveyard';
	
						var bg:FlxSprite = new FlxSprite(-200, -220);
						bg.loadGraphic(Paths.image("myra/graveyard"));
						
						bg.updateHitbox();
						bg.scrollFactor.set(0.85, 0.85);

						if (FlxG.save.data.bg){
						add(bg);
						}
					}
				case 'raveyard1': 
				{
						curStage = 'raveyard1';
	
	
						var bg:FlxSprite = new FlxSprite(-200, -220);
						bg.loadGraphic(Paths.image("myra/graveyard"));
						
						bg.updateHitbox();
						bg.scrollFactor.set(0.85, 0.85);
	
						graves_assets = new FlxSprite(-200, -220);
						graves_assets.frames = Paths.getSparrowAtlas('myra/graves_assets');
						graves_assets.animation.addByPrefix('idle', "Graves", 24, false);
						graves_assets.scrollFactor.set(0.85, 0.85);
						graves_assets.updateHitbox();

						if (FlxG.save.data.bg){
						add(bg);
						add(graves_assets);
						}
						
				}
				case 'hocus-pocus': 
				{
						curStage = 'raveyard2';
	
	
						var bg:FlxSprite = new FlxSprite(-200, -220);
						bg.loadGraphic(Paths.image("myra/graveyard"));
						
						bg.updateHitbox();
						bg.scrollFactor.set(0.85, 0.85);
	
						ghosts_assets = new FlxSprite(-200, -220);
						ghosts_assets.frames = Paths.getSparrowAtlas('myra/ghosts_assets');
						ghosts_assets.animation.addByPrefix('idle', "Ghosts", 24, false);
						ghosts_assets.scrollFactor.set(0.85, 0.85);
						ghosts_assets.updateHitbox();
						
						if (FlxG.save.data.bg){
						add(bg);
						add(ghosts_assets);	
						}
					}
				//SONG 1 STAGE
				case 'sonicStage':
					{	
					defaultCamZoom = 1.0;
					curStage = 'SONICstage';
	
	
	
					var sSKY:FlxSprite = new FlxSprite(-300, 0).loadGraphic(Paths.image('SonicStages/sky', 'exe'));
					sSKY.scrollFactor.set(0.85, 0.85);
					sSKY.active = false;
					
	
					var bg2:FlxSprite = new FlxSprite(-300, -125).loadGraphic(Paths.image('SonicStages/floor2', 'exe'));
					bg2.updateHitbox();
					bg2.scrollFactor.set(0.9, 0.9);
					bg2.active = false;
					
	
	
					var bg:FlxSprite = new FlxSprite(-300, -100).loadGraphic(Paths.image('SonicStages/floor1', 'exe'));
					bg.scrollFactor.set(0.95, 0.95);
					bg.active = false;
					
	
					var eggman:FlxSprite = new FlxSprite(-260, -120).loadGraphic(Paths.image('SonicStages/eggman', 'exe'));
					eggman.setGraphicSize(Std.int(eggman.width * 0.9));
					eggman.updateHitbox();
					eggman.scrollFactor.set(.95, .95);
					eggman.active = false;
	
					
	
					var tail:FlxSprite = new FlxSprite(-280, -100).loadGraphic(Paths.image('SonicStages/tail', 'exe'));
					tail.setGraphicSize(Std.int(tail.width * 0.9));
					tail.updateHitbox();
					tail.scrollFactor.set(.99, .99);
					tail.active = false;
	
					
	
					var knuckle:FlxSprite = new FlxSprite(315, 0).loadGraphic(Paths.image('SonicStages/knuckle', 'exe'));
					knuckle.setGraphicSize(Std.int(knuckle.width * 0.9));
					knuckle.updateHitbox();
					knuckle.scrollFactor.set(.99, .99);
					knuckle.active = false;
	
					
					
	
					var sticklol:FlxSprite = new FlxSprite(-300, -50).loadGraphic(Paths.image('SonicStages/sticklol', 'exe'));
					sticklol.setGraphicSize(Std.int(sticklol.width * 0.9));
					sticklol.updateHitbox();
					sticklol.scrollFactor.set(1, 1);
					sticklol.active = false;
	
					if (FlxG.save.data.bg){
					add(sSKY);
					add(bg2);
					add(bg);
					add(eggman);
					add(tail);					 					
					add(knuckle);
					add(sticklol);
					}
					}
					case 'LordXStage': //epic
						{	
						defaultCamZoom = .73;
						curStage = 'LordXStage';
		
		
		
						var sky:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/sky', 'exe'));
						sky.setGraphicSize(Std.int(sky.width * .5));
						sky.scrollFactor.set(.95, 1);
						sky.active = false;
						
	
						var hills1:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/hills1', 'exe'));
						hills1.setGraphicSize(Std.int(hills1.width * .5));
						hills1.scrollFactor.set(.95, 1);
						hills1.active = false;
						
	
						var hills2:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/hills2', 'exe'));
						hills2.setGraphicSize(Std.int(hills2.width * .5));
						hills2.scrollFactor.set(.97, 1);
						hills2.active = false;
						
	
						var floor:FlxSprite = new FlxSprite(-1900, -996).loadGraphic(Paths.image('LordXStage/floor', 'exe'));
						floor.setGraphicSize(Std.int(floor.width * .5));
						floor.scrollFactor.set(1, 1);
						floor.active = false;
						
	
						eyeflower = new FlxSprite(-200,300);
						eyeflower.frames = Paths.getSparrowAtlas('LordXStage/ANIMATEDeye', 'exe');
						eyeflower.animation.addByPrefix('animatedeye', 'EyeAnimated', 24);
						eyeflower.setGraphicSize(Std.int(eyeflower.width * 2));
						eyeflower.scrollFactor.set(1, 1);
						
	
						
						hands = new FlxSprite(-200, -600); 
						hands.frames = Paths.getSparrowAtlas('LordXStage/SonicXHandsAnimated', 'exe');
						hands.animation.addByPrefix('handss', 'HandsAnimated', 24);
						hands.setGraphicSize(Std.int(hands.width * .5));
						hands.scrollFactor.set(1, 1);
						
	
						var smallflower:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/smallflower', 'exe'));
						smallflower.setGraphicSize(Std.int(smallflower.width * .5));
						smallflower.scrollFactor.set(1.005, 1.005);
						smallflower.active = false;
						
	
						var smallflower:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/smallflower', 'exe'));
						smallflower.setGraphicSize(Std.int(smallflower.width * .5));
						smallflower.scrollFactor.set(1.005, 1.005);
						smallflower.active = false;
						
	
						var smallflowe2:FlxSprite = new FlxSprite(-1900, -1006).loadGraphic(Paths.image('LordXStage/smallflowe2', 'exe'));
						smallflowe2.setGraphicSize(Std.int(smallflower.width * .5));
						smallflowe2.antialiasing = true;
						smallflowe2.scrollFactor.set(1.005, 1.005);
						smallflowe2.active = false;
						
	
						tree = new FlxSprite(1250, -50);
						tree.frames = Paths.getSparrowAtlas('LordXStage/TreeAnimatedMoment', 'exe');
						tree.animation.addByPrefix('treeanimation', 'TreeAnimated', 24);
						tree.setGraphicSize(Std.int(tree.width * 2));
						tree.scrollFactor.set(1, 1);
						
						if (FlxG.save.data.bg){
						add(sky);
						add(hills1);
						add(hills2);
						add(floor);	
						add(eyeflower);
						add(hands);
						add(smallflower);
						add(smallflowe2);
						add(tree);	
						}
						}
					//SECRET SONG STAGE!!!   Really razen... you really had to say it here?
					
						case 'sonicfunStage':
						{
								defaultCamZoom = 0.9;
								curStage = 'sonicFUNSTAGE';
	
								var funsky:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('FunInfiniteStage/sonicFUNsky', 'exe'));
								funsky.scrollFactor.set(0.3, 0.3);
								funsky.active = false;
								
	
								var funfloor:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('FunInfiniteStage/sonicFUNfloor', 'exe'));
								funfloor.setGraphicSize(Std.int(funfloor.width * 0.9), Std.int(funfloor.height * 1.2));
								funfloor.scrollFactor.set(0.5, 0.5);
								funfloor.active = false;
								
	
								var funpillars3:FlxSprite = new FlxSprite(-600, -0).loadGraphic(Paths.image('FunInfiniteStage/sonicFUNpillars3', 'exe'));
								funpillars3.setGraphicSize(Std.int(funpillars3.width * 0.7));
								funpillars3.scrollFactor.set(0.6, 0.7);
								funpillars3.active = false;
								
	
								var funpillars2:FlxSprite = new FlxSprite(-600, -0).loadGraphic(Paths.image('FunInfiniteStage/sonicFUNpillars2', 'exe'));
								funpillars2.setGraphicSize(Std.int(funpillars2.width * 0.7));
								funpillars2.scrollFactor.set(0.7, 0.7);
								funpillars2.active = false;
								
	
								funpillarts1ANIM = new FlxSprite(-400, 0);
								funpillarts1ANIM.frames = Paths.getSparrowAtlas('FunInfiniteStage/FII_BG', 'exe');
								funpillarts1ANIM.animation.addByPrefix('bumpypillar', 'sonicboppers', 24);
								funpillarts1ANIM.setGraphicSize(Std.int(funpillarts1ANIM.width * 0.7));
								funpillarts1ANIM.scrollFactor.set(0.82, 0.82);
								
								if (FlxG.save.data.bg){
								add(funsky);
								add(funfloor);
								add(funpillars3);
								add(funpillars2);
								add(funpillarts1ANIM);	
								}
						}
			case 'overit':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('jamey/stagepain'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						
						if (FlxG.save.data.bg){
							add(bg);
						}
				}
      case 'alley' | 'ballisticAlley':
        {
          	defaultCamZoom = 0.9;
            curStage = 'whitty';
            wBg = new FlxSprite(-500, -300).loadGraphic(Paths.image('whittyBack', 'bonusWeek'));

            if (SONG.stage == 'ballisticAlley')
            {
              trace('pogging');
			  var bgTex = Paths.getSparrowAtlas('BallisticBackground', 'bonusWeek');
              nwBg = new FlxSprite(-600, -200);
              nwBg.frames = bgTex;
              nwBg.antialiasing = true;
              nwBg.scrollFactor.set(0.9, 0.9);
              nwBg.active = true;
              nwBg.animation.addByPrefix('start', 'Background Whitty Start', 24, false);
              nwBg.animation.addByPrefix('gaming', 'Background Whitty Startup', 24, false);
              nwBg.animation.addByPrefix('gameButMove', 'Background Whitty Moving', 16, true);
             
             
              nwBg.alpha = 0;
              wstageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront', 'bonusWeek'));
              wstageFront.setGraphicSize(Std.int(wstageFront.width * 1.1));
              wstageFront.updateHitbox();
              wstageFront.scrollFactor.set(0.9, 0.9);
              wstageFront.active = false;
			  if (FlxG.save.data.bg){
				add(nwBg);
				add(wstageFront);
			  }
              
            }
            else
            {
              wBg.scrollFactor.set(0.9, 0.9);
              wBg.active = false;

              wstageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront', 'bonusWeek'));
              wstageFront.setGraphicSize(Std.int(wstageFront.width * 1.1));
              wstageFront.updateHitbox();
              wstageFront.antialiasing = true;
              wstageFront.scrollFactor.set(0.9, 0.9);
              wstageFront.active = false;
			  if (FlxG.save.data.bg){
				add(wBg);
				add(wstageFront);
			  } 
             
            }
            // bg.setGraphicSize(Std.int(bg.width * 2.5));
            // bg.updateHitbox();   
        
        }
		case 'streetCute': 
			{
				defaultCamZoom = 0.92125;
				//defaultCamZoom = 0.8125;
				curStage = 'streetCute';
				//Postitive = Right, Down
				//Negative = Left, Up
				var bg:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackCute', 'qt'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				

				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontCute', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

				qt_tv01 = new FlxSprite(-62, 540).loadGraphic(Paths.image('stage/TV_V2_off', 'qt'));
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				qt_tv01.active = false;
				

				if (FlxG.save.data.bg){
				add(bg);
				add(streetFront);
				add(qt_tv01);
				}

			}
			case 'streetCute1': 
			{
				defaultCamZoom = 0.8125;
				curStage = 'streetCute1';
				var bg:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackCute', 'qt'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				

				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontCute', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V4', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);	
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 28, false);		
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.animation.addByPrefix('heart', 'TV_End', 24, false);
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				
				qt_tv01.animation.play('heart');

				//Alert!
				kb_attack_alert = new FlxSprite();
				kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW');
				kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
				kb_attack_alert.antialiasing = true;
				kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
				kb_attack_alert.cameras = [camHUD];
				kb_attack_alert.x = FlxG.width - 700;
				kb_attack_alert.y = 205;

				cessationTroll = new FlxSprite(-62, 540).loadGraphic(Paths.image('bonus/justkidding', 'qt'));
				cessationTroll.setGraphicSize(Std.int(cessationTroll.width * 0.9));
				cessationTroll.cameras = [camHUD];
				cessationTroll.x = FlxG.width - 950;
				cessationTroll.y = 205;

				if (FlxG.save.data.bg){
					add(bg);
					add(streetFront);
					add(qt_tv01);
				}
			}	
			case 'street': 
			{
				defaultCamZoom = 0.925;
				curStage = 'street';
				var bg:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				

				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 26, false);
				//qt_tv01.animation.addByPrefix('eye', 'TV_eyes', 24, true);	
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('eyeLeft', 'TV_eyeLeft', 24, false);
				qt_tv01.animation.addByPrefix('eyeRight', 'TV_eyeRight', 24, false);

				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				
				qt_tv01.animation.play('idle');
				if (FlxG.save.data.bg){
					add(bg);
					add(streetFront);
					add(qt_tv01);
				}	
			}
			case 'streetFinal1': 
			{
				defaultCamZoom = 0.8125;
				
				curStage = 'streetFinal';

					//Far Back Layer - Error (blue screen)
					var errorBG:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetError', 'qt'));
					errorBG.antialiasing = true;
					errorBG.scrollFactor.set(0.9, 0.9);
					errorBG.active = false;
					

					//Back Layer - Error (glitched version of normal Back)
					streetBGerror = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackError', 'qt'));
					streetBGerror.antialiasing = true;
					streetBGerror.scrollFactor.set(0.9, 0.9);
					
				

				//Back Layer - Normal
				streetBG = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
				streetBG.antialiasing = true;
				streetBG.scrollFactor.set(0.9, 0.9);
				


				//Front Layer - Normal
				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

					//Front Layer - Error (changes to have a glow)
					streetFrontError = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontError', 'qt'));
					streetFrontError.setGraphicSize(Std.int(streetFrontError.width * 1.15));
					streetFrontError.updateHitbox();
					streetFrontError.antialiasing = true;
					streetFrontError.scrollFactor.set(0.9, 0.9);
					streetFrontError.active = false;
					
					streetFrontError.visible = false;
				


				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
				qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 32, false);		
				qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
				qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				
				qt_tv01.animation.play('idle');

				//https://youtu.be/Nz0qjc8WRyY?t=1749
				//Wow, I guess it's that easy huh? -Haz
		/*			boyfriend404 = new Boyfriend(770, 450, 'bf_404');
					dad404 = new Character(100,100,'robot_404');
					gf404 = new Character(400,130,'gf_404');
					gf404.scrollFactor.set(0.95, 0.95); 

					//These are set to 0 on first step. Not 0 here because otherwise they aren't cached in properly or something?
					//I dunno
					boyfriend404.alpha = 0.0125; 
					dad404.alpha = 0.0125;
					gf404.alpha = 0.0125;  */

					//Probably a better way of doing this... too bad! -Haz
					qt_gas01 = new FlxSprite();
					//Old gas sprites.
					//qt_gas01.frames = Paths.getSparrowAtlas('stage/gas_test');
					//qt_gas01.animation.addByPrefix('burst', 'ezgif.com-gif-makernew_gif instance ', 30, false);	

					//Left gas
					qt_gas01.frames = Paths.getSparrowAtlas('stage/Gas_Release', 'qt');
					qt_gas01.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
					qt_gas01.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
					qt_gas01.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
					qt_gas01.setGraphicSize(Std.int(qt_gas01.width * 2.5));	
					qt_gas01.antialiasing = true;
					qt_gas01.scrollFactor.set();
					qt_gas01.alpha = 0.72;
					qt_gas01.setPosition(-880,-100);
					qt_gas01.angle = -31;				

					//Right gas
					qt_gas02 = new FlxSprite();
					//qt_gas02.frames = Paths.getSparrowAtlas('stage/gas_test');
					//qt_gas02.animation.addByPrefix('burst', 'ezgif.com-gif-makernew_gif instance ', 30, false);

					qt_gas02.frames = Paths.getSparrowAtlas('stage/Gas_Release', 'qt');
					qt_gas02.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
					qt_gas02.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
					qt_gas02.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
					qt_gas02.setGraphicSize(Std.int(qt_gas02.width * 2.5));
					qt_gas02.antialiasing = true;
					qt_gas02.scrollFactor.set();
					qt_gas02.alpha = 0.72;
					qt_gas02.setPosition(920,-100);
					qt_gas02.angle = 31;
					if (FlxG.save.data.bg){
						add(errorBG);
						add(streetBGerror);
						add(streetBG);
						add(streetFront);
						add(streetFrontError);
						add(qt_tv01);
					}
			}
			case 'street1':
			{
				defaultCamZoom = 0.8125;
				curStage = 'street';
				var bg:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				

				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);
					
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				
				qt_tv01.animation.play('idle');
				if (FlxG.save.data.bg){
					add(bg);
					add(streetFront);
					add(qt_tv01);
				}
			}
			case 'streetFinal': //Seperated the two so terminate can load quicker (doesn't need to load in the attack animations and stuff)
			{
				defaultCamZoom = 0.8125;
				
				curStage = 'streetFinal';

					//Far Back Layer - Error (blue screen)
					var errorBG:FlxSprite = new FlxSprite(-600, -150).loadGraphic(Paths.image('stage/streetError', 'qt'));
					errorBG.antialiasing = true;
					errorBG.scrollFactor.set(0.9, 0.9);
					errorBG.active = false;
					

					//Back Layer - Error (glitched version of normal Back)
					streetBGerror = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackError', 'qt'));
					streetBGerror.antialiasing = true;
					streetBGerror.scrollFactor.set(0.9, 0.9);
					
				

				//Back Layer - Normal
				streetBG = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
				streetBG.antialiasing = true;
				streetBG.scrollFactor.set(0.9, 0.9);
				


				//Front Layer - Normal
				var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				

					//Front Layer - Error (changes to have a glow)
					streetFrontError = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontError', 'qt'));
					streetFrontError.setGraphicSize(Std.int(streetFrontError.width * 1.15));
					streetFrontError.updateHitbox();
					streetFrontError.antialiasing = true;
					streetFrontError.scrollFactor.set(0.9, 0.9);
					streetFrontError.active = false;
					
					streetFrontError.visible = false;

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('eyeRight', 'TV_eyeRight', 24, true);
				qt_tv01.animation.addByPrefix('eyeLeft', 'TV_eyeLeft', 24, true);
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
				qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 36, false);		
				qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
				qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.animation.addByPrefix('instructions', 'TV_Instructions-Normal', 24, true);
				qt_tv01.animation.addByPrefix('gl', 'TV_GoodLuck', 24, true);
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				
				qt_tv01.animation.play('idle');


				//https://youtu.be/Nz0qjc8WRyY?t=1749
			/*	//Wow, I guess it's that easy huh? -Haz
					boyfriend404 = new Boyfriend(770, 450, 'bf_404');
					dad404 = new Character(100,100,'robot_404-TERMINATION');
					gf404 = new Character(400,130,'gf_404');
					gf404.scrollFactor.set(0.95, 0.95);

					//These are set to 0 on first step. Not 0 here because otherwise they aren't cached in properly or something?
					//I dunno
					boyfriend404.alpha = 0.0125; 
					dad404.alpha = 0.0125;
					gf404.alpha = 0.0125; */
				

				//Alert!
				kb_attack_alert = new FlxSprite();
				kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW', 'qt');
				kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
				kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
				kb_attack_alert.antialiasing = true;
				kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
				kb_attack_alert.cameras = [camHUD];
				kb_attack_alert.x = FlxG.width - 700;
				kb_attack_alert.y = 205;
				//kb_attack_alert.animation.play("alert"); //Placeholder, change this to start already hidden or whatever.

				//Saw that one coming!
				kb_attack_saw = new FlxSprite();
				kb_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'qt');
				kb_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
				kb_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
				kb_attack_saw.setGraphicSize(Std.int(kb_attack_saw.width * 1.15));
				kb_attack_saw.antialiasing = true;
				kb_attack_saw.setPosition(-860,615);

				//Pincer shit for moving notes around for a little bit of trollin'
				pincer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer1.antialiasing = true;
				pincer1.scrollFactor.set();
				
				pincer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer2.antialiasing = true;
				pincer2.scrollFactor.set();
				
				pincer3 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer3.antialiasing = true;
				pincer3.scrollFactor.set();

				pincer4 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer4.antialiasing = true;
				pincer4.scrollFactor.set();
				
				if (FlxG.save.data.downscroll){
					pincer4.angle = 270;
					pincer3.angle = 270;
					pincer2.angle = 270;
					pincer1.angle = 270;
					pincer1.offset.set(192,-75);
					pincer2.offset.set(192,-75);
					pincer3.offset.set(192,-75);
					pincer4.offset.set(192,-75);
				}else{
					pincer4.angle = 90;
					pincer3.angle = 90;
					pincer2.angle = 90;
					pincer1.angle = 90;
					pincer1.offset.set(218,240);
					pincer2.offset.set(218,240);
					pincer3.offset.set(218,240);
					pincer4.offset.set(218,240);
				}
				if (FlxG.save.data.bg){
					add(errorBG);
					add(streetBGerror);
					add(streetBG);
					add(streetFront);
					add(streetFrontError);
					add(qt_tv01);
				}
			}		
	/*	case 'redacted': 
			{
				defaultCamZoom = 0.45;
				curStage = 'nightmare';

				var bg:FlxSprite = new FlxSprite(-750, -200).loadGraphic(Paths.image('weeb/pixelUI/ssshhh/redacted/nightmare_gradient'));
				bg.antialiasing = true;
				bg.screenCenter();
				bg.scrollFactor.set(0,0);
				bg.active = false;
				add(bg);
				var floor:FlxSprite = new FlxSprite(-750, -200).loadGraphic(Paths.image('weeb/pixelUI/ssshhh/redacted/nightmare'));
				floor.antialiasing = true;
				floor.scrollFactor.set(0.9, 0.9);
				floor.active = false;
				add(floor);


				boyfriend404 = new Boyfriend(770, 450, 'bf');
				boyfriend404.alpha = 0.0125;
				//So that the game doesn't crash lmao
				dad404 = new Character(100,100,'monster');
				gf404 = new Character(400,130,'gf_404');
				gf404.scrollFactor.set(0.95, 0.95);
				dad404.alpha = 0;
				gf404.alpha = 0;

				vignette = new FlxSprite().loadGraphic(Paths.image('weeb/pixelUI/ssshhh/redacted/vignette'));
				vignette.updateHitbox();
				vignette.screenCenter();
				vignette.scrollFactor.set(0,0);
				//vignette.setGraphicSize(Std.int(vignette.width * 0.8));
				vignette.antialiasing = true;
				add(vignette);
				vignette.cameras = [camHUD];

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('weeb/pixelUI/ssshhh/redacted/TV_secret');
				qt_tv01.animation.addByPrefix('idle', 'TVSINGLE-IDLE', 24, true);
				qt_tv01.animation.addByPrefix('part1', 'TVSINGLE-01', 24, true);
				qt_tv01.animation.addByPrefix('part2', 'TVSINGLE-02', 24, true);
				qt_tv01.animation.addByPrefix('part3', 'TVSINGLE-03', 24, true);
				qt_tv01.animation.addByPrefix('part4', 'TVSINGLE-04', 24, true);

				//qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 26, false);

				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				add(qt_tv01);
				qt_tv01.animation.play('idle');

				//Alert!
				kb_attack_alert = new FlxSprite();
				kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW');
				kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
				kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
				kb_attack_alert.antialiasing = true;
				kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
				kb_attack_alert.cameras = [camHUD];
				kb_attack_alert.x = FlxG.width - 700;
				kb_attack_alert.y = 205;
				kb_attack_alert.alpha = 0.2;
			}		 */	
			case 'sunshine' :
			{
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/happysky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happyground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				if (FlxG.save.data.bg){
					add(bg);
					add(ground);
				}
			}
			
			case 'withered' :
			{
				var bg:FlxSprite = new FlxSprite( -100).loadGraphic(Paths.image('bob/slightlyannyoed_sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/slightlyannyoed_ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
			
				if (FlxG.save.data.bg){
					add(bg);
					add(ground);
				}
			}
			
			//phlox is a little baby
			case 'hellstage':
			{
				curStage = 'hellstage';
				if (FlxG.save.data.happybob)
				{
					var bg:FlxSprite = new FlxSprite( -100).loadGraphic(Paths.image('bob/happy/hell'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				
				
				var thingidk:FlxSprite = new FlxSprite( -271).loadGraphic(Paths.image('bob/happy/middlething'));
				thingidk.updateHitbox();
				thingidk.active = false;
				thingidk.antialiasing = true;
				thingidk.scrollFactor.set(0.3, 0.3);
				
				
				var dead:FlxSprite = new FlxSprite( -60, 50).loadGraphic(Paths.image('bob/happy/theydead'));
				dead.updateHitbox();
				dead.active = false;
				dead.antialiasing = true;
				dead.scrollFactor.set(0.8, 0.8);
				

				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happy/ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				
				
				bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('bob/happy/bobscreen'));
				bobmadshake.scrollFactor.set(0, 0);
				bobmadshake.visible = false;
				if (FlxG.save.data.bg){
					add(bg);
					add(thingidk);
					add(dead);
					add(ground);
				}
				}
				else
				{
					var bg:FlxSprite = new FlxSprite( -100).loadGraphic(Paths.image('bob/hell'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				
				var thingidk:FlxSprite = new FlxSprite( -271).loadGraphic(Paths.image('bob/middlething'));
				thingidk.updateHitbox();
				thingidk.active = false;
				thingidk.antialiasing = true;
				thingidk.scrollFactor.set(0.3, 0.3);
				
				var dead:FlxSprite = new FlxSprite( -60, 50).loadGraphic(Paths.image('bob/theydead'));
				dead.updateHitbox();
				dead.active = false;
				dead.antialiasing = true;
				dead.scrollFactor.set(0.8, 0.8);

				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/ground'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				
				bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('bob/bobscreen'));
				bobmadshake.scrollFactor.set(0, 0);
				bobmadshake.visible = false;
				if (FlxG.save.data.bg){
					add(bg);
					add(thingidk);
					add(dead);
					add(ground);
				}
				}
				
				bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
				
				}
				case 'onslaught' :
					{
						defaultCamZoom = 0.9;
						curStage = 'slaught';
						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/scary_sky'));
						bg.updateHitbox();
						bg.active = false;
						bg.antialiasing = true;
						bg.scrollFactor.set(0.1, 0.1);
						
						/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
						var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
						add(glitchSprite);*/
						
						var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/GlitchedGround'));
						ground.updateHitbox();
						ground.active = false;
						ground.antialiasing = true;
					
						if (FlxG.save.data.bg){
							add(bg);
							add(ground);
						}
					}				
				case 'trouble' :
					{
						defaultCamZoom = 0.9;
						curStage = 'trouble';
						var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('bob/nothappy_sky'));
						bg.updateHitbox();
						bg.scale.x = 1.2;
						bg.scale.y = 1.2;
						bg.active = false;
						bg.antialiasing = true;
						bg.scrollFactor.set(0.1, 0.1);
						
						/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
						var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
						add(glitchSprite);*/
						
						var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('bob/nothappy_ground'));
						ground.updateHitbox();
						ground.active = false;
						ground.antialiasing = true;
						
	
						var deadron:FlxSprite = new FlxSprite(-700, 600).loadGraphic(Paths.image('bob/GoodHeDied'));
						deadron.updateHitbox();
						deadron.active = false;
						deadron.scale.x = 0.8;
						deadron.scale.y = 0.8;
						deadron.antialiasing = true;
						
						if (FlxG.save.data.bg){
							add(bg);
							add(ground);
							add(deadron);
						}
					}
				case 'ron':
					{
					defaultCamZoom = 0.9;
					curStage = 'ron';
					var bg:FlxSprite = new FlxSprite(-100,10).loadGraphic(Paths.image('bob/happyRon_sky'));
					bg.updateHitbox();
					bg.scale.x = 1.2;
					bg.scale.y = 1.2;
					bg.active = false;
					bg.antialiasing = true;
					bg.scrollFactor.set(0.1, 0.1);
					
					/*var glitchEffect = new FlxGlitchEffect(8,10,0.4,FlxGlitchDirection.HORIZONTAL);
					var glitchSprite = new FlxEffectSprite(bg, [glitchEffect]);
					add(glitchSprite);*/
					
					var ground:FlxSprite = new FlxSprite(-537, -250).loadGraphic(Paths.image('bob/happyRon_ground'));
					ground.updateHitbox();
					ground.active = false;
					ground.antialiasing = true;
					
					if (FlxG.save.data.bg){
						add(bg);
						add(ground);
					}
						
					}																								  		
				default:
				{
						if (SONG.song.toLowerCase () == 'fixel' || SONG.song.toLowerCase ()  == 'genesismk2'){
							defaultCamZoom = 0.9;
							curStage = 'stage';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('jamey/stageback'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('jamey/stagefront'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							
		
							var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('jamey/stagecurtains'));
							stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
							stageCurtains.updateHitbox();
							stageCurtains.antialiasing = true;
							stageCurtains.scrollFactor.set(1.3, 1.3);
							stageCurtains.active = false;
							if (FlxG.save.data.bg){
								add(bg);
								add(stageFront);
								add(stageCurtains);	
							}																			
						}
						else{
							defaultCamZoom = 0.9;
							curStage = 'stage';
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback', 'shared'));
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							
		
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront', 'shared'));
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							
		
							var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains', 'shared'));
							stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
							stageCurtains.updateHitbox();
							stageCurtains.scrollFactor.set(1.3, 1.3);
							stageCurtains.active = false;
							if (FlxG.save.data.bg){
								add(bg);
								add(stageFront);
								add(stageCurtains);	
							}
						}
				}
			}


		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-doki':
				gfVersion = 'gf-doki';
			case 'nogf-pixel':
				gfVersion = 'nogf-pixel';
			case 'whitty':
				gfVersion = 'gf-whitty';								
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'jamey1':
				camPos.x += 400;
				dad.y += 300;
			case 'jamey2':
				dad.y += 300;								
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'sonic':
				dad.x -= 130;
				dad.y += -50;
			case 'monika':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'duet':
				dad.x += 150;
				dad.y += 380;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'monika-angry':
				dad.x += 15;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'qt-meme':
				dad.y += 260;
			case 'qt_classic':
				dad.y += 255;
			case 'robot_classic' | 'robot_classic_404':
				dad.x += 110;
			case 'bob':
				camPos.x += 600;
				dad.y += 300;
			case 'gloop-bob':
				camPos.x += 600;
				dad.y += 300;
			case 'angrybob':
				camPos.x += 600;
				dad.y += 300;
			case 'hellbob':
				camPos.x += 600;
				dad.y += 350;
			case 'glitched-bob':
				camPos.x += 600;
				dad.y += 300;
			case 'ron':
				camPos.x -= 27;
				camPos.y += 268;
				dad.y += 268;
				dad.x -= 27;
			case 'little-man':
				camPos.x -= 124;
				camPos.y += 644;
				dad.x += 124;
				dad.y += 644;																
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}

				if (SONG.song.toLowerCase () == 'your demise'){
					dad.y -= 69;
					dad.x += 300;
					boyfriend.x += 200;
					boyfriend.y += 260;
					gf.x += 180;
					gf.y += 300;					
				}
				else{
					boyfriend.x += 200;
					boyfriend.y += 220;
					gf.x += 180;
					gf.y += 300;
				}
			case 'SONICstage':
				boyfriend.y += 25;
				dad.y += 200;
				dad.x += 200;
				dad.scale.x = 1.1;
				dad.scale.y = 1.1;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 100);
			case 'sonicFUNSTAGE':
				boyfriend.y += 340;
				boyfriend.x += 80;
				dad.y += 450;
				gf.y += 300;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);

			case 'LordXStage':
				dad.scale.x = 1.4;
				dad.scale.y = 1.4;
				dad.y += 50;
				boyfriend.y += 40;
				camPos.set(dad.getGraphicMidpoint().x + 200, dad.getGraphicMidpoint().y);
			case 'streetFinal' | 'streetCute' | 'street' | 'streetCute1':
				boyfriend.x += 40;
				boyfriend.y += 65;
				if(SONG.song.toLowerCase() == 'censory-overload' || SONG.song.toLowerCase() == 'termination'){
					dad.x -= 70;
					dad.y += 66;
	/*				boyfriend404.x += 40;
					boyfriend404.y += 65;
					dad404.x -= 70;
					dad404.y += 66; */
					
				}else if(SONG.song.toLowerCase() == 'terminate' || SONG.song.toLowerCase() == 'cessation'){
					dad.x -= 70;
					dad.y += 65;
				}								
		}
		if (FlxG.save.data.gf){
			add(gf);
			if (SONG.song.toLowerCase () == 'your demise'){
				gf.visible = false;
			}		
		}
		

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);
	/*	if(curStage == "nightmare"){
			dad.alpha=0;
			gf.alpha=0;
			add(boyfriend404);
		}

		if(SONG.song.toLowerCase() == 'censory-overload' || SONG.song.toLowerCase() == 'termination'){
			add(gf404);
			add(boyfriend404);
			add(dad404);
		} */

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set(); 		
		doof.finishThing = startCountdown;

		var doofmonika:dialogues.MonikaDialogueBox = new dialogues.MonikaDialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doofmonika.scrollFactor.set();
		doofmonika.finishThing = startCountdown;
		
		var doofjamey:dialogues.JameyDialogueBox = new dialogues.JameyDialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doofjamey.scrollFactor.set();
		doofjamey.finishThing = startCountdown;			

		var doofwhitty:dialogues.WhittyDialogueBox = new dialogues.WhittyDialogueBox(false, dialogue);
		doofwhitty.scrollFactor.set(); 
		doofwhitty.finishThing = startCountdown;

		var doofgarcello:dialogues.GarcelloDialogueBox = new dialogues.GarcelloDialogueBox(false, dialogue);
		doofgarcello.scrollFactor.set(); 
		doofgarcello.finishThing = startCountdown;		
	
		var doofmyra:dialogues.MyraDialogueBox = new dialogues.MyraDialogueBox(false, dialogue);
		doofmyra.scrollFactor.set();
		doofmyra.finishThing = startCountdown;		
		
		doof2 = new dialogues.MonikaDialogueBox(false, extra1);
		doof2.scrollFactor.set();
		doof2.finishThing = rosestart;

		doof3 = new dialogues.MonikaDialogueBox(false, extra2);
		doof3.scrollFactor.set();
		doof3.finishThing = demiseendtwotwo;

		doof4 = new dialogues.MonikaDialogueBox(false, extra3);
		doof4.scrollFactor.set();
		doof4.finishThing = endSong; //QTDialogueBox

		var doofQT:dialogues.QTDialogueBox = new dialogues.QTDialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doofQT.scrollFactor.set(); 		
		doofQT.finishThing = startCountdown;

		var doofBob:dialogues.BobDialogueBox = new dialogues.BobDialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doofBob.scrollFactor.set(); 		
		if (SONG.song.toLowerCase() == 'ron')
			{
				doofBob.finishThing = RonIntro2;
			}
			else
			{
				doofBob.finishThing = startCountdown;
			}	

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		if (curSong.toLowerCase() == 'too-slow')
			{
				FlxG.camera.follow(camFollow, LOCKON, 0.05 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		else if (curSong.toLowerCase() == 'endless')
			{
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		else if (curSong.toLowerCase() == 'execution')
			{
				FlxG.camera.follow(camFollow, LOCKON, 0.08 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		switch (curStage)
		{
			case 'SONICstage':
			healthBar.createFilledBar(FlxColor.fromRGB(0, 49, 173), 0xFF66FF33); //FlxColor.fromRGB(0, 49, 173)
			case 'sonicFUNSTAGE':
			healthBar.createFilledBar(FlxColor.fromRGB(60, 0, 138), 0xFF66FF33);//FlxColor.fromRGB(60, 0, 138)
			default:
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		}		
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		var creditTxt:FlxText = new FlxText(5, -30, (Main.watermarks ? "MegaMix By Kaique62" : ""), 20);
		creditTxt.scrollFactor.set();
		creditTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(creditTxt);

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD];
		doof3.cameras = [camHUD];
		doof4.cameras = [camHUD];
		doofwhitty.cameras = [camHUD];		
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}

		if (!FlxG.save.data.hud){
			camHUD.visible = false;
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			mcontrols.visible = false;

			add(mcontrols);
		#end

		if (curSong.toLowerCase() == 'termination' || curSong.toLowerCase() == 'cessation'){
			_pad = new ui.FlxVirtualPad(NONE, A);
			_pad.alpha = 0.75;
			this.add(_pad);
			}


		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		var playcut2:Bool = true;

		if (isStoryMode && FlxG.save.data.cutscenes)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'headache':
						var introText:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('garcello/garIntroText'));
						introText.setGraphicSize(Std.int(introText.width * 1.5));
						introText.scrollFactor.set();
						camHUD.visible = false;
	
						add(introText);
						FlxG.sound.playMusic(Paths.music('city_ambience'), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
	
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							// FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						
							new FlxTimer().start(3, function(tmr:FlxTimer)
							{
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										FlxG.sound.music.fadeOut(2.2, 0);
										remove(introText);
										camHUD.visible = true;
										garIntro(doofgarcello);
									}
								});
							});
						}); 
					case 'nerves':
						garIntro(doofgarcello);
					case 'release':
						garIntro(doofgarcello);
					case 'fading':
						garIntro(doofgarcello);
					case 'cackle':
						myraIntro(doofmyra);
					case 'bones':
						myraIntro(doofmyra);
					case 'mystic':
						myraIntro(doofmyra);
					case 'hocus-pocus':
						myraIntro(doofmyra);
					case 'high-school-conflict':
						monikaIntro(doofmonika);
					case 'bara-no-yume':
						monikaIntro(doof2);
					case 'your-demise':
						GFScary(doofmonika);
					case 'fixel':
						jameyIntro(doofjamey);
					case 'genesismk2':
						jameyIntro(doofjamey);
					case 'overbearing':
						jameyIntro(doofjamey);
					case 'lo-fight':
						trace('lo-fight animation');
						whittyAnimation(doofwhitty, false);
					case 'overhead':
						whittyAnimation(doofwhitty, false);
					case 'ballistic':
						whittyAnimation(doofwhitty, false);
				case 'carefree' | 'careless' | 'terminate':
						qtIntro(doofQT);
					case 'censory-overload':
						qtIntro(doofQT);
						case 'sunshine':
							bobIntro(doofBob);
						case 'withered':
							bobIntro(doofBob);
						case 'onslaught':
							var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
							add(blackScreen);
							blackScreen.scrollFactor.set();
							camHUD.visible = false;
		
							new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								remove(blackScreen);
								FlxG.sound.play(Paths.sound('Bob_Appear'));
								camFollow.x = dad.getMidpoint().x;
								camFollow.y = dad.getMidpoint().y;
								FlxG.camera.focusOn(camFollow.getPosition());
								FlxG.camera.zoom = 1.5;
		
								new FlxTimer().start(0.8, function(tmr:FlxTimer)
								{
									camHUD.visible = true;
									remove(blackScreen);
									FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
										ease: FlxEase.quadInOut,
										onComplete: function(twn:FlxTween)
										{
											var lol:dialogues.BobDialogueBox = new dialogues.BobDialogueBox(false, dialogue);
											lol.scrollFactor.set();
											lol.finishThing = startCountdown;
											add(lol);
											lol.cameras = [camHUD];
										}
									});
								});
							});
						case 'trouble':
							ONSLAUGHTIntro(doofBob);
						case 'run':
							bobIntro(doofBob);
						case 'ron':
							RonIntro(doofBob);																															
				default:
					startCountdown();
			}
		}
		else
			{
				if (SONG.stage == 'ballisticAlley')
					{
						if (FlxG.save.data.bg){
						wBg.alpha = 0;
						nwBg.alpha = 1;
						funneEffect = new FlxSprite(-600, -200).loadGraphic(Paths.image('thefunnyeffect', 'bonusWeek'));
						funneEffect.alpha = 0.5;
						funneEffect.scrollFactor.set();
						funneEffect.visible = true;
						add(funneEffect);
				
						funneEffect.cameras = [camHUD];

						trace('funne: ' + funneEffect);
						nwBg.animation.play("gameButMove");
						remove(wstageFront);
						}
					}				
				switch (curSong.toLowerCase())
				{
					case 'ballistic':
						turnToCrazyWhitty();
						startCountdown();
					default:
						startCountdown();
				}
			}

		if (!loadRep)
			rep = new Replay("na");

		deathBySawBlade = false;

		switch (curStage)
		{
			case 'hellstage':
				add(bobmadshake);
		}


		super.create();
	}
	function RonIntro(?dialogueBox:dialogues.BobDialogueBox) 
		{
			boyfriend.visible = false;
			gf.visible = false;
			dad.visible = false;
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			//camFollow.y = boyfriend.getMidpoint().y;
			camFollow.x = boyfriend.getMidpoint().x;
			FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
			{
				new FlxTimer().start(0.5, function(swagTimer:FlxTimer)
				{  
					boyfriend.visible = true;
					gf.visible = true;
					FlxG.sound.play(Paths.sound('pop'));
					new FlxTimer().start(1, function(swagTimer:FlxTimer)
					{  
						add(dialogueBox);
					});
				});
			});
		}
		function RonIntro2():Void
			{
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
				FlxG.sound.music.fadeIn(1, 0.5, 0);
				//camFollow.y = boyfriend.getMidpoint().y;
				camFollow.x = dad.getMidpoint().x;
				camFollow.y = dad.getMidpoint().y;
				new FlxTimer().start(1, function(swagTimer:FlxTimer)
				{  
					dad.visible = true;
					FlxG.sound.play(Paths.sound('Ron_Appear'));
					new FlxTimer().start(1, function(swagTimer:FlxTimer)
					{
						FlxG.sound.playMusic(Paths.music('Ron_Dialog'), 0.5);
						dialogue = CoolUtil.coolTextFile(Paths.txt('ron/ronAfterDialogue'));
						var lol:dialogues.BobDialogueBox = new dialogues.BobDialogueBox(false, dialogue);
						lol.scrollFactor.set();
						lol.finishThing = startCountdown;
						add(lol);
						lol.cameras = [camHUD];
					});
				});
			}
		function ONSLAUGHTIntro(?dialogueBox:dialogues.BobDialogueBox):Void
		{
			/*
			var RONDIESIHATERON:FlxSprite = new FlxSprite(600, 400);
			RONDIESIHATERON.frames = Paths.getSparrowAtlas('bob/cutscene/IHATERON');
			RONDIESIHATERON.animation.addByPrefix('idle', 'RonDied', 24,false);
			RONDIESIHATERON.animation.play('idle');
			RONDIESIHATERON.scrollFactor.set();
			RONDIESIHATERON.updateHitbox();
			RONDIESIHATERON.screenCenter();
			RONDIESIHATERON.scale.x = 1.12;
			RONDIESIHATERON.scale.y = 1.12;
			add(RONDIESIHATERON);
			FlxG.sound.play(Paths.sound('IHATERON'), 1, false, null, true, function()
				{
					remove(RONDIESIHATERON);
					FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
						{
							camHUD.visible = true;
							add(dialogueBox);
						}, true);
				});
			*/
			
			camHUD.visible = false;
	
			FlxG.camera.fade(FlxColor.BLACK, 1, true, function()
				{
					camHUD.visible = true;
					add(dialogueBox);
				}, true);
			
			// TSG TODO!!! MOVE THAT TO A FUCKING UHHHH ENDSONG SHIT OK?
		}
		function bobSpookyIntro() 
			{
				camHUD.visible = false;
				FlxG.camera.fade(FlxColor.BLACK, 0.2, true);
				var bobTransforms:FlxSprite = new FlxSprite(600, 400);
				bobTransforms.frames = Paths.getSparrowAtlas('bob/cutscene/bobSpooky');
				bobTransforms.animation.addByPrefix('idle', 'BobTransforms', 24,false);
				bobTransforms.animation.play('idle');
				bobTransforms.scrollFactor.set();
				bobTransforms.updateHitbox();
				bobTransforms.screenCenter();
				bobTransforms.scale.x = 1.2;
				bobTransforms.scale.y = 1.2;
				add(bobTransforms);
				FlxG.sound.play(Paths.sound('bobSpooky'), 1, false, null, true, function()
					{
						remove(bobTransforms);
						FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function()
						{
							camHUD.visible = true;
							startCountdown();
						}, true);
					});
			}	
	function turnToCrazyWhitty()
		{
	
			remove(iconP2);
			remove(iconP1);
			remove(healthBarBG);
			remove(healthBar);
	
			iconP2 = new HealthIcon('whittycrazy', false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
	
			iconP1 = new HealthIcon(SONG.player1, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
	
			add(healthBarBG);
			add(healthBar);
	
			add(iconP2);
			add(iconP1);
	
			iconP1.cameras = [camHUD];
			iconP2.cameras = [camHUD];
	
			healthBar.cameras = [camHUD];
			healthBarBG.cameras = [camHUD];
	
			remove(dad);
			remove(gf);
			dad = new Character(100,100,'whittycrazy');
			add(gf);
			add(dad);
	
			if (isStoryMode)
			{
				iconP1.visible = false;
				iconP2.visible = false;
			}
	
		}	
	function whittyAnimation(?whittydialogueBox:dialogues.WhittyDialogueBox, bside:Bool):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
			black.scrollFactor.set();
			var black2:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black2.scrollFactor.set();
			black2.alpha = 0;
			var black3:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black3.scrollFactor.set();
			if (curSong.toLowerCase() != 'ballistic')
				add(black);
	
			var epic:Bool = false;
			var white:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
			white.scrollFactor.set();
			white.alpha = 0;
	
			trace('what animation to play, hmmmm');
	
			var wat:Bool = true;
	
			trace('cur song: ' + curSong);
	
			switch(curSong.toLowerCase()) // WHITTY ANIMATION CODE LMAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
			{
				case   'ballistic-b-side' | 'ballistic':
					trace('funny ballistic!!!');
					add(white);
					trace(white);
					var noMore:Bool = false;
					inCutscene = true;
	
					var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('windLmao', 'shared'),true);
					var mBreak:FlxSound = new FlxSound().loadEmbedded(Paths.sound('micBreak', 'shared'));
					var mThrow:FlxSound = new FlxSound().loadEmbedded(Paths.sound('micThrow', 'shared'));
					var mSlam:FlxSound = new FlxSound().loadEmbedded(Paths.sound('slammin', 'shared'));
					var TOE:FlxSound = new FlxSound().loadEmbedded(Paths.sound('ouchMyToe', 'shared'));
					var soljaBOY:FlxSound = new FlxSound().loadEmbedded(Paths.sound('souljaboyCrank', 'shared'));
					var rumble:FlxSound = new FlxSound().loadEmbedded(Paths.sound('rumb', 'shared'));
	
					remove(dad);
					var animation:FlxSprite = new FlxSprite(-480,-100);
					animation.frames = Paths.getSparrowAtlas('cuttinDeezeBalls', 'bonusWeek');
					animation.animation.addByPrefix('startup', 'Whitty Ballistic Cutscene', 24, false);
					animation.antialiasing = true;
					add(animation);
	
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
	
					remove(funneEffect);
	
					wind.fadeIn();
					camHUD.visible = false;
	
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							// animation
	
							if (!wat)
								{
									tmr.reset(1.5);
									wat = true;
								}
							else
							{
	
							
							if (animation.animation.curAnim == null) // check thingy go BEE BOOP
								{
									animation.animation.play('startup'); // if beopoe then make go BEP
									trace('start ' + animation.animation.curAnim.name);
								}
							if (!animation.animation.finished && animation.animation.curAnim.name == 'startup') // beep?
							{
								tmr.reset(0.01); // fuck
								noMore = true; // fuck outta here animation
								trace(animation.animation.frameIndex);
								switch(animation.animation.frameIndex)
								{
									case 87:
										if (!mThrow.playing)
											mThrow.play();
									case 86:
										if (!mSlam.playing)
											mSlam.play();
							case 128:
							if (!soljaBOY.playing)
								{
									soljaBOY.play();
									if (FlxG.save.data.bg)	{
										remove(wstageFront);
										nwBg.alpha = 1;
										wBg.alpha = 0;
										nwBg.animation.play('gaming');
									}
									camFollow.camera.shake(0.01, 3);
								}											
									case 123:
										if (!rumble.playing)
											rumble.play();
									case 135:
										camFollow.camera.stopFX();
									case 158:
										if (!TOE.playing)
										{
											TOE.play();
											camFollow.camera.stopFX();
											camFollow.camera.shake(0.03, 6);
										}
									case 52:
										if (!mBreak.playing)
											{
												mBreak.play();
											}
								}
							}
							else
							{
								// white screen thingy
	
								camFollow.camera.stopFX();
	
								if (white.alpha < 1 && !epic)
								{
									white.alpha += 0.4;
									tmr.reset(0.1);
								}
								else
								{
									if (!epic)
										{
											epic = true;
											trace('epic ' + epic);
											turnToCrazyWhitty();
											remove(animation);
											TOE.fadeOut();
											tmr.reset(0.1);
											if (FlxG.save.data.bg){
												nwBg.animation.play("gameButMove");
											}
										}
									else
										{
											if (white.alpha != 0)
												{
	
													white.alpha -= 0.1;
													tmr.reset(0.1);
												}
											else 
											{
												if (whittydialogueBox != null)
													{
														camHUD.visible = true;
														wind.fadeOut();
														healthBar.visible = false;
														healthBarBG.visible = false;
														scoreTxt.visible = false;
														iconP1.visible = false;
														iconP2.visible = false;
														add(whittydialogueBox);
													}
													else
													{
														startCountdown();
													}
													remove(white);
											}
										}
								}
							}
						}
						});
				case 'lo-fight' | 'lo-fight-b-side':
					trace('funny lo-fight!!!');
					inCutscene = true;
					remove(dad);
					var animation:FlxSprite = new FlxSprite(-290,-100);
					animation.frames = Paths.getSparrowAtlas('whittyCutscene','bonusWeek');
					animation.animation.addByPrefix('startup', 'Whitty Cutscene Startup ', 24, false);
					animation.antialiasing = true;
					add(animation);
					black2.visible = true;
					black3.visible = true;
					add(black2);
					add(black3);
					black2.alpha = 0;
					black3.alpha = 0;
					trace(black2);
					trace(black3);
	
					var city:FlxSound = new FlxSound().loadEmbedded(Paths.sound('city', 'shared'), true);
					var rip:FlxSound = new FlxSound().loadEmbedded(Paths.sound('rip', 'shared'));
					var fire:FlxSound = new FlxSound().loadEmbedded(Paths.sound('fire', 'shared'));
					var BEEP:FlxSound = new FlxSound().loadEmbedded(Paths.sound('beepboop', 'shared'));
					city.fadeIn();
					camFollow.setPosition(dad.getMidpoint().x + 40, dad.getMidpoint().y - 180);
	
					camHUD.visible = false;
	
					gf.y = 90000000;
					boyfriend.x += 314;
	
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
	
							if (!wat)
								{
									tmr.reset(3);
									wat = true;
								}
							else
							{
							// animation
	
							black.alpha -= 0.15;
				
							if (black.alpha > 0)
							{
								tmr.reset(0.3);
							}
							else
							{
	
								if (animation.animation.curAnim == null)
									animation.animation.play('startup');
	
								if (!animation.animation.finished)
									{
										tmr.reset(0.01);
										trace('animation at frame ' + animation.animation.frameIndex);
	
										switch(animation.animation.frameIndex)
										{
											case 0:
												trace('play city sounds');
											case 41:
												trace('fire');
												if (!fire.playing)
													fire.play();
											case 34:
												trace('paper rip');
												if (!rip.playing)
													rip.play();
											case 147:
												trace('BEEP');
												if (!BEEP.playing)
													{
														camFollow.setPosition(dad.getMidpoint().x + 460, dad.getMidpoint().y - 100);
														BEEP.play();
														boyfriend.playAnim('singLEFT', true);
													}
											case 154:
												if (boyfriend.animation.curAnim.name != 'idle')
													boyfriend.playAnim('idle');
										}
									}
								else
								{
									// CODE LOL!!!!
									if (black2.alpha != 1)
									{
										black2.alpha += 0.4;
										tmr.reset(0.1);
										trace('increase blackness lmao!!!');
									}
									else
									{
										if (black2.alpha == 1 && black2.visible)
											{
												black2.visible = false;
												black3.alpha = 1;
												trace('transision ' + black2.visible + ' ' + black3.alpha);
												remove(animation);
												add(dad);
												gf.y = 140;
												boyfriend.x -= 314;
												camHUD.visible = true;
												tmr.reset(0.3);
											}
										else if (black3.alpha != 0)
											{
												black3.alpha -= 0.1;
												tmr.reset(0.3);
												trace('decrease blackness lmao!!!');
											}
											else 
											{
														if (whittydialogueBox != null)
														{
															add(whittydialogueBox);
															city.fadeOut();
														}
														else
														{
															startCountdown();
														}
													remove(black);
											}
									}
								}
							}
						}
						});
				default:
					trace('funny *goat looking at camera*!!!');
					new FlxTimer().start(0.3, function(tmr:FlxTimer)
						{
	
							if (!wat)
								{
									tmr.reset(3);
									wat = true;
								}
	
							black.alpha -= 0.15;
				
							if (black.alpha > 0)
							{
								tmr.reset(0.3);
							}
							else
							{
			
								if (whittydialogueBox != null)
									{
										inCutscene = true;
										add(whittydialogueBox);
									}
								remove(black);
							}
						});
				
			}
	
	
	
		}	
	function GFScary(?dialogueBox:dialogues.MonikaDialogueBox):Void
		{
			camHUD.visible = false;
			inCutscene = true;
			var GFFakeout:FlxSprite = new FlxSprite();
			GFFakeout.frames = Paths.getSparrowAtlas('GF_Fakeout_Cryemoji');
			GFFakeout.animation.addByPrefix('idle', 'GFFakeout', 24, false);
			GFFakeout.setGraphicSize(Std.int(GFFakeout.width * 1.12));
			GFFakeout.scrollFactor.set();
			GFFakeout.updateHitbox();
			GFFakeout.screenCenter();
	
			// Variables from the default evilSchool stage
			var schoolFakeout:FlxSprite = new FlxSprite(400, 200);
			schoolFakeout.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
			schoolFakeout.animation.addByPrefix('idle', 'background 2', 24);
			schoolFakeout.animation.play('idle');
			schoolFakeout.scrollFactor.set(0.8, 0.9);
			schoolFakeout.scale.set(6, 6);
			add(schoolFakeout);
			FlxG.sound.play(Paths.sound('awhellnaw'));	// THEY ON THAT SPUNCHBOB SHIT
	
			new FlxTimer().start(1.3, function(timer:FlxTimer) {
				FlxG.sound.play(Paths.sound('GFFakeout'));
				add(GFFakeout);
				GFFakeout.animation.play('idle');
			});
			
			new FlxTimer().start(23.3, function(swagTimer:FlxTimer) 
				{
					remove(schoolFakeout);
					remove(GFFakeout);
					FlxG.camera.zoom = defaultCamZoom;
					remove(gf);
					// I know this looks messy, but it works 
					boyfriend.visible = false;
					dad.visible = false;
					healthBar.visible = false;
					healthBarBG.visible = false;
					kadeEngineWatermark.visible = false;
					add(whiteflash);
					add(blackScreen);
					new FlxTimer().start(2, function(godlike:FlxTimer)
						{
							if (dialogueBox != null)
								{
									kadeEngineWatermark.visible = true;
									healthBar.visible = true;
									healthBarBG.visible = true;
									camHUD.visible = true;
									inCutscene = true;
									add(dialogueBox);
								}
								else
									{
										startCountdown();
									}
						});
				});
		}	
	
		function DarkStart(?dialogueBox:dialogues.MonikaDialogueBox):Void
			{
				add(whiteflash);
				add(blackScreen);
				remove(gf);
				startCountdown();
			}
			
		function roseend(?dialogueBox:dialogues.MonikaDialogueBox):Void
			{
				inCutscene = true;
				startedCountdown = false;
				generatedMusic = false;
				canPause = false;
				vocals.stop();
				FlxG.sound.music.stop();
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				if (dialogueBox != null)
					{
						// I didn't wanna make all these invisible but for some god forsaken reason,
						// the end dialogue started having the same fucking issues as the beginning dialogue.
						strumLineNotes.visible = false;
						scoreTxt.visible = false;
						healthBarBG.visible = false;
						healthBar.visible = false;
						iconP1.visible = false;
						iconP2.visible = false;
						kadeEngineWatermark.visible = false;
						camFollow.setPosition(dad.getMidpoint().x + 50, boyfriend.getMidpoint().y - 300);
						add(dialogueBox);
					}
				else
					{
				endSong();
					}
				trace(inCutscene);
			}
		
		function rosestart():Void
			{
				dad.playAnim('cutscenetransition');
				new FlxTimer().start(1.2, function(godlike:FlxTimer)
				{
					dad.playAnim('idle');
					startCountdown();
				});
			}
	
		function demiseend(?dialogueBox:dialogues.MonikaDialogueBox):Void
			{
				camZooming = false;
				inCutscene = true;
				startedCountdown = false;
				generatedMusic = false;
				canPause = false;
				FlxG.sound.music.pause();
				vocals.pause();
				vocals.stop();
				FlxG.sound.music.stop();
				remove(strumLineNotes);
				remove(scoreTxt);
				remove(healthBarBG);
				remove(healthBar);
				remove(iconP1);
				remove(iconP2);
				remove(kadeEngineWatermark);
				camFollow.setPosition(dad.getMidpoint().x + 100, boyfriend.getMidpoint().y - 250);
				if (dialogueBox != null)
					{
						add(dialogueBox);
					}
				else
					{
						demiseendtwo(doof4);
					}
					trace(inCutscene);
			}
	
	
			function demiseendtwotwo():Void
				{
					var endsceneone:FlxSprite = new FlxSprite();
					endsceneone.frames = Paths.getSparrowAtlas('Funnicutscene/End1');
					endsceneone.animation.addByPrefix('idle', 'Endscene', 24, false);
					endsceneone.setGraphicSize(Std.int(endsceneone.width * 1.12));
					endsceneone.scrollFactor.set();
					endsceneone.updateHitbox();
					endsceneone.screenCenter();
	
					paused = true;
	
					FlxG.sound.playMusic(Paths.music('cutscene_jargon_shmargon'), 0);
					FlxG.sound.music.fadeIn(.5, 0, 0.8);
					FlxG.camera.fade(FlxColor.WHITE, 0, false);
					camHUD.visible = false;
					add(endsceneone);
					endsceneone.animation.play('idle');
					FlxG.camera.fade(FlxColor.WHITE, 1, true, function(){}, true);
	
					new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('dah'));
						});
	
					new FlxTimer().start(3.8, function(swagTimer:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.BLACK, 2, false);
							new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
								{
									remove(endsceneone);
									demiseendtwo(doof4);
								});
						});
	
				}
	
			function demiseendtwo(?dialogueBox:dialogues.MonikaDialogueBox):Void
				{
					var endscenetwo:FlxSprite = new FlxSprite();
					endscenetwo.frames = Paths.getSparrowAtlas('Funnicutscene/monikasenpaistanding');
					endscenetwo.animation.addByPrefix('idle', 'Endscenetwo', 24, false);
					endscenetwo.setGraphicSize(Std.int(endscenetwo.width * 1.12));
					endscenetwo.scrollFactor.set();
					endscenetwo.updateHitbox();
					endscenetwo.screenCenter();
					
							new FlxTimer().start(3, function(swagTimer:FlxTimer)
								{
									add(endscenetwo);
									endscenetwo.animation.play('idle');
									FlxG.camera.fade(FlxColor.BLACK, 3, true, function()
										{
											if (dialogueBox != null)
												{
													camHUD.visible = true;
													camFollow.setPosition(dad.getMidpoint().x + 100, boyfriend.getMidpoint().y - 250);
													add(dialogueBox);
												}
											else
												{
													endSong();
												}
									}, true);
								});
				}
				
	function doStaticSign(lestatic:Int = 0)
		{
			trace ('static MOMENT HAHAHAH ' + lestatic );
			var daStatic:FlxSprite = new FlxSprite(0, 0);
	
			daStatic.frames = Paths.getSparrowAtlas('daSTAT', 'exe');
	
			daStatic.setGraphicSize(FlxG.width, FlxG.height);
			
			
			daStatic.screenCenter();
	
			daStatic.cameras = [camHUD];
	
			switch(lestatic)
			{
				case 0:
					daStatic.animation.addByPrefix('static','staticFLASH',24, false);
			}
			add(daStatic);

			FlxG.sound.play(Paths.sound('staticBUZZ'));

			if (daStatic.alpha != 0)
				daStatic.alpha = FlxG.random.float(0.1, 0.5);

			daStatic.animation.play('static');

			daStatic.animation.finishCallback = function(pog:String)
			{
				trace('ended static');
				remove(daStatic);
			}
		}
	
		function staticHitMiss()
			{
				trace ('lol you missed the static note!');
	
				var daNoteStatic:FlxSprite = new FlxSprite(0,0);
	
				daNoteStatic.frames = Paths.getSparrowAtlas('hitStatic', 'exe');
	
				daNoteStatic.setGraphicSize(FlxG.width, FlxG.height);
	
				daNoteStatic.screenCenter();
				
				daNoteStatic.cameras = [camHUD];
	
				daNoteStatic.animation.addByPrefix('static','staticANIMATION', 24, false);
	
	
				daNoteStatic.animation.play('static');
	
				shakeCam2 = true;
	
				new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						shakeCam2 = false;
					});
	
	
				FlxG.sound.play(Paths.sound("hitStatic1"));
	
				add(daNoteStatic);
	
				daNoteStatic.animation.finishCallback = function(pog:String)
					{
						trace('ended HITSTATICLAWL');
						remove(daNoteStatic);
					}
			}

	function doSimpleJump()
		{
			trace ('SIMPLE JUMPSCARE');

			var simplejump:FlxSprite = new FlxSprite().loadGraphic(Paths.image('simplejump', 'exe'));
		
			simplejump.setGraphicSize(FlxG.width, FlxG.height);
				
				
			simplejump.screenCenter();
		
			simplejump.cameras = [camHUD];

			FlxG.camera.shake(0.0025, 0.50);

				
			add(simplejump);
	
			FlxG.sound.play(Paths.sound('sppok', 'exe'), 1);
	
			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				trace('ended simple jump');
				remove(simplejump);
			});

			//now for static

			var daStatic:FlxSprite = new FlxSprite(0, 0);
	
			daStatic.frames = Paths.getSparrowAtlas('daSTAT');
	
			daStatic.setGraphicSize(FlxG.width, FlxG.height);
			
			
			daStatic.screenCenter();
	
			daStatic.cameras = [camHUD];

			daStatic.animation.addByPrefix('static','staticFLASH',24, false);

			add(daStatic);

			FlxG.sound.play(Paths.sound('staticBUZZ'));

			if (daStatic.alpha != 0)
				daStatic.alpha = FlxG.random.float(0.1, 0.5);

			daStatic.animation.play('static');

			daStatic.animation.finishCallback = function(pog:String)
			{
				trace('ended static');
				remove(daStatic);
			}

		}

	function doJumpscare()
		{
			trace ('JUMPSCARE aaaa');
			
			
	
			daJumpscare.frames = Paths.getSparrowAtlas('sonicJUMPSCARE', 'exe');
			daJumpscare.animation.addByPrefix('jump','sonicSPOOK',24, false);
			
			daJumpscare.screenCenter();

			daJumpscare.scale.x = 1.1;
			daJumpscare.scale.y = 1.1;

			daJumpscare.y += 370;

	
			daJumpscare.cameras = [camHUD];

			FlxG.sound.play(Paths.sound('jumpscare', 'exe'), 1);
			FlxG.sound.play(Paths.sound('datOneSound', 'exe'), 1);
	
			add(daJumpscare);

			daJumpscare.animation.play('jump');

			daJumpscare.animation.finishCallback = function(pog:String)
			{
				trace('ended jump');
				remove(daJumpscare);
			}
		}
		function myraIntro(?dialogueBox:dialogues.MyraDialogueBox):Void
			{
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
		
				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();
		
				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();
		
				// pre lowercasing the song name (schoolIntro)
				var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
				if (songLowercase == 'roses' || songLowercase == 'thorns')
				{
					remove(black);
		
					if (songLowercase == 'thorns')
					{
						add(red);
					}
				}
		
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
							inCutscene = true;
		
							if (songLowercase == 'thorns')
							{
								add(senpaiEvil);
								senpaiEvil.alpha = 0;
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									senpaiEvil.alpha += 0.15;
									if (senpaiEvil.alpha < 1)
									{
										swagTimer.reset();
									}
									else
									{
										senpaiEvil.animation.play('idle');
										FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
										{
											remove(senpaiEvil);
											remove(red);
											FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
											{
												add(dialogueBox);
											}, true);
										});
										new FlxTimer().start(3.2, function(deadTime:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
										});
									}
								});
							}
							else
							{
								add(dialogueBox);
							}
						}
						else
							startCountdown();
		
						remove(black);
					}
				});
			}
	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (songLowercase == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}
	function bobIntro(?dialogueBox:dialogues.BobDialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			var senpaiEvil:FlxSprite = new FlxSprite();
			senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
			senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
			senpaiEvil.scrollFactor.set();
			senpaiEvil.updateHitbox();
			senpaiEvil.screenCenter();
			//bob :)
				
				var bg:FlxSprite = new FlxSprite( -100);
				bg.frames = Paths.getSparrowAtlas('bob/cutscene/sky');
				bg.animation.addByPrefix('shake', 'sky shake', 24, false);
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
					
				var ground:FlxSprite = new FlxSprite(-537, -158);
				ground.frames = Paths.getSparrowAtlas('bob/cutscene/ground');
				ground.animation.addByPrefix('shake', 'ground shake', 24, false);
				ground.updateHitbox();
				ground.antialiasing = true;
				
				var bobCut:FlxSprite = new FlxSprite(126, 361);
				bobCut.frames = Paths.getSparrowAtlas('bob/cutscene/BobCutscene');
				bobCut.animation.addByPrefix('start', 'bob mad', 24, false);
				bobCut.updateHitbox();
				bobCut.antialiasing = true;
				
				var bfCut:FlxSprite = new FlxSprite(770, 450);
				bfCut.frames = Paths.getSparrowAtlas('BOYFRIEND');
				bfCut.animation.addByPrefix('idle', 'BF idle dance', 24, true);
				bfCut.updateHitbox();
				bfCut.antialiasing = true;
				
				var gfCut:FlxSprite = new FlxSprite(400, 130);
				gfCut.frames = Paths.getSparrowAtlas('GF_assets');
				gfCut.animation.addByIndices('idle', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				gfCut.updateHitbox();
				gfCut.antialiasing = true;
				
				screenBudget = new FlxSprite(0, 0).loadGraphic(Paths.image('bob/cutscene/screen'));
				screenBudget.screenCenter();
				screenBudget.antialiasing = true;
				screenBudget.scrollFactor.set(0, 0);
				
					
			//not bob :(
			if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'run')
			{
				remove(black);
	
				if (SONG.song.toLowerCase() == 'thorns')
				{
					add(red);
				}
				if (SONG.song.toLowerCase() == 'run')
				{
					camHUD.visible = false;
					add(bg);
					add(ground);
					add(gfCut);
					add(bobCut);
					add(bfCut);
					bfCut.animation.play('idle');
					gfCut.animation.play('idle');
				}
			}

			new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
							inCutscene = true;
		
							if (SONG.song.toLowerCase() == 'thorns')
							{
								add(senpaiEvil);
								senpaiEvil.alpha = 0;
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									senpaiEvil.alpha += 0.15;
									if (senpaiEvil.alpha < 1)
									{
										swagTimer.reset();
									}
									else
									{
										senpaiEvil.animation.play('idle');
										FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
										{
											remove(senpaiEvil);
											remove(red);
											FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
											{
												add(dialogueBox);
											}, true);
										});
										new FlxTimer().start(3.2, function(deadTime:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
										});
									}
								});
							}
							else if (SONG.song.toLowerCase() == 'run')
							{
								//FlxG.camera.fade(FlxColor.BLACK, 1.3, true);
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									//FlxG.camera.focusOn(new(126, 361));
									camFollow.y = bobCut.getMidpoint().y;
									camFollow.x = bobCut.getMidpoint().x;
									//FlxG.camera.focusOn(camFollow.getPosition());
									FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
									FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5);
									FlxG.sound.play(Paths.sound('OhScary'));
									bobCut.animation.play('start');
									new FlxTimer().start(3.8, function(swagTimer:FlxTimer)
									{
										remove(bg);
										remove(ground);
										remove(gfCut);
										remove(bobCut);
										remove(bfCut);
										add(screenBudget);
										FlxG.sound.playMusic(Paths.music('NoBudgedSad'));
										new FlxTimer().start(5, function(swagTimer:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.BLACK, 0.01, true, function()
											{
												camHUD.visible = true;
												add(dialogueBox);
											}, true);
										});
									});
									new FlxTimer().start(2.7, function(swagTimer:FlxTimer)
									{  
										bg.animation.play('shake');
										ground.animation.play('shake');
									});
								});
							}
							else
							{
								add(dialogueBox);
							}
						}
						else
							startCountdown();
		
						remove(black);
					}
				});
			}
	function qtIntro(?dialogueBox:dialogues.QTDialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-300, -100).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			black.scrollFactor.set();
	
			FlxG.log.notice(qtCarelessFin);
			if(!qtCarelessFin)
			{
				add(black);
			}
			else
			{
				FlxTween.tween(FlxG.camera, {x: 0, y:0}, 1.5, {
					ease: FlxEase.quadInOut
				});
			}
	
			trace(cutsceneSkip);
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			var senpaiEvil:FlxSprite = new FlxSprite();
			var horrorStage:FlxSprite = new FlxSprite();
			if(!cutsceneSkip){
				if(SONG.song.toLowerCase() == 'censory-overload'){
					camHUD.visible = false;
					//BG
					horrorStage.frames = Paths.getSparrowAtlas('stage/horrorbg', 'qt');
					horrorStage.animation.addByPrefix('idle', 'Symbol 10 instance ', 24, false);
					horrorStage.antialiasing = true;
					horrorStage.scrollFactor.set();
					horrorStage.screenCenter();
	
					//QT sprite
					senpaiEvil.frames = Paths.getSparrowAtlas('cutscenev3', 'qt');
					senpaiEvil.animation.addByPrefix('idle', 'final_edited', 24, false);
					senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 0.875));
					senpaiEvil.scrollFactor.set();
					senpaiEvil.updateHitbox();
					senpaiEvil.screenCenter();
					senpaiEvil.x -= 140;
					senpaiEvil.y -= 55;
				}else{
					senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
					senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
					senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
					senpaiEvil.scrollFactor.set();
					senpaiEvil.updateHitbox();
					senpaiEvil.screenCenter();
				}
			}
			if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
			{
				remove(black);
	
				if (SONG.song.toLowerCase() == 'thorns')
				{
					add(red);
				}
			}
			else if (SONG.song.toLowerCase() == 'censory-overload' && !cutsceneSkip)
			{
				add(horrorStage);
			}
	
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.3);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
	
						if (SONG.song.toLowerCase() == 'censory-overload' && !cutsceneSkip)
						{
							//Background old
							//var horrorStage:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/horrorbg'));
							//horrorStage.antialiasing = true;
							//horrorStage.scrollFactor.set();
							//horrorStage.y-=125;
							//add(horrorStage);
							add(senpaiEvil);
							senpaiEvil.alpha = 0;
							new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
							{
								senpaiEvil.alpha += 0.15;
								if (senpaiEvil.alpha < 1)
								{
									swagTimer.reset();
								}
								else
								{
									senpaiEvil.animation.play('idle');
									horrorStage.animation.play('idle');
									FlxG.sound.play(Paths.sound('music-box-horror', 'qt'), 0.9, false, null, true, function()
									{
										remove(senpaiEvil);
										remove(red);
										remove(horrorStage);
										camHUD.visible = true;
										FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
										{
											add(dialogueBox);
										}, true);
									});
									new FlxTimer().start(13, function(deadTime:FlxTimer)
									{
										FlxG.camera.fade(FlxColor.WHITE, 3, false);
									});
								}
							});
						}
						else if (SONG.song.toLowerCase() == 'thorns'  && !cutsceneSkip)
						{
							add(senpaiEvil);
							senpaiEvil.alpha = 0;
							new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
							{
								senpaiEvil.alpha += 0.15;
								if (senpaiEvil.alpha < 1)
								{
									swagTimer.reset();
								}
								else
								{
									senpaiEvil.animation.play('idle');
									FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
									{
										remove(senpaiEvil);
										remove(red);
										FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
										{
											add(dialogueBox);
										}, true);
									});
									new FlxTimer().start(3.2, function(deadTime:FlxTimer)
									{
										FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
									});
								}
							});
						}
						else
						{
							add(dialogueBox);
						}
					}
					else
						if(!qtCarelessFin)
						{
							startCountdown();
						}
						else
						{
							loadSongHazard();
						}
	
					remove(black);
				}
			});
		}		
	function jameyIntro(?dialogueBox:dialogues.JameyDialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			var senpaiEvil:FlxSprite = new FlxSprite();
			senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
			senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
			senpaiEvil.scrollFactor.set();
			senpaiEvil.updateHitbox();
			senpaiEvil.screenCenter();
	
			// pre lowercasing the song name (schoolIntro)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}
			if (songLowercase == 'roses' || songLowercase == 'thorns')
			{
				remove(black);
	
				if (songLowercase == 'thorns')
				{
					add(red);
				}
			}
	
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.3);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
	
						if (songLowercase == 'thorns')
						{
							add(senpaiEvil);
							senpaiEvil.alpha = 0;
							new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
							{
								senpaiEvil.alpha += 0.15;
								if (senpaiEvil.alpha < 1)
								{
									swagTimer.reset();
								}
								else
								{
									senpaiEvil.animation.play('idle');
									FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
									{
										remove(senpaiEvil);
										remove(red);
										FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
										{
											add(dialogueBox);
										}, true);
									});
									new FlxTimer().start(3.2, function(deadTime:FlxTimer)
									{
										FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
									});
								}
							});
						}
						else
						{
							add(dialogueBox);
						}
					}
					else
						startCountdown();
	
					remove(black);
				}
			});
		}
		function monikaIntro(?dialogueBox:dialogues.MonikaDialogueBox):Void
			{
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
		
				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();
		
				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();
		
				// pre lowercasing the song name (schoolIntro)
				var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
				if (songLowercase == 'roses' || songLowercase == 'thorns')
				{
					remove(black);
		
					if (songLowercase == 'thorns')
					{
						add(red);
					}
				}
		
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
							inCutscene = true;
		
							if (songLowercase == 'thorns')
							{
								add(senpaiEvil);
								senpaiEvil.alpha = 0;
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									senpaiEvil.alpha += 0.15;
									if (senpaiEvil.alpha < 1)
									{
										swagTimer.reset();
									}
									else
									{
										senpaiEvil.animation.play('idle');
										FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
										{
											remove(senpaiEvil);
											remove(red);
											FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
											{
												add(dialogueBox);
											}, true);
										});
										new FlxTimer().start(3.2, function(deadTime:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
										});
									}
								});
							}
							else
							{
								add(dialogueBox);
							}
						}
						else
							startCountdown();
		
						remove(black);
					}
				});
			}				
	function garIntro(?garcellodialogueBox:dialogues.GarcelloDialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			red.scrollFactor.set();
	
			var sexycutscene:FlxSprite = new FlxSprite();
			sexycutscene.antialiasing = true;
			sexycutscene.frames = Paths.getSparrowAtlas('garcello/GAR_CUTSCENE');
			sexycutscene.animation.addByPrefix('video', 'garcutscene', 15, false);
			sexycutscene.setGraphicSize(Std.int(sexycutscene.width * 2));
			sexycutscene.scrollFactor.set();
			sexycutscene.updateHitbox();
			sexycutscene.screenCenter();
	
			if (SONG.song.toLowerCase() == 'nerves' || SONG.song.toLowerCase() == 'release')
			{
				remove(black);
	
				if (SONG.song.toLowerCase() == 'release')
				{
					add(red);
				}
			}
	
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.1);
				}
				else
				{
					if (garcellodialogueBox != null)
					{
						inCutscene = true;
	
						if (SONG.song.toLowerCase() == 'release')
						{
							camHUD.visible = false;
							add(red);
							add(sexycutscene);
							sexycutscene.animation.play('video');
	
							FlxG.sound.play(Paths.sound('Garcello_Dies'), 1, false, null, true, function()
								{
									remove(red);
									remove(sexycutscene);
									FlxG.sound.play(Paths.sound('Wind_Fadeout'));
	
									FlxG.camera.fade(FlxColor.WHITE, 5, true, function()
									{
										add(garcellodialogueBox);
										camHUD.visible = true;
									}, true);
								});
						}
						else
						{
							add(garcellodialogueBox);
						}
					}
					else
						startCountdown();
	
					remove(black);
				}
			});
		}
	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	public static var luaModchart:ModchartState = null;

	function three():Void
		{
			var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('three', 'shared'));
			three.scrollFactor.set();
			three.updateHitbox();
			three.screenCenter();
			three.y -= 100;
			three.alpha = 0.5;
					add(three);
					FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							three.destroy();
						}
					});
		}

	function two():Void
		{
			var two:FlxSprite = new FlxSprite().loadGraphic(Paths.image('two', 'shared'));
			two.scrollFactor.set();
			two.screenCenter();
			two.y -= 100;
			two.alpha = 0.5;
					add(two);
					FlxTween.tween(two, {y: two.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							two.destroy();
						}
					});
					
		}

		function one():Void
			{
				var one:FlxSprite = new FlxSprite().loadGraphic(Paths.image('one', 'shared'));
				one.scrollFactor.set();
				one.screenCenter();
				one.y -= 100;
				one.alpha = 0.5;

						add(one);
						FlxTween.tween(one, {y: one.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								one.destroy();
							}
						});
						
			}
	
	function gofun():Void
		{
			var gofun:FlxSprite = new FlxSprite().loadGraphic(Paths.image('gofun', 'shared'));
			gofun.scrollFactor.set();

			gofun.updateHitbox();

			gofun.screenCenter();
			gofun.y -= 100;
			gofun.alpha = 0.5;

					add(gofun);
					FlxTween.tween(gofun, {y: gofun.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							gofun.destroy();
						}
					});
		}


	function startCountdown():Void
	{
		if (SONG.song.toLowerCase() == 'run' && screenBudget != null)
			{
				FlxTween.tween(screenBudget, {alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(screenBudget);
							}
						});
			}
		#if mobileC
		mcontrols.visible = true;	
		#end
		if (curSong.toLowerCase() == 'termination' || curSong.toLowerCase() == 'cessation'){
		_pad.visible = true;
		}

		var theThing = curSong.toLowerCase();
		var doesitTween:Bool = if (theThing == 'endless') true else false;
		
		inCutscene = false;

		healthBar.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;
		healthBarBG.visible = true;
		scoreTxt.visible = true;


		generateStaticArrows(0);
		generateStaticArrows(1);


		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}


		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var theFunneNumber:Float = 1;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		bfCanDodge = true;
		hazardRandom = FlxG.random.int(1, 5);
		/*if(curSong.toLowerCase() == 'tutorial'){ //Change this so that they appear when the relevant function is first called!!!!
			add(kb_attack_alert);
			add(kb_attack_saw);
		}*/

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = songOutro;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
	
				if (daSection == 58 && curSong.toLowerCase() == 'endless') SONG.noteStyle = 'majinNOTES';

				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1] % 4);
					
					var gottaHitNote:Bool = section.mustHitSection;
	
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
	
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
					
					var daType = songNotes[3];
					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					swagNote.sustainLength = songNotes[2];
					
					swagNote.scrollFactor.set(0, 0);
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else
					{
					}
				}
				daBeats += 1;
			}
	
			// trace(unspawnNotes.length);
			// playerCounter += 1;
	
			unspawnNotes.sort(sortByShit);
	
			generatedMusic = true;
		}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function removeStatics()
		{
			playerStrums.forEach(function(todel:FlxSprite)
				{
					playerStrums.remove(todel);
					todel.destroy();
				});
			cpuStrums.forEach(function(todel:FlxSprite)
			{
				cpuStrums.remove(todel);
				todel.destroy();
			});
			strumLineNotes.forEach(function(todel:FlxSprite)
			{
				strumLineNotes.remove(todel);
				todel.destroy();
			});
		}

		private function generateStaticArrows(player:Int):Void
			{
				for (i in 0...4)
				{
					// FlxG.log.add(i);
					var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
		
					switch (SONG.noteStyle)
					{
						case 'pixel':
							if (FlxG.save.data.circle){
								babyArrow.frames = Paths.getSparrowAtlas('notes/CIRCLE_NOTE_assets-pixels', 'shared');			
							}
							else{
								babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
							}
							babyArrow.animation.add('green', [6]);
							babyArrow.animation.add('red', [7]);
							babyArrow.animation.add('blue', [5]);
							babyArrow.animation.add('purplel', [4]);
		
							babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
							babyArrow.updateHitbox();
							babyArrow.antialiasing = false;
		
							switch (Math.abs(i))
							{
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.add('static', [0]);
									babyArrow.animation.add('pressed', [4, 8], 12, false);
									babyArrow.animation.add('confirm', [12, 16], 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.add('static', [1]);
									babyArrow.animation.add('pressed', [5, 9], 12, false);
									babyArrow.animation.add('confirm', [13, 17], 24, false);
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.add('static', [2]);
									babyArrow.animation.add('pressed', [6, 10], 12, false);
									babyArrow.animation.add('confirm', [14, 18], 12, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.add('static', [3]);
									babyArrow.animation.add('pressed', [7, 11], 12, false);
									babyArrow.animation.add('confirm', [15, 19], 24, false);
							}
						case 'normal':
							babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
			
							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			
							switch (Math.abs(i))
							{
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
		
						default:
							if (FlxG.save.data.circle){
								babyArrow.frames = Paths.getSparrowAtlas('notes/CIRCLE_NOTE_assets', 'shared');			
							}
							else{
								babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');						
							}
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
							switch (Math.abs(i))
							{
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
					}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}


		if (FlxG.save.data.middlescroll && player == 0)
			{
				babyArrow.visible = false;
			}

			if (FlxG.save.data.middlescroll)		//Made By Klav Lmao
			{
				babyArrow.x -= 275;
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (shakeCam)
			{
				FlxG.camera.shake(0.005, 0.10);
			}

		if (shakeCam2)
			{
				FlxG.camera.shake(0.0025, 0.10);
			}

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

	
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}



		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);
		if (SONG.song.toLowerCase() == 'onslaught' && IsNoteSpinning){
			var thisX:Float =  Math.sin(SpinAmount * (SpinAmount / 2)) * 100;
			var thisY:Float =  Math.sin(SpinAmount * (SpinAmount)) * 100;
			var yVal = Std.int(windowY + thisY);
			var xVal = Std.int(windowX + thisX);
				Lib.application.window.move(xVal,yVal);
			for (str in playerStrums){
				str.angle = str.angle + SpinAmount;
				SpinAmount = SpinAmount + 0.0003;
			}
		}
		else
		{
			for (str in playerStrums){
				str.angle = str.health;
			}
		}

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER  #if android || FlxG.android.justReleased.BACK #end  && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (curSong.toLowerCase() == 'ballistic')
			{
				if (gf.animation.name != 'scared')
					gf.playAnim('scared');
			}

		if (curStage == 'ballisticAlley' && health != 2)
			{
				funneEffect.alpha = health - 0.3;
				if (theFunneNumber < 0.7)
					theFunneNumber = 0.7;
				else if (theFunneNumber > 1.2)
					theFunneNumber = 1.2;

				if (theFunneNumber < 1)
					funneEffect.y = -300;
				else
					funneEffect.y = -200;

				funneEffect.setGraphicSize(Std.int(funneEffect.width * theFunneNumber));
			}		

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			

			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);


			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;

				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}

				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);

				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);

				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'sonic':
						camFollow.y = dad.getMidpoint().y - 30;
						camFollow.x = dad.getMidpoint().x + 120;
					case 'sonicLordX':
						camFollow.y = dad.getMidpoint().y - 30;
						camFollow.x = dad.getMidpoint().x + 120;
					case 'monika':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'duet':
						camFollow.y = dad.getMidpoint().y - 400;
						camFollow.x = dad.getMidpoint().x + 0;
					case 'monika-angry':
						camFollow.y = dad.getMidpoint().y - 390;
						camFollow.x = dad.getMidpoint().x - 350;	
					case 'qt' | 'qt_annoyed':
						camFollow.y = dad.getMidpoint().y + 261;
					case 'qt_classic':
						camFollow.y = dad.getMidpoint().y + 95;
					case 'robot' | 'robot_404' | 'robot_404-TERMINATION' | 'robot_classic' | 'robot_classic_404':
						camFollow.y = dad.getMidpoint().y + 25;
						camFollow.x = dad.getMidpoint().x - 18;
					case 'qt-kb':
						camFollow.y = dad.getMidpoint().y + 25;
						camFollow.x = dad.getMidpoint().x - 18;
					case 'qt-meme':
						camFollow.y = dad.getMidpoint().y + 107;																		
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;

				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}

				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);


				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);


				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						switch (curSong.toLowerCase())
						{
							case "your reality":
								camFollow.x = boyfriend.getMidpoint().x - 500;
								camFollow.y = boyfriend.getMidpoint().y - 600;
							case "bara no yume":
								camFollow.x = boyfriend.getMidpoint().x - 300;
								camFollow.y = boyfriend.getMidpoint().y - 200;
							default:
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
						}
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
						if (daNote.noteType == 1)
							altAnim = '-alt';						
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						
	
					
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
					

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
						}
						else
						{
							if (daNote.noteType == 2)
							{
								switch (curSong.toLowerCase()){
									case 'your-demise':
										vocals.volume = 1;
									case 'too-slow' | 'endless' | 'execution':
										noteMiss(daNote.noteData, daNote);
										health -= 0.3;
										staticHitMiss();
										vocals.volume = 0;
										FlxG.sound.play(Paths.sound('ring'), .7);
									default:											
								}		
							}
							else
								{
									health -= 0.075;
									vocals.volume = 0;
									if (theFunne)
										noteMiss(daNote.noteData, daNote);
								}
						}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}
	//Call this function to update the visuals for Censory overload!
		function CensoryOverload404():Void
			{
		/*		if(qtIsBlueScreened){
					//Hide original versions
					boyfriend.alpha = 0;
					gf.alpha = 0;
					dad.alpha = 0;
		
					//New versions un-hidden.
					boyfriend404.alpha = 1;
					gf404.alpha = 1;
					dad404.alpha = 1;
				}
				else{ //Reset back to normal
		
					//Return to original sprites.
					boyfriend404.alpha = 0;
					gf404.alpha = 0;
					dad404.alpha = 0;
		
					//Hide 404 versions
					boyfriend.alpha = 1;
					gf.alpha = 1;
					dad.alpha = 1; 
				}*/
			}
		
			function dodgeTimingOverride(newValue:Float = 0.22625):Void
			{
				bfDodgeTiming = newValue;
			}
		
			function dodgeCooldownOverride(newValue:Float = 0.1135):Void
			{
				bfDodgeCooldown = newValue;
			}	
		
			function KBATTACK_TOGGLE(shouldAdd:Bool = true):Void
			{
				if(shouldAdd)
					add(kb_attack_saw);
				else
					remove(kb_attack_saw);
			}
		
			function KBALERT_TOGGLE(shouldAdd:Bool = true):Void
			{
				if(shouldAdd)
					add(kb_attack_alert);
				else
					remove(kb_attack_alert);
			}
		
			//False state = Prime!
			//True state = Attack!
			function KBATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
					trace("Sawblade Attack Error, cannot use Termination functions outside Termination or Tutorial.");
				}
				trace("HE ATACC!");
				if(state){
					FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
					//Play saw attack animation
					kb_attack_saw.animation.play('fire');
					kb_attack_saw.offset.set(1600,0);
		
					/*kb_attack_saw.animation.finishCallback = function(pog:String){
						if(state) //I don't get it.
							remove(kb_attack_saw);
					}*/
		
					//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
					new FlxTimer().start(0.09, function(tmr:FlxTimer)
					{
						if(!bfDodging){
							//MURDER THE BITCH!
							deathBySawBlade = true;
							health -= 404;
						}
					});
				}else{
					kb_attack_saw.animation.play('prepare');
					kb_attack_saw.offset.set(-333,0);
				}
			}
			function KBATTACK_ALERT(pointless:Bool = false):Void //For some reason, modchart doesn't like functions with no parameter? why? dunno.
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
					trace("Sawblade Alert Error, cannot use Termination functions outside Termination or Tutorial.");
				}
				trace("DANGER!");
				kb_attack_alert.animation.play('alert');
				FlxG.sound.play(Paths.sound('alert','qt'), 1);
			}
		
			//OLD ATTACK DOUBLE VARIATION
			function KBATTACK_ALERTDOUBLE(pointless:Bool = false):Void
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
					trace("Sawblade AlertDOUBLE Error, cannot use Termination functions outside Termination or Tutorial.");
				}
				trace("DANGER DOUBLE INCOMING!!");
				kb_attack_alert.animation.play('alertDOUBLE');
				FlxG.sound.play(Paths.sound('old/alertALT','qt'), 1);
			}
		
			//Pincer logic, used by the modchart but can be hardcoded like saws if you want.
			function KBPINCER_PREPARE(laneID:Int,goAway:Bool):Void
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
					trace("Pincer Error, cannot use Termination functions outside Termination or Tutorial.");
				}
				else{
					//1 = BF far left, 4 = BF far right. This only works for BF!
					//Update! 5 now refers to the far left lane. Mainly used for the shaking section or whatever.
					pincer1.cameras = [camHUD];
					pincer2.cameras = [camHUD];
					pincer3.cameras = [camHUD];
					pincer4.cameras = [camHUD];
		
					//This is probably the most disgusting code I've ever written in my life.
					//All because I can't be bothered to learn arrays and shit.
					//Would've converted this to a switch case but I'm too scared to change it so deal with it.
					if(laneID==1){
						pincer1.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
						if(FlxG.save.data.downscroll){
							if(!goAway){
								pincer1.setPosition(strumLineNotes.members[4].x,strumLineNotes.members[4].y+500);
								add(pincer1);
								FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
							}
						}else{
							if(!goAway){
								pincer1.setPosition(strumLineNotes.members[4].x,strumLineNotes.members[4].y-500);
								add(pincer1);
								FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
							}
						}
					}
					else if(laneID==5){ //Targets far left note for Dad (KB). Used for the screenshake thing
						pincer1.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
						if(FlxG.save.data.downscroll){
							if(!goAway){
								pincer1.setPosition(strumLineNotes.members[0].x,strumLineNotes.members[0].y+500);
								add(pincer1);
								FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
							}
						}else{
							if(!goAway){
								pincer1.setPosition(strumLineNotes.members[0].x,strumLineNotes.members[5].y-500);
								add(pincer1);
								FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
							}
						}
					}
					else if(laneID==2){
						pincer2.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
						if(FlxG.save.data.downscroll){
							if(!goAway){
								pincer2.setPosition(strumLineNotes.members[5].x,strumLineNotes.members[5].y+500);
								add(pincer2);
								FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer2);}});
							}
						}else{
							if(!goAway){
								pincer2.setPosition(strumLineNotes.members[5].x,strumLineNotes.members[5].y-500);
								add(pincer2);
								FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer2);}});
							}
						}
					}
					else if(laneID==3){
						pincer3.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
						if(FlxG.save.data.downscroll){
							if(!goAway){
								pincer3.setPosition(strumLineNotes.members[6].x,strumLineNotes.members[6].y+500);
								add(pincer3);
								FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer3);}});
							}
						}else{
							if(!goAway){
								pincer3.setPosition(strumLineNotes.members[6].x,strumLineNotes.members[6].y-500);
								add(pincer3);
								FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer3);}});
							}
						}
					}
					else if(laneID==4){
						pincer4.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
						if(FlxG.save.data.downscroll){
							if(!goAway){
								pincer4.setPosition(strumLineNotes.members[7].x,strumLineNotes.members[7].y+500);
								add(pincer4);
								FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer4);}});
							}
						}else{
							if(!goAway){
								pincer4.setPosition(strumLineNotes.members[7].x,strumLineNotes.members[7].y-500);
								add(pincer4);
								FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y}, 0.3, {ease: FlxEase.elasticOut});
							}else{
								FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer4);}});
							}
						}
					}else
						trace("Invalid LaneID for pincer");
				}
			}
			function KBPINCER_GRAB(laneID:Int):Void
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial")){
					trace("PincerGRAB Error, cannot use Termination functions outside Termination or Tutorial.");
				}
				else{
					switch(laneID)
					{
						case 1 | 5:
							pincer1.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
						case 2:
							pincer2.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
						case 3:
							pincer3.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
						case 4:
							pincer4.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
						default:
							trace("Invalid LaneID for pincerGRAB");
					}
				}
			}
		
			function terminationEndEarly():Void //Yep, terminate was originally called termination while termination was going to have a different name. Can't be bothered to update some names though like this so sorry for any confusion -Haz
				{
					if(!qtCarelessFinCalled){
						qt_tv01.animation.play("error");
						canPause = false;
						inCutscene = true;
						paused = true;
						camZooming = false;
						qtCarelessFin = true;
						qtCarelessFinCalled = true; //Variable to prevent constantly repeating this code.
						//Slight delay... -Haz
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							camHUD.visible = false;
							//FlxG.sound.music.pause();
							//vocals.pause();
							var doof = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('terminate/terminateDialogueEND')));
							doof.scrollFactor.set();
							doof.finishThing = loadSongHazard;
							schoolIntro(doof);
						});
					}
				}
		
			function endScreenHazard():Void //For displaying the "thank you for playing" screen on Cessation
			{
				var black:FlxSprite = new FlxSprite(-300, -100).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				black.scrollFactor.set();
		
				var screen:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bonus/FinalScreen'));
				screen.setGraphicSize(Std.int(screen.width * 0.625));
				screen.antialiasing = true;
				screen.scrollFactor.set();
				screen.screenCenter();
		
				var hasTriggeredAlready:Bool = false;
		
				screen.alpha = 0;
				black.alpha = 0;
				
				add(black);
				add(screen);
		
				//Fade in code stolen from schoolIntro() >:3
				new FlxTimer().start(0.15, function(swagTimer:FlxTimer)
				{
					black.alpha += 0.075;
					if (black.alpha < 1)
					{
						swagTimer.reset();
					}
					else
					{
						screen.alpha += 0.075;
						if (screen.alpha < 1)
						{
							swagTimer.reset();
						}
		
						canSkipEndScreen = true;
						//Wait 12 seconds, then do shit -Haz
						new FlxTimer().start(12, function(tmr:FlxTimer)
						{
							if(!hasTriggeredAlready){
								hasTriggeredAlready = true;
								loadSongHazard();
							}
						});
					}
				});		
			}
		
			function loadSongHazard():Void //Used for Careless, Termination, and Cessation when they end -Haz
			{
				canSkipEndScreen = false;
		
				//Very disgusting but it works... kinda
				if (SONG.song.toLowerCase() == 'cessation')
				{
					trace('Switching to MainMenu. Thanks for playing.');
					FlxG.sound.playMusic(Paths.music('thanks'));
					FlxG.switchState(new MainMenuState());
					Conductor.changeBPM(102); //lmao, this code doesn't even do anything useful! (aaaaaaaaaaaaaaaaaaaaaa)
				}	
				else if (SONG.song.toLowerCase() == 'terminate')
				{
					FlxG.log.notice("Back to the menu you go!!!");
		
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
		
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
		
					FlxG.switchState(new StoryMenuState());
		
		/*			#if cpp
					if (lua != null)
					{
						Lua.close(lua);
						lua = null;
					}
					#end */
		
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
		
					if (SONG.validScore)
					{
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}
		
					if(storyDifficulty == 2) //You can only unlock Termination after beating story week on hard.
						FlxG.save.data.terminationUnlocked = true; //Congratulations, you unlocked hell! Have fun! ~♥
		
		
					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;	
					FlxG.save.flush();
				}
				else
				{
				var difficulty:String = "";
				if (storyDifficulty == 0)
					difficulty = '-easy';
		
				if (storyDifficulty == 2)
					difficulty = '-hard';	
				
				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
				FlxG.log.notice(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;
		
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				
				LoadingState.loadAndSwitchState(new PlayState());
				}
			}	
	public function songOutro():Void
		{
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			canPause = false;

			if (isStoryMode && FlxG.save.data.cutscenes)
			{
				switch (curSong.toLowerCase())
				{
					case 'high school conflict':
						roseend(doof4);
					case 'bara no yume':
						roseend(doof4);
					case 'your demise':
						demiseend(doof3);
					default:
						endSong();
				}
			}
			else
				{
					switch (curSong.toLowerCase())
					{
						default:
							endSong();
					}
				}
				
		}

	function endSong():Void
		{
	
			#if mobileC
			mcontrols.visible = false;
			#end
	
			if (!loadRep)
				trace('hi');
			else
			{
				FlxG.save.data.botplay = false;
				FlxG.save.data.scrollSpeed = 1;
				FlxG.save.data.downscroll = false;
			}
	
			if (FlxG.save.data.fpsCap > 290)
				(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
	
		
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
		
	
			canPause = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			if (SONG.validScore)
			{
				// adjusting the highscore song name to be compatible
				// would read original scores if we didn't change packages
				var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
				switch (songHighscore) {
					case 'Dad-Battle': songHighscore = 'Dadbattle';
					case 'Philly-Nice': songHighscore = 'Philly';
				}
	
				#if !switch
				Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
				#end
			}
	
			if (offsetTesting)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				offsetTesting = false;
				LoadingState.loadAndSwitchState(new OptionsMenu());
				FlxG.save.data.offset = offsetTest;
			}
			else
			{
				if (isStoryMode)
				{
					campaignScore += Math.round(songScore);
	
					storyPlaylist.remove(storyPlaylist[0]);
	
					if (storyPlaylist.length <= 0)
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
	
						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;
	
						FlxG.switchState(new MainMenuState());
	
					
						if (luaModchart != null)
						{
							luaModchart.die();
							luaModchart = null;
						}
					
	
						// if ()
						StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
	
						if (SONG.validScore)
						{
	
							Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
						}
	
						FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
						FlxG.save.flush();
					}
					else
					{
						var difficulty:String = "";
	
						if (storyDifficulty == 0)
							difficulty = '-easy';
	
						if (storyDifficulty == 2)
							difficulty = '-hard';
	
						trace('LOADING NEXT SONG');
						// pre lowercasing the next story song name
						var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
							switch (nextSongLowercase) {
								case 'dad-battle': nextSongLowercase = 'dadbattle';
								case 'philly-nice': nextSongLowercase = 'philly';
							}
						trace(nextSongLowercase + difficulty);
	
						// pre lowercasing the song name (endSong)
						var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
						switch (songLowercase) {
							case 'dad-battle': songLowercase = 'dadbattle';
							case 'philly-nice': songLowercase = 'philly';
						}
						if (songLowercase == 'eggnog')
						{
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;
	
							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
						}
	
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						prevCamFollow = camFollow;
	

						PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();
	
						LoadingState.loadAndSwitchState(new PlayState());
						switch (nextSongLowercase) {
							case 'endless':
								LoadingState.loadAndSwitchState(new VideoState("assets/videos/sonic/tooslowcutscene2.webm", new PlayState()));
							case 'trouble':
								LoadingState.loadAndSwitchState(new VideoState("assets/videos/ronEndCutscene/ronEndCutscene.webm", new PlayState()));
							default:
								LoadingState.loadAndSwitchState(new PlayState());
						}
					//	LoadingState.loadAndSwitchState(new VideoState("assets/videos/tooslowcutscene2.webm", new PlayState()));	
					}
				}
				else
				{
					trace('WENT BACK TO FREEPLAY??');
					FlxG.switchState(new MainMenuState());
				}
			}
		}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
					case 'shit':
						if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'too-slow')
							{
								health -= 0.2;
							}
						else if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'your demise' )
							{
								health -= 100;
							}	
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								score = -300;
								combo = 0;
								misses++;
								health -= 0.2;
								ss = false;
								shits++;
								if (FlxG.save.data.notesplash){
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}										
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.25;
							}
					case 'bad':
						if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'too-slow')
							{
								health -= 0.06;
							}
						else if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'your demise' )
							{
								health -= 100;
							}	
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								daRating = 'bad';
								score = 0;
								health -= 0.06;
								ss = false;
								bads++;
								if (FlxG.save.data.notesplash){
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}										
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.50;
							}
					case 'good':
						if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'too-slow')
							{
								daRating = 'good';
								score = 200;
								ss = false;
								goods++;
								if (FlxG.save.data.notesplash){
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}										
								if (health < 2)
									health += 0.04;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.75;
							}
						else if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'your demise' )
							{
								health -= 100;
							}								
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								daRating = 'good';
								score = 200;
								ss = false;
								goods++;
								if (health < 2)
									health += 0.04;
								if (FlxG.save.data.notesplash){
								var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}										
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.75;
							}
					case 'sick':
						if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'too-slow' || SONG.song.toLowerCase() == 'endless' || SONG.song.toLowerCase() == 'execution')
							{
								if (health < 2)
									health += 0.1;
								if (FlxG.save.data.notesplash){
									var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}						
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 1;
								sicks++;	
							}
						else if (daNote.noteType == 2 && SONG.song.toLowerCase() == 'your demise' )
							{
								health -= 100;
							}								
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								if (health < 2)
									health += 0.1;
								if (FlxG.save.data.notesplash){
									var recycledNote = grpNoteSplashes.recycle(NoteSplash);
									recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
									grpNoteSplashes.add(recycledNote);
								}								
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 1;
								sicks++;	
							}					
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
		//Dodge code only works on termination and Tutorial -Haz
		if(SONG.song.toLowerCase() == "termination"){
			//Dodge code, yes it's bad but oh well. -Haz
			//var dodgeButton = controls.ACCEPT; //I have no idea how to add custom controls so fuck it. -Haz

			if(FlxG.keys.justPressed.SPACE)
				trace('butttonpressed');

			if(FlxG.keys.justPressed.SPACE || _pad.buttonA.pressed && !bfDodging && bfCanDodge){
				trace('DODGE START!');
				bfDodging = true;
				bfCanDodge = false;

				if(qtIsBlueScreened)
				//	boyfriend404.playAnim('dodge');
				trace('nothins :skull:');
				else
					boyfriend.playAnim('dodge');

				FlxG.sound.play(Paths.sound('dodge01', 'qt'));

				//Wait, then set bfDodging back to false. -Haz
				//V1.2 - Timer lasts a bit longer (by 0.00225)
				//new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
				//new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
				new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
				{
					bfDodging=false;
					boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
					trace('DODGE END!');
					//Cooldown timer so you can't keep spamming it.
					//V1.3 = Incremented this by a little (0.005)
					//new FlxTimer().start(0.1135, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					//new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					{
						bfCanDodge=true;
						trace('DODGE RECHARGED!');
					});
				});
			}
		}				
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
			
		 
				// Prevent player input if botplay is on
				/*if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}  */
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									if (daNote.noteType == 2)
										{
										}
									else
										{
											goodNoteHit(daNote);
											boyfriend.holdTimer = daNote.sustainLength;
										}
									
								}
							}else {
								if (daNote.noteType == 2)
									{
									}
								else
									{
										goodNoteHit(daNote);
										boyfriend.holdTimer = daNote.sustainLength;
									}
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);



			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
				
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var isbobmad:Bool = true;
	var appearscreen:Bool = true;
	function shakescreen()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10, 10),Lib.application.window.y + FlxG.random.int( -8, 8));
		}, 50);
	}
	function HealthDrain():Void
	{
		FlxG.sound.play(Paths.sound("BoomCloud"), 1);
		boyfriend.playAnim("hit", true);
		FlxG.camera.zoom -= 0.02;
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			boyfriend.playAnim("idle", true);
		});
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			health -= 0.005;
		}, 300);
	}
	function resetBobismad():Void
	{
		camHUD.visible = true;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
		isbobmad = true;
	}
	function InvisibleNotes()
	{
		FlxG.sound.play(Paths.sound('Meow'));
		for (note in playerStrums)
			{
				note.visible = false;
			}
		for (note in strumLineNotes)
			{
				note.visible = false;
			}
	}
	function VisibleNotes()
	{
		FlxG.sound.play(Paths.sound('woeM'));
		for (note in playerStrums)
			{
				note.visible = true;
			}
		for (note in strumLineNotes)
			{
				note.visible = true;
			}
	}

	function Bobismad()
	{
		camHUD.visible = false;
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		isbobmad = false;
		shakescreen();
		new FlxTimer().start(0.5 , function(tmr:FlxTimer)
		{
			resetBobismad();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;
	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (SONG.song.toLowerCase() == 'your demise')
			{
				switch (curStep)
				{
					case 132:
						boyfriend.visible = true;
						dad.visible = true;
						remove(blackScreen);

						new FlxTimer().start(0.03, function(tmr:FlxTimer)
							{
								whiteflash.alpha -= 0.15;
								if (whiteflash.alpha > 0)
									{
										tmr.reset(0.03);
									}
									else
										{
											remove(whiteflash);
										}
							});
					
					case 889:
						FlxG.camera.fade(FlxColor.BLACK, 2, false);
				}
			}

		if (dad.curCharacter == 'sonic' && SONG.song.toLowerCase() == 'too-slow')
			{
				switch (curStep)
				{
					case 765:
						shakeCam = true;
						FlxG.camera.flash(FlxColor.RED, 4);
				}
			}

		if (dad.curCharacter == 'sonicfun' && SONG.song.toLowerCase() == 'endless')
			{
				switch (curStep)
				{
					case 10:
						FlxG.sound.play(Paths.sound('laugh1', 'shared'), 0.7);
				}
				if (spinArray.contains(curStep))
					{
						strumLineNotes.forEach(function(tospin:FlxSprite)
						{
							FlxTween.angle(tospin, 0, 360, 0.2, {ease: FlxEase.quintOut});
						});
					}
			}

		if (dad.curCharacter == 'sonic' && SONG.song.toLowerCase() == 'too-slow' && curStep == 791)
			{
				shakeCam = false;
				shakeCam2 = false;
			}

		if (curStage == 'sonicFUNSTAGE' && curStep != stepOfLast)
			{
				switch(curStep)
				{
					case 909:
					camLocked = false;
					FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
					three();
					case 914:
					FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
					two();
					case 918:
					FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 0.7, {ease: FlxEase.cubeInOut});
					one();
					case 923:
					camLocked = true;
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.7, {ease: FlxEase.cubeInOut});
					gofun();
					SONG.noteStyle = 'majinNOTES';
				//	removeStatics();
				//	generateStaticArrows(0, false);
				//	generateStaticArrows(1, false);
				}
			}

		if (curStage == 'SONICstage' && curStep != stepOfLast && FlxG.save.data.jumpscares)
			{
				switch (curStep)
				{
					case 27:
					doStaticSign(0);
					case 130:
					doStaticSign(0);
					case 265:
					doStaticSign(0);
					case 450:
					doStaticSign(0);
					case 645:
					doStaticSign(0);
					case 800:
					doStaticSign(0);
					case 855:
					doStaticSign(0);
					case 889:
					doStaticSign(0);
					case 921:
					doSimpleJump();
					case 938:
					doStaticSign(0);
					case 981:
					doStaticSign(0);
					case 1030:
					doStaticSign(0);
					case 1065:
					doStaticSign(0);
					case 1105:
					doStaticSign(0);
					case 1123:
					doStaticSign(0);
					case 1178:
					doSimpleJump();
					case 1245:
					doStaticSign(0);
					case 1337:
					doSimpleJump();
					case 1345:
					doStaticSign(0);
					case 1432:
					doStaticSign(0);
					case 1454:
					doStaticSign(0);
					case 1495:
					doStaticSign(0);
					case 1521:
					doStaticSign(0);
					case 1558:
					doStaticSign(0);
					case 1578:
					doStaticSign(0);
					case 1599:
					doStaticSign(0);
					case 1618:
					doStaticSign(0);
					case 1647:
					doStaticSign(0);
					case 1657:
					doStaticSign(0);
					case 1692:
					doStaticSign(0);
					case 1713:
					doStaticSign(0);
					case 1723:
					doJumpscare();
					case 1738:
					doStaticSign(0);
					case 1747:
					doStaticSign(0);
					case 1761:
					doStaticSign(0);
					case 1785:
					doStaticSign(0);
					case 1806:
					doStaticSign(0);
					case 1816:
					doStaticSign(0);
					case 1832:
					doStaticSign(0);
					case 1849:
					doStaticSign(0);
					case 1868:
					doStaticSign(0);
					case 1887:
					doStaticSign(0);
					case 1909:
					doStaticSign(0);
					

				}
					stepOfLast = curStep;
			}
		
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

		//For trolling :)
		if (curSong.toLowerCase() == 'cessation'){
			if(hazardRandom==5){
				if(curStep == 1504){
					add(kb_attack_alert);
					KBATTACK_ALERT();
				}
				else if (curStep == 1508)
					KBATTACK_ALERT();
				else if(curStep == 1512){
					FlxG.sound.play(Paths.sound('bruh'),0.75);
					add(cessationTroll);
				}
					
				else if(curStep == 1520)
					remove(cessationTroll);
			}
		}
		//Animating every beat is too slow, so I'm doing this every step instead (previously was on every frame so it actually has time to animate through frames). -Haz
		if (curSong.toLowerCase() == 'censory-overload'){
			//Making GF scared for error section
			if(curBeat>=704 && curBeat<832 && curStep % 2 == 0)
			{
				gf.playAnim('scared', true);
					gf404.playAnim('scared', true);
			}
		}
		//Midsong events for Termination (such as the sawblade attack)
		else if (curSong.toLowerCase() == 'termination'){
			
			//For animating KB during the 404 section since he animates every half beat, not every beat.
			if(qtIsBlueScreened)
			{
				//Termination KB animates every 2 curstep instead of 4 (aka, every half beat, not every beat!)
				if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && !dad404.animation.curAnim.name.startsWith("sing") && curStep % 2 == 0)
				{
					dad404.dance();
				}
			}

			//Making GF scared for error section
			if(curStep>=2816 && curStep<3328 && curStep % 2 == 0)
			{
				gf.playAnim('scared', true);
					gf404.playAnim('scared', true);
			}


			switch (curStep)
			{
				//Commented out stuff are for the double sawblade variations.
				//It is recommended to not uncomment them unless you know what you're doing. They are also not polished at all so don't complain about them if you do uncomment them.
				
				
				//CONVERTED THE CUSTOM INTRO FROM MODCHART INTO HARDCODE OR WHATEVER! NO MORE INVISIBLE NOTES DUE TO NO MODCHART SUPPORT!
				case 1:
					qt_tv01.animation.play("instructions");
					FlxTween.tween(strumLineNotes.members[0], {y: strumLineNotes.members[0].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[7], {y: strumLineNotes.members[7].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
	/*					boyfriend404.alpha = 0; 
						dad404.alpha = 0;
						gf404.alpha = 0; */
					
				case 32:
					FlxTween.tween(strumLineNotes.members[1], {y: strumLineNotes.members[1].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 96:
					FlxTween.tween(strumLineNotes.members[3], {y: strumLineNotes.members[3].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[4], {y: strumLineNotes.members[4].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 64:
					qt_tv01.animation.play("gl");
					FlxTween.tween(strumLineNotes.members[2], {y: strumLineNotes.members[2].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 112:
					add(kb_attack_saw);
					add(kb_attack_alert);
					KBATTACK_ALERT();
					KBATTACK();
				case 116:
					//KBATTACK_ALERTDOUBLE();
					KBATTACK_ALERT();
				case 120:
					//KBATTACK(true, "old/attack_alt01");
					KBATTACK(true);
					qt_tv01.animation.play("idle");
					for (boi in strumLineNotes.members) { //FAIL SAFE TO ENSURE THAT ALL THE NOTES ARE VISIBLE WHEN PLAYING!!!!!
						boi.alpha = 1;
					}
				//case 123:
					//KBATTACK();
				//case 124:
					//FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 2, {ease: FlxEase.sineInOut}); //for testing outro code
					//KBATTACK(true, "old/attack_alt02");
				case 1280:
					qt_tv01.animation.play("idle");
				case 1760:
					qt_tv01.animation.play("watch");
				case 1792:
					qt_tv01.animation.play("idle");

				case 1776 | 1904 | 2032 | 2576 | 2596 | 2608 | 2624 | 2640 | 2660 | 2672 | 2704 | 2736 | 3072 | 3084 | 3104 | 3116 | 3136 | 3152 | 3168 | 3184 | 3216 | 3248 | 3312:
					KBATTACK_ALERT();
					KBATTACK();
				case 1780 | 1908 | 2036 | 2580 | 2600 | 2612 | 2628 | 2644 | 2664 | 2676 | 2708 | 2740 | 3076 | 3088 | 3108 | 3120 | 3140 | 3156 | 3172 | 3188 | 3220 | 3252 | 3316:
					KBATTACK_ALERT();
				case 1784 | 1912 | 2040 | 2584 | 2604 | 2616 | 2632 | 2648 | 2668 | 2680 | 2712 | 2744 | 3080 | 3092 | 3112 | 3124 | 3144 | 3160 | 3176 | 3192 | 3224 | 3256 | 3320:
					KBATTACK(true);

				//Sawblades before bluescreen thing
				//These were seperated for double sawblade experimentation if you're wondering.
				//My god this organisation is so bad. Too bad!
				case 2304 | 2320 | 2340 | 2368 | 2384 | 2404:
					KBATTACK_ALERT();
					KBATTACK();
				case 2308 | 2324 | 2344 | 2372 | 2388 | 2408:
					KBATTACK_ALERT();
				case 2312 | 2328 | 2348 | 2376 | 2392 | 2412:
					KBATTACK(true);
				case 2352 | 2416:
					KBATTACK_ALERT();
					KBATTACK();
				case 2356 | 2420:
					//KBATTACK_ALERTDOUBLE();
					KBATTACK_ALERT();
				case 2360 | 2424:
					KBATTACK(true);
				case 2363 | 2427:
					//KBATTACK();
				case 2364 | 2428:
					//KBATTACK(true, "old/attack_alt02");

				case 2560:
					KBATTACK_ALERT();
					KBATTACK();
					qt_tv01.animation.play("eye");
				case 2564:
					KBATTACK_ALERT();
				case 2568:
					KBATTACK(true);

				case 2808:
					//Change to glitch background
						streetBGerror.visible = true;
						streetBG.visible = false;
					
					FlxG.camera.shake(0.0075,0.675);
					qt_tv01.animation.play("error");

				case 2816: //404 section
					qt_tv01.animation.play("404");
					gfSpeed = 1;
					//Change to bluescreen background
						streetBG.visible = false;
						streetBGerror.visible = false;
						streetFrontError.visible = true;
						qtIsBlueScreened = true;
						CensoryOverload404();
					
				case 3328: //Final drop
					qt_tv01.animation.play("alert");
					gfSpeed = 1;
					//Revert back to normal
						streetBG.visible = true;
						streetFrontError.visible = false;
						qtIsBlueScreened = false;
						CensoryOverload404();
					

				case 3376 | 3408 | 3424 | 3440 | 3576 | 3636 | 3648 | 3680 | 3696 | 3888 | 3936 | 3952 | 4096 | 4108 | 4128 | 4140 | 4160 | 4176 | 4192 | 4204:
					KBATTACK_ALERT();
					KBATTACK();
				case 3380 | 3412 | 3428 | 3444 | 3580 | 3640 | 3652 | 3684 | 3700 | 3892 | 3940 | 3956 | 4100 | 4112 | 4132 | 4144 | 4164 | 4180 | 4196 | 4208:
					KBATTACK_ALERT();
				case 3384 | 3416 | 3432 | 3448 | 3584 | 3644 | 3656 | 3688 | 3704 | 3896 | 3944 | 3960 | 4104 | 4116 | 4136 | 4148 | 4168 | 4184 | 4200 | 4212:
					KBATTACK(true);
				case 4352: //Custom outro hardcoded instead of being part of the modchart! 
					qt_tv01.animation.play("idle");
					FlxTween.tween(strumLineNotes.members[2], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4384:
					FlxTween.tween(strumLineNotes.members[3], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4416:
					FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4448:
					FlxTween.tween(strumLineNotes.members[1], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});

				case 4480:
					FlxTween.tween(strumLineNotes.members[6], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4512:
					FlxTween.tween(strumLineNotes.members[7], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4544:
					FlxTween.tween(strumLineNotes.members[4], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4576:
					FlxTween.tween(strumLineNotes.members[5], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
			}
		}
		//????
		else if (curSong.toLowerCase() == 'redacted'){
			switch (curStep)
			{
				case 1:
				//	boyfriend404.alpha = 0.0125;
				case 16:
					FlxTween.tween(strumLineNotes.members[4], {y: strumLineNotes.members[4].y + 10, alpha: 0.8}, 6, {ease: FlxEase.circOut});
				case 20:
					FlxTween.tween(strumLineNotes.members[5], {y: strumLineNotes.members[5].y + 10, alpha: 0.8}, 6, {ease: FlxEase.circOut});
				case 24:
					FlxTween.tween(strumLineNotes.members[6], {y: strumLineNotes.members[6].y + 10, alpha: 0.8}, 6, {ease: FlxEase.circOut});
				case 28:
					FlxTween.tween(strumLineNotes.members[7], {y: strumLineNotes.members[7].y + 10, alpha: 0.8}, 6, {ease: FlxEase.circOut});

				case 584:
					add(kb_attack_alert);
					kb_attack_alert.animation.play('alert'); //Doesn't call function since this alert is unique + I don't want sound lmao since it's already in the inst
				case 588:
					kb_attack_alert.animation.play('alert');
				case 600 | 604 | 616 | 620 | 632 | 636 | 648 | 652 | 664 | 668 | 680 | 684 | 696 | 700:
					kb_attack_alert.animation.play('alert');
				case 704:
					qt_tv01.animation.play("part1");
					FlxTween.tween(strumLineNotes.members[0], {y: strumLineNotes.members[0].y + 10, alpha: 0.1125}, 25, {ease: FlxEase.circOut});
					FlxTween.tween(strumLineNotes.members[1], {y: strumLineNotes.members[1].y + 10, alpha: 0.1125}, 25, {ease: FlxEase.circOut});
					FlxTween.tween(strumLineNotes.members[2], {y: strumLineNotes.members[2].y + 10, alpha: 0.1125}, 25, {ease: FlxEase.circOut});
					FlxTween.tween(strumLineNotes.members[3], {y: strumLineNotes.members[3].y + 10, alpha: 0.1125}, 25, {ease: FlxEase.circOut});
				case 752:
					qt_tv01.animation.play("part2");
				case 800:
					qt_tv01.animation.play("part3");
				case 832:
					qt_tv01.animation.play("part4");
				case 1216:
					qt_tv01.animation.play("idle");
					qtIsBlueScreened = true; //Reusing the 404bluescreen code for swapping BF character.
					boyfriend.alpha = 0;
			//		boyfriend404.alpha = 1;
					iconP1.animation.play("bf");										
			}
		}

		if (dad.curCharacter == 'garcellodead' && SONG.song.toLowerCase() == 'release')
			{
				if (curStep == 838)
				{
					dad.playAnim('garTightBars', true);
				}
			}
	
			if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
			{
				if (curStep == 247)
				{
					dad.playAnim('garFarewell', true);
				}
			}
	
			if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
			{
				if (curStep == 240)
				{
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						dad.alpha -= 0.05;
						iconP2.alpha -= 0.05;
	
						if (dad.alpha > 0)
						{
							tmr.reset(0.1);
						}
					});
				}
			}
		}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
	

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0 && curSong.toLowerCase() == 'ballistic')
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.035;
		}
		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 0 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		else if (curSong.toLowerCase() == 'onslaught' && curBeat >= 96 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		else if (curSong.toLowerCase() == 'onslaught' && curBeat >= 240 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curSong == 'Ron')
		{
			if (curBeat == 7)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
				dad.playAnim('cheer', true);
			}
			else if (curBeat == 119)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
				dad.playAnim('cheer', true);
			}
			else if (curBeat == 215)
			{
				FlxG.camera.follow(dad, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.4, {ease: FlxEase.expoOut,});
				dad.playAnim('cheer', true);
			}
			else
			{
				FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
			}
		}
		if (curBeat % gfSpeed == 0 && curSong == 'run')
		{
			camHUD.shake(0.02, 0.2);
			FlxG.camera.shake(0.005, 0.2);
			//FlxTween.tween(camHUD, {angle: 0},0.5, {ease: FlxEase.elasticOut});
		}
		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 128 && curBeat <= 352 )
			{
				var amount = curBeat/20;
				if (FlxG.random.bool(amount) && appearscreen)
				{
					var randomthing:FlxSprite = new FlxSprite(FlxG.random.int(300, 1077), FlxG.random.int(0, 622));
					FlxG.sound.play(Paths.sound("pop_up"), 1);
					randomthing.loadGraphic(Paths.image('bob/PopUps/popup' + FlxG.random.int(1,11), 'shared'));
					randomthing.updateHitbox();
					randomthing.alpha = 0;
					randomthing.antialiasing = true;
					add(randomthing);
					randomthing.cameras = [camHUD];
					appearscreen = false;
					if (storyDifficulty == 0)
					{
						FlxTween.tween(randomthing, {width: 1, alpha: 0.5}, 0.2, {ease: FlxEase.sineOut});
					}
					else
					{
						FlxTween.tween(randomthing, {width: 1, alpha: 1}, 0.2, {ease: FlxEase.sineOut});
					}
					new FlxTimer().start(1.5 , function(tmr:FlxTimer)
					{
						appearscreen = true;
					});
					new FlxTimer().start(2 , function(tmr:FlxTimer)
					{
						remove(randomthing);
					});
				}
			}
			if (curSong.toLowerCase() == 'little-man' && curBeat == 1397 )
			{
				changeDadCharacter('pizza');
			}
			if (curSong.toLowerCase() == 'little-man' && curBeat == 1497 )
			{
				changeDadCharacter('little-man');
			}
			if (curSong.toLowerCase() == 'little-man' && curBeat == 1900 )
			{
				spotifyad();
			}
			if (curSong.toLowerCase() == 'trouble' && curBeat == 504 )
			{
				BobIngameTransform();
			}
			if (curSong.toLowerCase() == 'onslaught' && curBeat == 96 )
			{
				InvisibleNotes();
			}
			if (curSong.toLowerCase() == 'onslaught' && curBeat == 128 )
			{
				windowX = Lib.application.window.x;
				windowY = Lib.application.window.y;
				IsNoteSpinning = true;
				VisibleNotes();
			}
			if (curSong.toLowerCase() == 'onslaught' && curBeat == 240 )
			{
				InvisibleNotes();
			}
			if (curSong.toLowerCase() == 'onslaught' && curBeat == 352 )
			{
				IsNoteSpinning = false;
					WindowGoBack();
				VisibleNotes();
			}
		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'hellstage':
				
				if (FlxG.random.bool(10) && /*isbobmad &&*/ curSong.toLowerCase() == 'run')
					Bobismad();			
			case 'sonicFUNSTAGE':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					funpillarts1ANIM.animation.play('bumpypillar', true);
				}			
			case 'school':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					bgGirls.dance();
				}
			case 'sonicFUNSTAGE':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					funpillarts1ANIM.animation.play('bumpypillar', true);
				}
			case 'LordXStage':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					hands.animation.play('handss', true);
					tree.animation.play('treeanimation', true);
					eyeflower.animation.play('animatedeye', true);
				}
			case 'mall':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
				case 'raveyard1':
					if(FlxG.save.data.distractions && FlxG.save.data.bg){
					graves_assets.animation.play('idle', true);
					}
				case 'raveyard2':
					if(FlxG.save.data.distractions && FlxG.save.data.bg){
					ghosts_assets.animation.play('idle', true);
					}				
			case "philly":
				if(FlxG.save.data.distractions && FlxG.save.data.bg){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	function BobIngameTransform()
		{
			//screw you aether i want to fix the ingame cutscene
			dad.playAnim('Transform', true);
			FlxG.sound.play(Paths.sound('bobSpooky'));
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			new FlxTimer().start(1.7, function(tmr:FlxTimer)
			{
				add(black);
				FlxG.camera.fade(FlxColor.WHITE, 0.1, true);
			});
	
		}
		function spotifyad()
			{
				var thx:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('littleman/spotifyad'));
				thx.updateHitbox();
				thx.scrollFactor.set(0, 0);
				thx.antialiasing = true;
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					add(thx);
					FlxG.camera.fade(FlxColor.BLACK, 1, true);
				}, true);
			}
		function WindowGoBack()
			{
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					var xLerp:Float = FlxMath.lerp(windowX, Lib.application.window.x, 0.95);
					var yLerp:Float = FlxMath.lerp(windowY, Lib.application.window.y, 0.95);
					Lib.application.window.move(Std.int(xLerp),Std.int(yLerp));
				}, 20);
			}
		function changeDadCharacter(id:String)
			{				
				var olddadx = dad.x;
				var olddady = dad.y;
				remove(dad);
				dad = new Character(olddadx, olddady, id);
				add(dad);
				iconP2.animation.play(id);
			}

	var curLight:Int = 0;
}
