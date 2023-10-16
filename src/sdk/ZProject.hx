package sdk;

import haxe.ui.events.MouseEvent;
import hxd.System;
import sdk.file.FileManager;
import sdk.data.ProjectConfig;

import sdk.file.lump.*;
import sdk.data.lumps.*;

import sdk.enums.Lump;

/**
 * ...
 * @author Kaelan
 */
class ZProject 
{
	public static var config:Dynamic;
	
	public var gameinfo:GameInfo;
	public var root:Directory;
	
	var filemanager:FileManager;
	
	public var activedata:Dynamic;
	public var lump:LumpBase;
	
	public function new() 
	{
		config = {};
		
		filemanager = new FileManager();
		
		root = new Directory("WAD");
		
		gameinfo = new GameInfo();
		root.lumps.push(gameinfo);
	}
	
	public function saveProject()
	{
		filemanager.saveProject();
	}
	
	public function buildProject(_launch:Bool = false)
	{
		#if sys
		var path = filemanager.newBuildFolder();
		
		exportLumpBytes(root, path);
		
		filemanager.zipLumps(path);
		
		if (_launch)
		{
			System.openURL('./builds/MyCoolWad.pk3');
		}
		
		#elseif js
		filemanager.zipLumps(root);
		#end
	}
	
	#if sys
	function exportLumpBytes(_folder:Directory, _path:String)
	{
		for (lump in _folder.lumps)
		{
			switch (lump.type)
			{
				case Lump.E_Directory:
					var path = _path + './${lump.name}/';
					filemanager.makeDirectory(path);
					exportLumpBytes(cast lump, path);
					continue;
				case Lump.E_UndefinedLump:
					trace('Lump has not been defined correctly!');
				default:
					var bytes = lump.toLumpFile();
					var path = _path + '${lump.name}.${lump.ext}';
					filemanager.writeFile(path, bytes);
			}
		}
	}
	#end
	
	public function init()
	{
		Main.FileTreeObj.create(root);
		
		var tree = Main.FileTreeObj.tree;
		var editor = Main.FileEditorObj.tabview;
		
		tree.onClick = function(_event:MouseEvent)
		{
			if (tree.selectedNode == null) return;
			
			#if debug
			trace(tree.selectedNode.data);
			#end
			
			activedata = tree.selectedNode.data;
			lump = cast activedata.lump;
			
			if (lump.isOpen) {
				editor.selectedPage = lump.uiComponent;
				return;
			}
			
			lump.isOpen = true;
			var boxobject = lump.getUIBox();
			
			lump.uiComponent = boxobject;
			
			editor.addComponent(boxobject);
			editor.selectedPage = boxobject;
		}
	}
}