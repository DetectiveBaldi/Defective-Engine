package states;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import extendable.State;

import states.editors.ChartingState;

class PlayState extends State
{
	override function create():Void
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.WHITE;

		var sprite:FlxSprite = new FlxSprite(0, 0, "assets/images/HaxeFlixel.png");
		sprite.screenCenter();
		add(sprite);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(() -> new ChartingState(() -> new PlayState()));

		FlxG.camera.zoom = FlxG.camera.zoom + 0.1 * FlxG.mouse.wheel;
	}

	override function destroy():Void
	{
		super.destroy();
	}
}