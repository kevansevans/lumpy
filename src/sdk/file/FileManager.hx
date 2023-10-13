package sdk.file;

import sdk.data.lumps.T_Directory;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.io.Bytes;

import haxe.zip.Entry;
import haxe.crypto.Crc32;
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
		if (!FileSystem.isDirectory('./projtemp')) FileSystem.createDirectory('./projtemp');
	}
	
	public function saveProject(_data:T_Directory)
	{
		var data = Json.stringify(_data, '\t');
		
		File.saveBytes('./projtemp/projtemp.json', Bytes.ofString(data));
	}
	
	public function newBuildFolder():String
	{
		if (!FileSystem.isDirectory('./builds')) FileSystem.createDirectory('./builds');
		
		var date = '' + '${StringTools.lpad("" + Date.now().getDay(), "0", 2)}' + '${months[Date.now().getMonth()]}' + '${Date.now().getFullYear()}';
		
		var path = './builds/${date}/';
		FileSystem.createDirectory(path);
		
		return path;
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
	
	public function zipLumps(_path:String)
	{
		var zipstuff = buildZip(_path);
		
		var out = File.write('./builds/MyCoolWad.pk3', true);
		var zip = new Writer(out);
		
		zip.write(zipstuff);
		out.close();
	}
	
	function buildZip(_path:String, _entries:List<Entry> = null, _inDir:Null<String> = null)
	{
		if (_entries == null) _entries = new List();
		if (_inDir == null) _inDir = _path;
		
		for (file in getItems(_path))
		{
			var path = _path + './$file';
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
}