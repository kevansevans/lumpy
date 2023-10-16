package sdk.file.lump;

import haxe.io.Bytes;
import haxe.ui.components.CheckBox;
import haxe.ui.components.TextField;
import haxe.ui.containers.Box;
import haxe.ui.containers.Grid;
import haxe.ui.containers.HBox;
import haxe.ui.containers.HorizontalSplitter;
import haxe.ui.containers.ListView;
import haxe.ui.containers.ScrollView;
import haxe.ui.containers.Splitter;
import haxe.ui.containers.VBox;
import haxe.ui.containers.VerticalSplitter;
import haxe.ui.containers.properties.Property;
import haxe.ui.containers.properties.PropertyGrid;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.core.ItemRenderer;
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
	public function new() 
	{
		super();
		
		type = Lump.E_GameInfo;
		name = "GAMEINFO";
		wikipage = "https://zdoom.org/wiki/GAMEINFO";
		ext = 'txt';
		
		var ginfo:T_GameInfo =
		{
			include : true
		};
		object = ginfo;
		ZProject.config.gameinfo = ginfo;
	}
	
	var split:HorizontalSplitter;
	
	override public function toString():String 
	{
		return "Gameinfo";
	}
	
	override public function toLumpFile():Null<Bytes> 
	{
		var data:String = '';
		
		if (object.iwad != null) data += 'IWAD = "' + object.iwad + '"\n';
		
		return Bytes.ofString(data);
	}
	
	override public function getUIBox():Box 
	{
		var container = new Box();
		container.text = "Gameinfo";
		container.percentWidth = 100;
		container.percentHeight = 100;
		
		var scroll:ScrollView = new ScrollView();
		scroll.width = 400;
		scroll.percentHeight = 100;
		container.addComponent(scroll);
		
		var iwad_grid:Grid = new Grid();
		iwad_grid.verticalAlign = "center";
		iwad_grid.columns = 2;
		iwad_grid.width = 390;
		var iwad_check:CheckBox = new CheckBox();
		iwad_check.percentWidth = 50;
		iwad_check.text = "IWAD";
		iwad_grid.addComponent(iwad_check);
		var iwad_input:TextField = new TextField();
		iwad_grid.addComponent(iwad_input);
		iwad_input.onChange = iwad_check.onChange = function(_event:UIEvent)
		{
			if (iwad_check.value == false || iwad_input.value == "")
			{
				object.iwad = null;
				return;
			}
			
			object.iwad = iwad_input.value;
		}
		scroll.addComponent(iwad_grid);
		
		var title_grid:Grid = new Grid();
		title_grid.width = 390;
		var title_check:CheckBox = new CheckBox();
		title_check.percentWidth = 50;
		title_check.text = "Startup Title";
		title_grid.addComponent(title_check);
		
		scroll.addComponent(title_grid);
		
		return container;
	}
}