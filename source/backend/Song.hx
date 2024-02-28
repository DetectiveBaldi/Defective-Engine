package backend;

import haxe.Json;
import haxe.PosInfos;

#if html5
    import openfl.utils.Assets;
#else
    import sys.FileSystem;

    import sys.io.File;
#end

typedef Section =
{
    var notes:Array<{time:Float, noteData:Int}>;
}

class Song
{
    public var name:String;
    
    public var sections:Array<Section>;

    public function new():Void
    {
        sections = new Array<Section>();
    }

    public static function fromFile(key:String, ?_:PosInfos):Song
    {
        #if html5
            if (!Assets.exists(key))
        #else
            if (!FileSystem.exists(key))
        #end
        {
            trace('File with key "${key}" does not exist! (${_.className}, ${_.lineNumber})');

            return null;
        }

        var content:{sections:Array<Section>} = Json.parse(#if html5 Assets.getText(key) #else File.getContent(key) #end);

        for (field in Type.getInstanceFields(Song))
        {
            if (!Reflect.hasField(content, field))
            {
                trace('File with key "${key}" is missing crucial data! (${_.className}, ${_.lineNumber})');

                return null;
            }
        }

        var song:Song = new Song();

        song.sections = content.sections;

        return song;
    }
}