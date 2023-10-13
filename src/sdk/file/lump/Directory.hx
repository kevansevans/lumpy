package sdk.file.lump;

import haxe.ui.components.Label;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.components.TextField;
import haxe.ui.events.UIEvent;
import sdk.data.lumps.T_Directory;
import sdk.enums.Lump;

/**
 * ...
 * @author Kaelan
 */
class Directory extends LumpBase 
{
	public var lumps:Array<LumpBase>;
	
	public function new(_name:String) 
	{
		super();
		
		name = _name;
		type = Lump.E_Directory;
		lumps = new Array();
	}
	
	override public function getUIBox():Box 
	{
		var container = new Box();
		container.text = this.name;
		
		var alignment:HBox = new HBox();
		container.addComponent(alignment);
		
		var label:Label = new Label();
		alignment.addComponent(label);
		label.text = "Folder name: ";
		
		var input:TextField = new TextField();
		input.value = this.name;
		alignment.addComponent(input);
		
		input.onChange = function(_event:UIEvent)
		{
			this.name = input.value;
			this.treeNode.value = input.value;
			this.uiComponent.text = input.value;
		}
		
		return container;
	}
	
	override public function toObject():Any
	{
		var data:T_Directory = 
		{
			type : "Directory",
			name : this.name
		};
		
		if (lumps.length == 0) return data;
		
		data.lumps = new Array();
		
		for (lump in this.lumps)
		{
			var ldata = lump.toObject();
			data.lumps.push(ldata);
		}
		
		return data;
	}
	
	override public function toString():String 
	{
		return 'Directory ${name} with ${lumps.length} lump(s)';
	}
}