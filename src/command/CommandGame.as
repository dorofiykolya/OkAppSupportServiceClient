package command{ 
	import core.game_internal;
	
	import flash.events.Event;
	import flash.net.Socket;
	
	import net.Connection;

	/**
	 * ...
	 * @author ...
	 */
	public class CommandGame 
	{
		
		import System.Console;
		
		import core.Config;
		import core.GlobalManager;
		import core.game_internal;
		
		import flash.display.StageQuality;
		
		import mx.utils.StringUtil;
		
		import net.log.NetLogManager;
		
		import utilities.Debug;
		import utilities.DebugRemote;
		import utilities.ProjectProxy;
		
		public function CommandGame() 
		{
			
		}
		
		public static function connect(...p):void
		{
			if(p.length == 0) return;
			var socket:Socket = Connection.instance.getSocket();
			if(p[0] == "local"){
				try {
					if(socket && socket.connected){
						socket.close();
					}
					Connection.instance.connect("127.0.0.1", 8080);
				}catch (err:Error) {
					Debug.Trace('socket connected = false', err.message, err.name, err.errorID);
				}
				return;
			}
			var split:Array = String(p[0]).split(":");
			if(split.length < 2){
				if(split.length == 2){
					try {
						if(socket && socket.connected){
							socket.close();
						}
						Connection.instance.connect(split[0], parseInt(split[1]));
					}catch (e:Error) {
						Debug.Trace('socket connected = false', e.message, e.name, e.errorID);
					}
				}else{
					if(p.length == 1) return;
					try {
						if(socket && socket.connected){
							socket.close();
						}
						Connection.instance.connect(p[0], p[1]);
					}catch (er:Error) {
						Debug.Trace('socket connected = false', er.message, er.name, er.errorID);
					}
				}
			}
		}
		
		public static function path(value:String = ''):void {
			if (validateBoolean(value) == null) return;
			Debug.showPathFile = validateBoolean(value);
		}
		
		public static function remote(value:String = ''):void {
			if (value == 'test')  DebugRemote.Send('TEST REMOTE TRACE');
			if (validateBoolean(value) == null) return;
			Config.REMOTE = validateBoolean(value);
		}
		
		public static function debug(value:String = ''):void {
			if (validateBoolean(value) == null) return;
			Config.DEBUG = validateBoolean(value);
		}
		
		private static function validateBoolean(value:String):Object {
			switch(value) {
				case 'true': return true;
				case 'on': return true;
				case 'enabled': return true;
				case 'yes': return true;
				case 'false': return false;
				case 'off': return false;
				case 'disabled': return false;
				case 'no': return false;
			}
			return null;
		}
		public static function TraceDebug(...params):void {
			Console.WriteLine(params.join(" "));
			Debug.Trace(params.join(' '));
		}
		
		static public function console(value:String):void {
			if (validateBoolean(value) == null) return;
			Config.CONSOLE = validateBoolean(value);
		}
		
		static public function proxy(...params):void 
		{
			var value:String = params.join("");
			if (value == null || value == "") return;
			var i:int = value.indexOf('->');
			if (i == -1) return;
			var j:int = value.indexOf('(');
			if (j == -1) return;
			var k:int = value.indexOf(')');
			if (k == -1 || k <= j) return;
			var arr:Array = value.substring(j + 1, k).split(',');
			for (var s:String in arr) {
				arr[s] = StringUtil.trim(String(arr[s]));
			}
			ProjectProxy.instance.call(value.substring(0, i), value.substring(i+2, j), arr);
		}
		
		static public function quality(value:String):void 
		{
			value = StringUtil.trim(value).toLowerCase();
			switch(value) {
				case StageQuality.LOW:
					GlobalManager.quality = value;
					break;
				case StageQuality.MEDIUM:
					GlobalManager.quality = value;
					break;
				case StageQuality.HIGH:
					GlobalManager.quality = value;
					break;
				case StageQuality.BEST:
					GlobalManager.quality = value;
					break;
			}
		}
		
		
		public static function local(value:String):void 
		{
			Config.LOCAL = validateBoolean(StringUtil.trim(value));
		}
		
		public static function preloaderList():void 
		{
			Console.WriteLine(Preloader.game_internal::waitList);
			Debug.Trace(Preloader.game_internal::waitList);
		}
		
		
		public static function log(...params):void 
		{
			NetLogManager.open();
		}
		
		public static function preloader(...params):void 
		{
			if (params[0] == "hide" && params.length == 1) {
				Preloader.hide("all");
			}
			if (params[0] == "hide" && params.length >= 2) {
				Preloader.hide(params[1]);
			}
			if (params[0] == "show" && params.length >= 2) {
				Preloader.show(params[1]);
			}
		}
		
		
	}

}