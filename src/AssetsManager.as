package  
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class AssetsManager 
	{
		[Embed(source = "assets/bookmark.png")]
		public static var bookmark:Class;
		
		public static function getTexture(name:String):Object {
			return getDefinitionByName("AssetsManager_" + name);
		}
	}

}