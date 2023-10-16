package sdk.file.lump;
import haxe.io.Bytes;
import haxe.ui.components.Button;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import hxd.System;
import sdk.enums.Lump;

/**
 * ...
 * @author Kaelan
 */
class LumpBase 
{
	public var type:Lump;
	public var object(get, null):Dynamic;
	
	public var name:String;
	public var isOpen:Bool;
	public var treeNode:TreeViewNode;
	public var uiComponent:Box;
	
	public var wikibutton:Button;
	public var wikipage:String = "https://zdoom.org/wiki/Main_Page";
	
	public var ext:String = '.unknown';
	
	public function new() 
	{
		type - Lump.E_UndefinedLump;
		
		wikibutton = new Button();
		wikibutton.text = "View Wiki";
		wikibutton.onClick = function(_event:MouseEvent)
		{
			System.openURL(wikipage);
		}
	}
	
	public function toString():String
	{
		return "Undefinded toString here!";
	}
	
	public function toLumpFile():Null<Bytes>
	{
		trace('No bytes defined here!');
		return null;
	}
	
	public function setData(_input:Any)
	{
		trace("Null setData here!");
	}
	
	function get_object():Dynamic 
	{
		return {};
	}
	
	public function getUIBox():Box
	{
		var box:Box = new Box();
		box.text = "Null Fucking Object dumbass";
		
		return box;
	}
}