package backend;

#if !MODS_ALLOWED
    #error "This class is not available on this platform!";
#end

import haxe.Json;

import sys.FileSystem;

import sys.io.File;

class Mods
{
    public var list(default, never):Array<{name:String}>;

    @:noCompletion
    function get_list():Array<{name:String}>
    {
        var list:Array<{name:String}> = new Array<{name:String}>();

        for (i in FileSystem.readDirectory("mods"))
        {
            if (FileSystem.exists('mods/$i/pack.json'))
            {
                var pack:{name:String} = Json.parse(File.getContent('mods/$i/pack.json'));

                if (!Reflect.fields(pack).contains("name"))
                    continue;

                for (o in list)
                {
                    if (pack.name == o.name)
                        continue;
                }

                list.push(pack);
            }
        }

        return list;
    }

    public static function exists(name:String):Bool
    {
        for (pack in list)
            if (pack.name == name)
                return true;
        
        return false;
    }
}