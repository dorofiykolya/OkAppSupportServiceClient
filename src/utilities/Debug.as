package utilities
{
	import flash.system.Capabilities;
	
	import mx.utils.ObjectUtil;
	

	/**
	 * ...
	 * @author dorofiy
	 */
	public class Debug
	{
		private static var removeAt:RegExp = /^\s*at\s*/i;
		private static var matchFile:RegExp = /[(][)][\[][^:]*?:[0-9]+[\]]\s*$/i;
		private static var trimFile:RegExp = /[()\[\]\s]*/ig;
		
		public static const PATH:String = '#pathFile';
		public static const UNPACK:String = '#unpack';
		public static var Unpack:Boolean = false;
		public static var showPathFile:Boolean = false;
		
		private static function formatToString(val:*, unp:Boolean = false):String {
			if (val == null)
				return "null";
			if (val == undefined)
				return "undefined";
			if (unp) {
				return ObjectUtil.toString(val);
			}
			if(val != String && val != Number && val != Boolean && Unpack){
				return ObjectUtil.toString(val);
			}
			return val.toString();
		}
		
		private static function removePath(value:String):String {
			var fi:int = value.indexOf('[')
			var li:int = value.indexOf(']', fi);
			var temp:String = value;
			value = value.substring(0, fi);
			value += temp.substring(li, temp.length - 1);
			return value;
		}
		
		private static function getStack(... params):String {
			var unp:Boolean;
			for each(var o:Object in params) {
				if ((o as String) == UNPACK) {
					unp = true;
					break;
				}
			}
			var s:String = new Error().getStackTrace();
			var func:String = "_func_";
			var file:String = "_file_";
			var args:String = null;
			var line:String = '_line_';
			if (s)
			{
				func = s.split("\n")[4];
				func = func.replace(removeAt, "");
				//var farr:Array = func.match(matchFile);
				//if (farr != null && farr.length > 0)
					//file = farr[0].replace(trimFile, "");
				func = func.replace(matchFile, "");
				var l:int = func.search(/\d{0,5}]/);
				if (l != -1) {
					line = (func.substring(l, func.indexOf(']', l)));
					while (line.length < 4) {
						line = " " + line;
					}
					if (params[0] == PATH || showPathFile == false) {
						func = removePath(func);
					}
				}
			}
			for each (var param:* in params)
			{
				args = (args == null ? "" : args.concat(", "));
				args = args.concat(formatToString(param, unp));
			}
			return line + " " + func + " trace:" + (args == null ? "" : args);// + "[->at " + file + "<-]";
		}
		
		public static function Stack(...params):String {
			if (Capabilities.isDebugger == false) return "Capabilities.isDebugger == false";
			return getStack.apply(null, params);
		}
		
		public static function Trace(...params):void {
			var message:String = getStack.apply(null, params);
			trace(message);
		}
		public static function Exception(e:Error):void {
			var message:String = getStack("errorID: " + e.errorID ,"name: " + e.name, "message: " + e.message, "stackTrace: " + e.getStackTrace());
			trace(message);
		}
		
		public static function Remote(...params):void {
			var message:String = getStack.apply(null, params);
			DebugRemote.Send(message);
		}
	
	}

}