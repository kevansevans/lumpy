package ui;

import h3d.Engine;
import haxe.ui.containers.TabView;
import haxe.ui.Toolkit;
import haxe.ui.containers.Box;

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
		Toolkit.screen.addComponent(tabview);
		
		var welcomebox:Box = new Box();
		welcomebox.text = "Welcome!";
		tabview.addComponent(welcomebox);
	}
	
	override public function resize(_engine:Engine) 
	{
		super.resize(_engine);
		
		tabview.x = 305;
		tabview.y = 45;
		tabview.width = _engine.width - 310;
		tabview.height = _engine.height - 50;
	}
}