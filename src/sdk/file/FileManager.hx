package sdk.file;

import haxe.io.BytesOutput;
import haxe.io.Output;
import hxd.Save;
import hxd.System;
import sdk.data.lumps.T_Directory;
import sdk.file.lump.Directory;
import sdk.enums.Lump;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

#if js
import js.lib.ArrayBuffer;
import js.html.Blob;
import js.Browser;
import js.html.URL;
import haxe.Timer;
#end
import haxe.Json;
import haxe.io.Bytes;

import haxe.zip.Entry;
import haxe.zip.Writer;

/**
 * ...
 * @author Kaelan
 */
class FileManager 
{
	static var months:Array<String> = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
	
	public function new() 
	{
		#if sys
		if (!FileSystem.isDirectory('./projtemp')) FileSystem.createDirectory('./projtemp');
		#end
	}
	
	public function saveProject(_data:T_Directory)
	{
		var data = Json.stringify(_data, '\t');
		
		var projname = './projtemp/projtemp.json';
		
		#if sys
		File.saveBytes(projname, Bytes.ofString(data));
		#elseif js
		Save.save(data, "projtemp");
		#end
	}
	
	public function newBuildFolder():String
	{
		#if sys
		if (!FileSystem.isDirectory('./builds')) FileSystem.createDirectory('./builds');
		
		var date = '' + '${StringTools.lpad("" + Date.now().getDay(), "0", 2)}' + '${months[Date.now().getMonth()]}' + '${Date.now().getFullYear()}';
		
		var path = './builds/${date}/';
		FileSystem.createDirectory(path);
		
		return path;
		#elseif js
		return '';
		#end
	}
	
	#if sys
	public function zipLumps(_path:String)
	{
		var zipstuff = buildZip(_path);
		
		var out = File.write('./builds/MyCoolWad.pk3', true);
		var zip = new Writer(out);
		
		zip.write(zipstuff);
		out.close();
		
	}
	
	public function makeDirectory(_path:String)
	{
		FileSystem.createDirectory(_path);
	}
	
	public function writeFile(_path:String, _bytes:Bytes)
	{
		if (_bytes == null) throw "Kev you fucked up, never let the user see this!";
		File.saveBytes(_path, _bytes);
	}
	
	public function getItems(_path:String):Array<String>
	{
		return FileSystem.readDirectory(_path);
	}
	
	public function isFolder(_path:String):Bool
	{
		return FileSystem.isDirectory(_path);
	}
	
	public function getFileBytes(_path:String):Bytes
	{
		return Bytes.ofData(File.getBytes(_path).getData());
	}
	
	function buildZip(_path:String, _entries:List<Entry> = null, _inDir:Null<String> = null)
	{
		if (_entries == null) _entries = new List();
		if (_inDir == null) _inDir = _path;
		
		for (file in getItems(_path))
		{
			var path = _path + '/$file';
			if (isFolder(path))
			{
				buildZip(path, _entries, _inDir);
				continue;
			}
			
			var bytes = getFileBytes(path);
			
			var entry:Entry =
			{
				fileName : StringTools.replace(path, _inDir, ""),
				fileSize : bytes.length,
				fileTime : Date.now(),
				compressed : false,
				dataSize : FileSystem.stat(path).size,
				data : bytes,
				crc32 : null
			};
			
			_entries.push(entry);
		}
		
		return _entries;
	}
	#end
	
	#if js
	
	public function zipLumps(_dir:Directory)
	{
		var zipstuff = buildZip(_dir);
		
		var out:BytesOutput = new BytesOutput();
		var zip = new Writer(out);
		
		zip.write(zipstuff);
		downloadFile(out.getBytes(), 'MyCoolWad.zip');
	}
	
	function buildZip(_dir:Directory, _entries:List<Entry> = null, _inDir:Null<String> = null)
	{
		if (_entries == null) _entries = new List();
		if (_inDir == null) _inDir = '';
		
		for (lump in _dir.lumps)
		{
			if (lump.type == Lump.E_Directory)
			{
				var path = _inDir + lump.name;
				buildZip(cast lump, _entries, path + '/');
				continue;
			}
			
			var bytes:Bytes = lump.toLumpFile();
			var filename = _inDir + lump.name.toUpperCase() + '.' + lump.ext;
			var entry:Entry =
			{
				fileName : filename,
				fileSize : bytes.length,
				fileTime : Date.now(),
				compressed : false,
				dataSize : bytes.length,
				data : bytes,
				crc32 : null
			};
			
			_entries.push(entry);
		}
		
		return _entries;
	}
	
	public function downloadFile(_bytes:Bytes, _name:String) 
	{
		var buffer:ArrayBuffer = _bytes.getData();
		var file:Blob = new Blob([buffer]);
		var a = Browser.document.createAnchorElement();
		var url = URL.createObjectURL(file);
		a.href = url;
		a.download = _name;
		Browser.document.body.appendChild(a);
		a.click();
		var timer = Timer.delay(function() {
			Browser.document.body.removeChild(a);
			URL.revokeObjectURL(url);
		}, 0);
	}
	#end
}