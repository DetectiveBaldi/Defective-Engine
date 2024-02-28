package;

import openfl.display.Sprite;

import flixel.FlxGame;

import flixel.util.typeLimit.NextState;

import states.InitState;
import states.PlayState;

class Main extends Sprite
{
	static var game:{width:Int, height:Int, initialState:NextState, updateFramerate:Int, drawFramerate:Int, skipSplash:Bool, startFullscreen:Bool} =
	{
		width: 0,

		height: 0,

		initialState: () -> new PlayState(),

		updateFramerate: 60,

		drawFramerate: 60,

		skipSplash: false,

		startFullscreen: false
	}

	public function new():Void
	{
		super();

		addChild(new FlxGame(game.width, game.height, () -> new InitState(game.initialState), game.updateFramerate, game.drawFramerate, game.skipSplash, game.startFullscreen));
	}
}