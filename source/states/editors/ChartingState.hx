package states.editors;

import haxe.Json;

import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Spacer;
import haxe.ui.components.TextField;

import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.containers.TabView;

import haxe.ui.core.Component;

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

    var tabs:Map<String, Component>;

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

        tabs = new Map<String, Component>();

        prepareUI();

        addAssetsTab();

        addAudioTab();

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
        var main:TabView = new TabView();
        main.styleNames = "full-width-buttons";
        main.width = 300;
        main.height = 400;
        main.setPosition((FlxG.width - main.width) - 25, 25);
        tabs.set("main", main);
        add(main);
    }

    function addAssetsTab():Void
    {
        var box_0:VBox = new VBox();

        box_0.text = "Assets";

        tabs.set("assets", box_0);

        tabs.get("main").addComponent(box_0);
    }

    function addAudioTab():Void
    {
        var box_0:VBox = new VBox();

        box_0.text = "Audio";

        tabs.set("audio", box_0);

        tabs.get("main").addComponent(box_0);

        /* .. .. */

        var muteInstrumental:CheckBox = new CheckBox();

        muteInstrumental.id = "muteInstrumental";

        var muteVocals:CheckBox = new CheckBox();

        muteVocals.id = "muteVocals";

        /* .. .. */

        muteInstrumental.text = "Mute Instrumental";

        box_0.addComponent(muteInstrumental);

        muteVocals.text = "Mute Vocals";

        box_0.addComponent(muteVocals);
    }

    function addSongTab():Void
    {
        var box_0:VBox = new VBox();

        box_0.text = "Song";

        tabs.set("song", box_0);

        tabs.get("main").addComponent(box_0);
    }

    function addNoteTab():Void
    {
        var box_0:VBox = new VBox();

        box_0.text = "Note";

        tabs.set("note", box_0);

        tabs.get("main").addComponent(box_0);
    }

    function addExportTab():Void
    {
        var box_0:VBox = new VBox();

        box_0.text = "Export";

        #if html5
            box_0.disabled = true;
        #end

        tabs.set("export", box_0);

        tabs.get("main").addComponent(box_0);

        /* .. .. */

        var export:Button = new Button();

        export.id = "export";

        var spacer_0:Spacer = new Spacer();

        spacer_0.id = "spacer_0";

        var autoSaving:CheckBox = new CheckBox();

        autoSaving.id = "autoSaving";

        var saveInterval:TextField = new TextField();

        saveInterval.id = "saveInterval";

        /* .. .. */

        export.text = "Export";

        export.onClick = function(e:MouseEvent):Void
        {
            var song:{name:String, sections:Array<Section>} =
            {
                name: "Test",

                sections: new Array<Section>()
            };

            var file:FileReference = new FileReference();

            file.addEventListener(Event.COMPLETE, (e:Event) -> file = null);

            file.addEventListener(Event.CANCEL, (e:Event) -> file = null);

            file.addEventListener(IOErrorEvent.IO_ERROR, (e:IOErrorEvent) -> file = null);

            file.save(Json.stringify(song), "file.json");
        }

        box_0.addComponent(export);

        spacer_0.height = 15;

        box_0.addComponent(spacer_0);

        autoSaving.text = "Allow Auto-Saving?";

        autoSaving.onChange = (e:UIEvent) -> saveInterval.disabled = !autoSaving.selected;

        box_0.addComponent(autoSaving);

        saveInterval.disabled = true;

        saveInterval.restrictChars = "0-9.";

        saveInterval.placeholder = "Save Interval";

        box_0.addComponent(saveInterval);
    }
}