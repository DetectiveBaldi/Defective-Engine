package states.editors;

import haxe.Json;

import haxe.io.Path;

import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Spacer;
import haxe.ui.components.TextField;

import haxe.ui.containers.ContinuousHBox;
import haxe.ui.containers.VBox;
import haxe.ui.containers.TabView;

import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

import openfl.events.Event;
import openfl.events.IOErrorEvent;

import openfl.net.FileReference;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

#if DISCORD_ALLOWED
    import backend.Presence;
#end
import backend.Song;

import extendable.State;

class ChartingState extends State
{
    var nextState:NextState;

    var GRID_SIZE:Int;

    var grid:FlxSprite;

    var line:FlxSprite;

    var tabs:TabView;

    public function new(nextState:NextState):Void
    {
        super();
        
        this.nextState = nextState;
    }

    override function create():Void
    {
        super.create();

        GRID_SIZE = 40;

        var background:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(GRID_SIZE, GRID_SIZE, GRID_SIZE * 2, GRID_SIZE * 2, true, 0xFFA5A5A5, 0xFF727272));
        background.velocity.set(35, 35);
        add(background);

        grid = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16, 0xFFD8D8D8, 0xFFB2B2B2);
        add(grid);

        var separator:FlxSprite = new FlxSprite().makeGraphic(2, Std.int(grid.height), FlxColor.BLACK);
        separator.setPosition(grid.getMidpoint().x - separator.width / 2, grid.getMidpoint().y - separator.height / 2);
        add(separator);

        line = new FlxSprite().makeGraphic(Std.int(grid.width), 4);
        line.setPosition(grid.getMidpoint().x - line.width / 2, grid.getMidpoint().y - line.height / 2);
        add(line);

        FlxG.camera.follow(line);

        prepareUI();

        addAssetsTab();

        addSongTab();

        addNoteTab();

        addExportTab();

        #if DISCORD_ALLOWED
            Presence.recalculate("Chart Editor");
        #end
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
            FlxG.switchState(nextState);

        if (FlxG.keys.justPressed.R)
            FlxG.resetState();
    }

    function prepareUI():Void
    {
        tabs = new TabView();
        tabs.styleNames = "full-width-buttons";
        tabs.width = 300;
        tabs.height = 400;
        tabs.setPosition((FlxG.width - tabs.width) - 25, 25);
        add(tabs);
    }

    function addAssetsTab():Void
    {
        var tab:VBox = new VBox();

        tab.text = "Assets";

        tabs.addComponent(tab);
    }

    function addSongTab():Void
    {
        var tab:VBox = new VBox();

        tab.text = "Song";

        tabs.addComponent(tab);

        var muteInstrumental:CheckBox = new CheckBox();

        muteInstrumental.text = "Mute Instrumental";

        tab.addComponent(muteInstrumental);

        var muteVocals:CheckBox = new CheckBox();

        muteVocals.text = "Mute Vocals";

        tab.addComponent(muteVocals);
    }

    function addNoteTab():Void
    {
        var tab:VBox = new VBox();

        tab.text = "Note";

        tabs.addComponent(tab);
    }

    function addExportTab():Void
    {
        var tab:VBox = new VBox();

        tab.text = "Export";

        #if html5
            tab.disabled = true;
        #end

        tabs.addComponent(tab);

        var export:Button;

        var spacer:Spacer;

        var autoSaving:CheckBox;

        var saveInterval:TextField;

        export = new Button();

        export.text = "Export";

        export.onClick = function(i:MouseEvent):Void
        {
            var song:{name:String, sections:Array<Section>} =
            {
                name: "Test",

                sections: new Array<Section>()
            };

            var file:FileReference = new FileReference();

            file.addEventListener(Event.COMPLETE, function(o:Event):Void
            {
                file = null;
            });

            file.addEventListener(Event.CANCEL, function(o:Event):Void
            {
                file = null;
            });

            file.addEventListener(IOErrorEvent.IO_ERROR, function(u:Event):Void
            {
                file = null;
            });

            file.save(Json.stringify(song), "file.json");
        }

        tab.addComponent(export);

        spacer = new Spacer();

        spacer.height = 15;

        tab.addComponent(spacer);

        autoSaving = new CheckBox();

        autoSaving.text = "Allow AutoSaves?";

        autoSaving.onChange = function(i:UIEvent):Void
        {
            saveInterval.disabled = !autoSaving.selected;
        }

        tab.addComponent(autoSaving);

        saveInterval = new TextField();

        saveInterval.disabled = true;

        saveInterval.restrictChars = "0-9.";

        saveInterval.placeholder = "Save Interval";

        tab.addComponent(saveInterval);
    }
}