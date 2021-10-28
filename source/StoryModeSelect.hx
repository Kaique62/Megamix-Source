package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class StoryModeSelect extends MusicBeatState
{
	var logoBl:FlxSprite;
	var menuItems:Array<String> = ['Normal', 'Mods', 'Bob'];
	var text:FlxText;
	var curSelected:Int = 0;
	private var grpControls:FlxTypedGroup<Alphabet>;	
	var gfDance:FlxSprite;
	var whitty:FlxSprite;
	var bob:FlxSprite;
	var mod:Bool = false;
	var danceLeft:Bool = false;

	var UP_P:Bool;
	var DOWN_P:Bool;
	var BACK:Bool;
	var ACCEPT:Bool;	

	override function create()
	{

		if (FlxG.random.bool(1))
			{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/funni.png');
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);				
			}
		else{
			var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
			//controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
			menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.antialiasing = true;
			add(menuBG);
		}	

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...menuItems.length)
			{ 
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}

 

				gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
				gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
				gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				gfDance.antialiasing = true;
				add(gfDance);
			
		
				whitty = new FlxSprite(FlxG.width * 0.55, FlxG.height * 0.07);
				whitty.y += 740;
				whitty.frames = Paths.getSparrowAtlas('whittyDanceTitle','shared');
				whitty.animation.addByPrefix('dance', 'Whitty Dancing Beat', 30, false);
				whitty.antialiasing = true;
				add(whitty);
		
				bob = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
				bob.frames = Paths.getSparrowAtlas('bob');
				bob.animation.addByPrefix('idle', 'gfDancen', 24);
				bob.animation.play('idle');
				bob.antialiasing = true;
				bob.y += 720;
				add(bob);				

				#if mobileC
				addVirtualPad(UP_DOWN, A_B);
				#end

		super.create();
	}
	function changeSelection(change:Int = 0)
	{

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;


		switch (curSelected)
		{
			case 0:
				whittyOut();
				gfIn();
				bobOut();
			case 1:
				whittyIn();	
				gfOut();
				bobOut();
			case 2:
				whittyOut();
				gfOut();
				bobIn();						
		}


		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	override function beatHit()
		{
			super.beatHit();

			danceLeft = !danceLeft;
	
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');

			whitty.animation.play('dance');
	
			FlxG.log.add(curBeat);
	
		}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);


		if (controls.ACCEPT)
			{
				var daSelected:String = menuItems[curSelected];
	
				switch (daSelected)
				{
					case "Normal":
						FlxG.switchState(new StoryMenuState());							
					case "Mods":
						FlxG.switchState(new ModMenuState());
					case 'Bob':
						FlxG.switchState(new BobStoryMenuState());								
				}
			
			}
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
	}
	function whittyIn()
		{
			FlxTween.tween(whitty, {y: 70}, 0.5, {ease: FlxEase.expoInOut});
		}	
	function whittyOut()
		{
			FlxTween.tween(whitty, {y: 740}, 0.5, {ease: FlxEase.expoInOut});
		}
	function gfOut()
		{
			FlxTween.tween(gfDance, {y: -700}, 0.5, {ease: FlxEase.expoInOut});
		}
	function gfIn()
		{
			FlxTween.tween(gfDance, {y: 60}, 0.5, {ease: FlxEase.expoInOut});
		}
	function bobIn()
		{
			FlxTween.tween(bob, {y: 40}, 0.5, {ease: FlxEase.expoInOut});
		}	
	function bobOut()
		{
			FlxTween.tween(bob, {y: 700}, 0.5, {ease: FlxEase.expoInOut});
		}											
}