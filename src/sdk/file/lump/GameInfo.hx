package sdk.file.lump;

import haxe.Json;
import haxe.io.Bytes;
import haxe.ui.components.CheckBox;
import haxe.ui.components.ColorPicker;
import haxe.ui.components.DropDown;
import haxe.ui.components.Label;
import haxe.ui.components.TextArea;
import haxe.ui.components.TextField;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.HorizontalSplitter;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.Splitter;
import haxe.ui.containers.VBox;
import haxe.ui.containers.VerticalSplitter;
import haxe.ui.data.DataSource;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import sdk.data.lumps.T_GameInfo;
import haxe.ui.components.Button;
import sdk.enums.Lump;

/**
 * ...
 * @author Kaelan
 */
class GameInfo extends LumpBase
{
	public var iwad:Null<String>;
	public var load:Array<String>;
	public var noSpriteRename:Null<Bool>;
	public var startupTitle:Null<String>;
	public var backColor:String;
	public var foreColor:String;
	public var titlecolor:Bool;
	public var startupType:Null<String>;
	public var startupSong:Null<String>;
	public var loadLights:Null<Bool>;
	public var loadBrightmaps:Null<Bool>;
	public var loadWidescreen:Null<Bool>;
	public var discordAppID:Null<String>;
	public var steamAppID:Null<String>;
	
	public function new() 
	{
		super();
		
		type = Lump.E_GameInfo;
		name = "GAMEINFO";
		wikipage = "https://zdoom.org/wiki/GAMEINFO";
		ext = 'txt';
		
		load = new Array();
	}
	
	var split:HorizontalSplitter;
	
	override public function toString():String 
	{
		return "Gameinfo";
	}
	
	override public function toLumpFile():Null<Bytes> 
	{
		var data:String = '';
		
		if (iwad != null) data += 'IWAD = "$iwad"\n';
		if (load.length != 0)
		{
			data += 'LOAD = ';
			for (item in load)
			{
				data += '"${item}"';
				if (load.indexOf(item) != load.length - 1) data += ',';
			}
			data += '\n';
		}
		if (noSpriteRename != null) data += 'NOSPRITERENAME = ' + (noSpriteRename == true ? "true\n" : "false\n");
		if (startupTitle != null) data += 'STARTUPTITLE = ' + '"${startupTitle}"\n';
		if (titlecolor)
		{
			var fore = '${foreColor.substr(1, 6)}';
			var back = '${backColor.substr(1, 6)}';
			data += 'STARTUPCOLORS = "${fore}", "${back}"\n';
		}
		
		//Fix startup type here, weird fucking bullshit
		
		if (startupSong != null) data += 'STARTUPSONG = "${startupSong}"\n';
		if (loadLights) data += 'LOADLIGHTS = ${loadLights == true ? 1 : 0}\n';
		if (loadBrightmaps) data += 'LOADBRIGHTMAPS = ${loadBrightmaps == true ? 1 : 0}\n';
		if (loadWidescreen) data += 'LOADWIDESCREEN = ${loadWidescreen == true ? 1 : 0}\n';
		if (discordAppID != null) data += 'DISCORDAPPID = "${discordAppID}"\n';
		if (steamAppID != null) data += 'STEAMAPPID = "${steamAppID}"\n';
		
		return Bytes.ofString(data);
	}
	
