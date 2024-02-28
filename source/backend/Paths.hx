package backend;

import haxe.PosInfos;

#if html5
    import openfl.utils.Assets;
#else
    import sys.FileSystem;
#end

import openfl.display.BitmapData;

import openfl.media.Sound;

import flixel.graphics.FlxGraphic;

class Paths
{
    static var graphics:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();

    static var sounds:Map<String, Sound> = new Map<String, Sound>();
    
    public static function graphic(key:String, ?_:PosInfos):FlxGraphic
    {
        if (graphics.exists(key))
            return graphics.get(key);

        #if html5
            if (!Assets.exists(key + ".png"))
        #else
            if (!FileSystem.exists(key + ".png"))
        #end
        {
            trace('This graphic is invalid! (${_.className}, ${_.lineNumber})');

            return null;
        }

        final graphic:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(key + ".png"));

        graphic.persist = true;

        graphic.destroyOnNoUse = false;

        graphics.set(key, graphic);

        return graphic;
    }

    public static function sound(key:String, ?_:PosInfos):Sound
    {
        if (sounds.exists(key))
            return sounds.get(key);

        #if html5
            if (!Assets.exists(key + ".ogg"))
        #else
            if (!FileSystem.exists(key + ".ogg"))
        #end
        {
            trace('This graphic is invalid! (${_.className}, ${_.lineNumber})');

            return null;
        }

        final sound:Sound = Sound.fromFile(key + ".ogg");

        sounds.set(key, sound);

        return sound;
    }
}