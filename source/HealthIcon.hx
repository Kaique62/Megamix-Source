package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		//Garcello
		animation.add('garcello', [24, 25], 0, false, isPlayer);
		animation.add('garcellotired', [26, 27], 0, false, isPlayer);
		animation.add('garcellodead', [28, 29], 0, false, isPlayer);
		animation.add('garcelloghosty', [29, 29], 0, false, isPlayer);
		//myra
		animation.add('myra', [30, 31], 0, false, isPlayer);
		//Sonic.exe
		animation.add('sonic', [32, 33], 0, false, isPlayer);
		animation.add('sonicfun', [34, 35], 0, false, isPlayer);
		animation.add('sonicLordX', [36, 37], 0, false, isPlayer);
		//monika
		animation.add('monika', [40, 41], 0, false, isPlayer);
		animation.add('monika-angry', [42, 43], 0, false, isPlayer);
		animation.add('bf-pixelangry', [21, 21], 0, false, isPlayer);
		animation.add('duet', [38, 39], 0, false, isPlayer);	
		animation.add('playablesenpai', [22, 22], 0, false, isPlayer);
		//Jamey1!!11!!
		animation.add('jamey1', [10, 11], 0, false, isPlayer);
		animation.add('jamey2', [10, 11], 0, false, isPlayer);								
		animation.play(char);
		scrollFactor.set();

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			{
				setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
			}
	}
}
