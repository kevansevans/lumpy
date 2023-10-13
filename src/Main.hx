package;

import haxe.ui.backend.ToolkitOptions;
import haxe.ui.containers.menus.Menu;
import haxe.ui.containers.menus.MenuBar;
import haxe.ui.containers.menus.MenuItem;
import hxd.App;
import hxd.Res;
import ui.FileBar;
import ui.FileEditor;
import ui.ZD_UI;
import ui.FileTree;

import haxe.ui.Toolkit;

import sdk.ZProject;

/**
 * ...
 * @author Kaelan
 */
class Main extends App
{
	public static var project:ZProject;
	
	public static var ui:Array<ZD_UI>;
	
	static function main() 
	{
		new Main();
		
		Toolkit.theme = "dark";
		Toolkit.init();
		
		ui = new Array();
	}
	
	public function new()
	{
		super();
		
		Main.project = new ZProject();
	}
	
	public static var FileBarObj:FileBar;
	public static var FileTreeObj:FileTree;
	public static var FileEditorObj:FileEditor;
	
	override function init() 
	{
		super.init();
		
		Res.initLocal();
		
		Toolkit.screen.root = s2d;
		
		FileBarObj = new FileBar();
		ui.push(FileBarObj);
		
		FileTreeObj = new FileTree();
		ui.push(FileTreeObj);
		
		FileEditorObj = new FileEditor();
		ui.push(FileEditorObj);
		
		onResize();
		
		Main.project.init();
	}
	
	override function onResize()
	{
		super.onResize();
		
		for (obj in ui)
		{
			obj.resize(engine);
		}
	}
}