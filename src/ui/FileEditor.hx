package ui;

import h3d.Engine;
import haxe.ui.containers.TabView;
import haxe.ui.Toolkit;
import haxe.ui.containers.Box;
import haxe.ui.events.UIEvent;
import sdk.file.lump.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class FileEditor extends ZD_UI 
{

	public var tabview:TabView;
	
	public function new() 
	{
		super();
		
		tabview = new TabView();
		
		var welcomebox:Box = new Box();
		welcomebox.text = "Welcome!";
		tabview.addComponent(welcomebox);
		
		tabview.percentWidth = 100;
		tabview.percentHeight = 100;
	}
	
	public function manualTabAddition(_lump:LumpBase)
	{
		tabview.addComponent(_lump.getUIBox());
	}
	
	override public function resize(_width:Int, _height:Int) 
	{
		tabview.x = 305;
		tabview.y = 45;
	}
}