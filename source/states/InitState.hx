package states;

import haxe.ui.Toolkit;

import flixel.FlxG;
import flixel.FlxState;

import flixel.util.typeLimit.NextState;

import backend.Performance;
#if DISCORD_ALLOWED
    import backend.Presence;
#end

class InitState extends FlxState
{
    var nextState:NextState;

    public function new(nextState:NextState):Void
    {
        super();

        this.nextState = nextState;
    }

    override function create():Void
    {
        super.create();

        Toolkit.theme = "dark";

		Toolkit.init();

        FlxG.game.addChild(new Performance(10, 10, 0xFFFFFF));
        
        final refreshRate:Int = FlxG.stage.window.displayMode.refreshRate;

        FlxG.updateFramerate = refreshRate;

        FlxG.drawFramerate = refreshRate;
        
        #if DISCORD_ALLOWED
            Presence.initialize("1198052399298924584");
            
            FlxG.stage.application.window.onClose.add(() -> Presence.close());
        #end

        FlxG.switchState(nextState);
    }
}