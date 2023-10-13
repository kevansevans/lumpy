package ui;

import h3d.Engine;
import haxe.ui.Toolkit;
import haxe.ui.components.Button;
import haxe.ui.containers.menus.Menu;
import haxe.ui.containers.menus.MenuBar;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.containers.menus.MenuSeparator;
import haxe.ui.events.UIEvent;

/**
 * ...
 * @author Kaelan
 */
class FileBar extends ZD_UI
{

	var bar:MenuBar;
	/**/var m_File:Menu;
	/*	*/var mi_NewProject:MenuItem;
	/*	*/var mi_LoadProject:MenuItem;
	/*	*/var mi_LoadRecent:Menu;
	/*	*******************/
	/*	*/var mi_SaveProject:MenuItem;
	/*	*/var mi_SaveAsProject:MenuItem;
	/*	*******************/
	/*	*/var mi_Export:Button; //Move me into dedicated "build" button
	/*	*/var mi_Deploy:Button; //Move me into dedicated "build" button
	/**/var m_Edit:Menu;
	/**/var m_View:Menu;
	
	public function new() 
	{
		super();
		
		bar = new MenuBar();
		
		m_File = new Menu();
		m_File.text = "File";
		bar.addComponent(m_File);
		
		mi_NewProject = new MenuItem();
		mi_NewProject.text = "New Project";
		m_File.addComponent(mi_NewProject);
		
		mi_LoadProject = new MenuItem();
		mi_LoadProject.text = "Load Project";
		m_File.addComponent(mi_LoadProject);
		
		mi_LoadRecent= new Menu();
		mi_LoadRecent.text = "Load Recent";
		m_File.addComponent(mi_LoadRecent);
		
		m_File.addComponent(new MenuSeparator());
		
		mi_SaveProject = new MenuItem();
		mi_SaveProject.text = "Save Project";
		m_File.addComponent(mi_SaveProject);
		mi_SaveProject.onClick = function(_event:UIEvent)
		{
			Main.project.saveProject();
		}
		
		mi_SaveAsProject = new MenuItem();
		mi_SaveAsProject.text = "Save As...";
		m_File.addComponent(mi_SaveAsProject);
		
		m_File.addComponent(new MenuSeparator());
		
		mi_Export = new Button();
		mi_Export.text = "Build";
		bar.addComponent(mi_Export);
		mi_Export.onClick = function(_event:UIEvent)
		{
			Main.project.buildProject();
		}
		
		mi_Deploy = new Button();
		mi_Deploy.text = "Run";
		bar.addComponent(mi_Deploy);
		mi_Deploy.onClick = function(_event:UIEvent)
		{
			Main.project.buildProject(true);
		}
		
		Toolkit.screen.addComponent(bar);
	}
	
	override public function resize(_width:Int, _height:Int) 
	{
		bar.width = _width;
	}
}