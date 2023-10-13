package sdk.data.lumps;

import sdk.file.lump.LumpBase;

/**
 * @author Kaelan
 */
typedef T_Directory = T_LumpBase &
{
	var ?name:String;
	var ?lumps:Array<T_Directory>;	
}