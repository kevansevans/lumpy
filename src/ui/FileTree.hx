package ui;

import h3d.Engine;
import haxe.ui.containers.TreeView;
import haxe.ui.Toolkit;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.events.MouseEvent;
import sdk.file.lump.Directory;

/**
 * ...
 * @author Kaelan
 */
class FileTree extends ZD_UI
{
	public var tree:TreeView;
	
	public function new() 
	{
		super();
		
		tree = new TreeView();
		tree.percentWidth = 100;
		tree.percentHeight = 100;
	}
	
	public function create(_lump:Directory = null)
	{
		var node:TreeViewNode = tree.addNode({text : _lump.name, lump : _lump});
		_lump.treeNode = node;
		
		buildTree(_lump, node);
	}
	
	function buildTree(_dir:Directory, _node:TreeViewNode)
	{
		for (lump in _dir.lumps)
		{
			var node = _node.addNode({text : lump.name, lump : lump});
			var object:Dynamic = lump.toObject();
			if (object.type == "Directory")
			{
				buildTree(cast lump, node);
			}
			lump.treeNode = node;
			continue;
		}
	}
	
	override public function resize(_width:Int, _height:Int) 
	{
		tree.y = 45;
		tree.width = 300;
		tree.height = _height - 50;
	}
}