	override public function getUIBox():Box 
	{
		var container = new Box();
		container.text = "Gameinfo";
		container.percentWidth = 100;
		container.percentHeight = 100;
		
		split = new HorizontalSplitter();
		container.addComponent(split);
		split.percentWidth = 100;
		split.percentHeight = 100;
		
		var aligner:ScrollView = new ScrollView();
		split.addComponent(aligner);
		
		var iwad_box:HBox = new HBox();
		var iwad_label:Label = new Label();
		iwad_label.text = "IWAD: ";
		iwad_box.addComponent(iwad_label);
		var iwad_input:TextField = new TextField();
		iwad_box.addComponent(iwad_input);
		iwad_input.onChange = function(_event:UIEvent)
		{
			if (iwad_input.value == "") iwad = null;
			else iwad = iwad_input.value;
		}
		aligner.addComponent(iwad_box);
		
		var load_box:HBox = new HBox();
		var load_label:Label = new Label();
		load_label.text = "LOAD: ";
		load_box.addComponent(load_label);
		var load_input:TextField = new TextField();
		load_input.onChange = function(_event:UIEvent)
		{
			var input:String = load_input.value;
			var items:Array<String> = input.split(',');
			if (items.length == 1)
			{
				if (items[0] == "") 
				{
					load = new Array();
					return;
				}
			}
			
			load = items.copy();
		}
		load_box.addComponent(load_input);
		aligner.addComponent(load_box);
		
		var nosprite_box:HBox = new HBox();
		var nosprite_label:Label = new Label();
		nosprite_label.text = "No Sprite Rename: ";
		nosprite_box.addComponent(nosprite_label);
		var nosprite_check:CheckBox = new CheckBox();
		nosprite_box.addComponent(nosprite_check);
		nosprite_box.onChange = function(_event:UIEvent)
		{
			noSpriteRename = nosprite_check.value;
		}
		aligner.addComponent(nosprite_box);
		
		var title_box:HBox = new HBox();
		var title_label:Label = new Label();
		title_label.text = "Startup title: ";
		title_box.addComponent(title_label);
		var title_input:TextField = new TextField();
		title_input.onChange = function(_event:UIEvent)
		{
			startupTitle = title_input.value;
		}
		title_box.addComponent(title_input);
		aligner.addComponent(title_box);
		
		var color_box:HBox = new HBox();
		var color_label:Label = new Label();
		color_label.text = "Startup color";
		color_box.addComponent(color_label);
		var color_check:CheckBox = new CheckBox();
		color_box.addComponent(color_check);
		var color_fore:ColorPicker = new ColorPicker();
		color_box.addComponent(color_fore);
		color_fore.disabled = true;
		color_fore.onChange = function(_event:UIEvent)
		{
			foreColor = color_fore.currentColor.toHex();
		}
		var color_back:ColorPicker = new ColorPicker();
		color_box.addComponent(color_back);
		color_back.disabled = true;
		color_back.onChange = function(_event:UIEvent)
		{
			backColor = color_back.currentColor.toHex();
		}
		color_check.onClick = function(_event:MouseEvent)
		{
			color_fore.disabled = !color_check.value;
			color_back.disabled = !color_check.value;
			titlecolor = color_check.value;
			backColor = color_back.currentColor.toHex();
			foreColor = color_fore.currentColor.toHex();
		}
		aligner.addComponent(color_box);
		
		var starttype_box:HBox = new HBox();
		var starttype_label:Label = new Label();
		starttype_label.text = "Startup type: ";
		starttype_box.addComponent(starttype_label);
		var starttype_select:DropDown = new DropDown();
		starttype_select.dataSource = new DataSource();
		starttype_select.dataSource.add("Doom");
		starttype_select.dataSource.add("Heretic");
		starttype_select.dataSource.add("Hexen");
		starttype_select.dataSource.add("Strife");
		starttype_select.selectedItem = "Doom";
		starttype_select.onChange = function(_event:UIEvent)
		{
			//startupType = starttype_select.selectedItem.value;
		}
		starttype_box.addComponent(starttype_select);
		aligner.addComponent(starttype_box);
		
		var startsong_box:HBox = new HBox();
		var startsong_label:Label = new Label();
		startsong_label.text = "Startup song: ";
		startsong_box.addComponent(startsong_label);
		var startsong_input:TextField = new TextField();
		startsong_box.addComponent(startsong_input);
		startsong_input.onChange = function(_event:UIEvent)
		{
			startupSong = startsong_input.value;
		}
		aligner.addComponent(startsong_box);
		
		var loadlights_check:CheckBox = new CheckBox();
		loadlights_check.text = "Load lights";
		aligner.addComponent(loadlights_check);
		loadlights_check.onChange = function(_event:UIEvent)
		{
			loadLights = loadlights_check.value;
		}
		
		var loadbright_check:CheckBox = new CheckBox();
		loadbright_check.text = "Load brightmaps";
		aligner.addComponent(loadbright_check);
		loadbright_check.onChange = function(_event:UIEvent)
		{
			loadBrightmaps = loadbright_check.value;
		}
		
		var loadwide_check:CheckBox = new CheckBox();
		loadwide_check.text = "Load widescreen graphics";
		aligner.addComponent(loadwide_check);
		loadwide_check.onChange = function(_event:UIEvent)
		{
			loadWidescreen = loadwide_check.value;
		}
		
		var discord_box:HBox = new HBox();
		var discord_label:Label = new Label();
		discord_label.text = "Discord App ID";
		discord_box.addComponent(discord_label);
		var discord_input:TextField = new TextField();
		discord_box.addComponent(discord_input);
		discord_input.onChange = function(_event:UIEvent)
		{
			discordAppID = discord_input.value;
		}
		aligner.addComponent(discord_box);
		
		var steam_box:HBox = new HBox();
		var steam_label:Label = new Label();
		steam_label.text = "Steam App ID";
		steam_box.addComponent(steam_label);
		var steam_input:TextField = new TextField();
		steam_box.addComponent(steam_input);
		aligner.addComponent(steam_box);
		steam_input.onChange = function(_event:UIEvent)
		{
			steamAppID = steam_input.value;
		}
		
		aligner.addComponent(wikibutton);
		
		//var previewScroll:ScrollView = new ScrollView();
		//split.addComponent(previewScroll);
		
		return container;
	}
	
	override public function toObject():Null<Any>
	{
		var data:T_GameInfo = 
		{
			type : "Gameinfo",
			name : this.name
		};
		
		if (this.iwad != null) data.iwad = this.iwad;
		if (this.load != null)
		{
			if (this.load.length != 0) data.load = this.load.copy();
		}
		if (titlecolor)
		{
			data.foreColor = this.foreColor;
			data.backColor = this.backColor;
		}
		if (this.noSpriteRename != null) data.noSpriteRename = this.noSpriteRename;
		if (this.startupTitle != null) data.startupTitle = this.startupTitle;
		if (this.startupType != null) data.startupType = this.startupType;
		if (this.startupSong != null) data.startupSong = this.startupSong;
		if (this.loadLights != null) data.loadLights = this.loadLights;
		if (this.loadBrightmaps != null) data.loadBrightmaps = this.loadBrightmaps;
		if (this.loadWidescreen != null) data.loadWidescreen = this.loadWidescreen;
		if (this.discordAppID != null) data.discordAppID = this.discordAppID;
		
		return data;
	}
}