// https://keyreal-code.github.io/haxecoder-tutorials/17_displaying_fps_and_memory_usage_using_openfl.html

package backend;

import haxe.Timer;

import openfl.system.System;

import openfl.text.TextField;
import openfl.text.TextFormat;

import flixel.FlxG;

import flixel.math.FlxMath;

class Performance extends TextField
{
    var current:Map<Int, Float>;

    @:noCompletion
    var times:Array<Float>;

    public function new(x:Float = 0, y:Float = 0, color:Int = 0x000000):Void
    {
        super();

        this.x = x;

        this.y = y;

        width = 250;

        height = 250;

        defaultTextFormat = new TextFormat("_sans", 12, color);

        selectable = false;

        current = new Map<Int, Float>();

        current.set(5, 0);

        current.set(15, 0);

        current.set(25, 0);

        times = new Array<Float>();
    }

    @:noCompletion
    override function __enterFrame(deltaTime:Int):Void
    {
        super.__enterFrame(deltaTime);

        var now:Float = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

        current.set(5, times.length);

        current.set(15, System.totalMemory);

        if (System.totalMemory > current.get(25))
            current.set(25, System.totalMemory);

        text = 'FPS: ${current.get(5) > FlxG.updateFramerate ? Std.string(FlxG.updateFramerate) + "+" : Std.string(current.get(5))}\nMemory: ${Std.string(FlxMath.roundDecimal(current.get(15) / Math.pow(1024, 2), 2))} MB (${Std.string(FlxMath.roundDecimal(current.get(25) / Math.pow(1024, 2), 2))} MB)';
    }
}