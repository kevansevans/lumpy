package sdk;

import haxe.crypto.Crc32;
import haxe.io.Path;
import haxe.ui.events.MouseEvent;
import haxe.zip.Entry;
import haxe.zip.Writer;
import hxd.System;
import sdk.file.FileManager;
import sdk.data.ProjectConfig;
import sys.FileSystem;
import sys.io.File;

import sdk.file.lump.*;
import sdk.data.lumps.*;

import sdk.enums.Lump;

/**
 * ...
 * @author Kaelan
 */
class ZProject 
{
	public static var config:ProjectConfig;
	
	public var gameinfo:GameInfo;
	public var root:Directory;
	
	var filemanager:FileManager;
	
	public var activedata:Dynamic;
	public var lump:LumpBase;
	
	public function new() 
	{
		filemanager = new FileManager();
		
		root = new Directory("WAD");
		
		gameinfo = new GameInfo();
	}
	
	public function saveProject()
	{
		root.lumps.push(gameinfo);
		
		var data:Any = root.toObject();
		
		filemanager.saveProject(data);
	}
	
	public function buildProject(_launch:Bool = false)
	{
		var path = filemanager.newBuildFolder();
		
		exportLumpBytes(root, path);
		
		filemanager.zipLumps(path);
		
		if (_launch)
		{
			System.openURL('./builds/MyCoolWad.pk3');
		}
	}
	
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
	
	public function init()
	{
		Main.FileTreeObj.create(root);
		
		Main.FileEditorObj.manualTabAddition(gameinfo);
		
		var tree = Main.FileTreeObj.tree;
		
		tree.onClick = function(_event:MouseEvent)
		{
			if (tree.selectedNode == null) return;
			
			#if debug
			trace(tree.selectedNode.data);
			#end
			
			activedata = tree.selectedNode.data;
			lump = cast activedata.lump;
			
			if (lump.isOpen) {
				Main.FileEditorObj.tabview.selectedPage = lump.uiComponent;
				return;
			}
			
			lump.isOpen = true;
			var boxobject = lump.getUIBox();
			
			lump.uiComponent = boxobject;
			
			Main.FileEditorObj.tabview.addComponent(boxobject);
			Main.FileEditorObj.tabview.selectedPage = boxobject;
		}
	}
}