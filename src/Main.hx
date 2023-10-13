package;

import haxe.ui.backend.ToolkitOptions;
import haxe.ui.containers.HorizontalSplitter;
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
	
	public static var w_width:Int;
	public static var w_height:Int;
	
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
	
	var split:HorizontalSplitter;
	
	override function init() 
	{
		super.init();
		
		Res.initLocal();
		
		Toolkit.screen.root = s2d;
		split = new HorizontalSplitter();
		split.verticalAlign = "Center";
		Toolkit.screen.addComponent(split);
		
		FileBarObj = new FileBar();
		
		FileTreeObj = new FileTree();
		split.addComponent(FileTreeObj.tree);
		
		FileEditorObj = new FileEditor();
		split.addComponent(FileEditorObj.tabview);
		
		onResize();
		
		Main.project.init();
	}
	
	override function update(dt:Float) 
	{
		super.update(dt);
		
		Main.w_width = engine.width;
		Main.w_height = engine.height;
	}
	
	override function onResize()
	{
		super.onResize();
		
		trace(engine.width);
		
		split.x = 5;
		split.y = 45;
		split.width = engine.width - 10;
		split.height = engine.height - 50;
		
		FileBarObj.resize(engine.width, 40);
		FileTreeObj.tree.height = engine.height - 50;
		FileEditorObj.tabview.height = engine.height - 50;
	}
}