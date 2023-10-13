package sdk.data.lumps;

/**
 * @author Kaelan
 */
typedef T_GameInfo = T_LumpBase &
{
	var ?name:String;
	
	var ?iwad:String;
	var ?load:Array<String>;
	var ?noSpriteRename:Bool;
	var ?startupTitle:String;
	var ?backColor:String;
	var ?foreColor:String;
	var ?startupType:String;
	var ?startupSong:String;
	var ?loadLights:Bool;
	var ?loadBrightmaps:Bool;
	var ?loadWidescreen:Bool;
	var ?discordAppID:String;	
}