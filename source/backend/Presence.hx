package backend;

#if !DISCORD_ALLOWED
    #error "This class is not available on this platform!";
#end

import cpp.ConstCharStar;
import cpp.ConstPointer;
import cpp.Function;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.Star;

import sys.thread.Thread;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class Presence
{
    public static var initialized(default, null):Bool;

    public static function initialize(applicationID:String):Void
    {
        if (initialized)
            return;

        var handlers:DiscordEventHandlers = DiscordEventHandlers.create();

        handlers.disconnected = Function.fromStaticFunction(onDisconnected);

        handlers.errored = Function.fromStaticFunction(onError);

        handlers.ready = Function.fromStaticFunction(onReady);

        Discord.Initialize(applicationID, RawPointer.addressOf(handlers), 1, null);

        Thread.create(function():Void
        {
            while (true)
            {
                #if DISCORD_DISABLE_IO_THREAD
                    Discord.UpdateConnection();
                #end

                Discord.RunCallbacks();

                Sys.sleep(0.5); // Wait 0.5 seconds until the next loop...
            }
        });
    }

    public static function close():Void
    {
        if (!initialized)
            return;

        Discord.Shutdown();
    }

    public static function recalculate(details:String):Void
    {
        var presence:DiscordRichPresence = DiscordRichPresence.create();

        presence.details = details;
        
        Discord.UpdatePresence(RawConstPointer.addressOf(presence));
    }

    static function onDisconnected(errorCode:Int, message:ConstCharStar):Void
    {
        trace('Discord: Disconnected ($errorCode: ${cast(message, String)})');
    }

    static function onError(errorCode:Int, message:ConstCharStar):Void
    {
        trace('Discord: Error ($errorCode: ${cast(message, String)})');
    }

    static function onReady(request:RawConstPointer<DiscordUser>):Void
    {
        var requestPtr:Star<DiscordUser> = ConstPointer.fromRaw(request).ptr;

		if (Std.parseInt(cast(requestPtr.discriminator, String)) != 0)
			trace('(Discord) Connected to User (${cast(requestPtr.username, String)}#${cast(requestPtr.discriminator, String)})');
		else
			trace('(Discord) Connected to User (${cast(requestPtr.username, String)})');
    }
}