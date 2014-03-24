package command
{
	import System.Console;
	
	import com.adobe.utils.StringUtil;
	
	import net.Connection;
	
	public class Command
	{
		private static var inst:Command;
		
		public static function get instance():Command
		{
			if (inst == null) {
				inst = new Command();
			}
			return inst as Command;
		}
		
		private var callBack:Object = {};
		private var callDescription:Object = { };
		private var callHelp:Object = { };
		
		private function register(name:String, func:Function, description:String = '', help:String = ""):void
		{
			callBack[name] = func;
			callDescription[name] = description;
			callHelp[name] = help;
		}
		
		public function Command()
		{
			register('@reconnect', Connection.instance.reconnect, 'RECONNECT TO SERVER<br/>PLEASE WAIT!', "переподключение к серверу");
			register('@tracepath', CommandGame.path, 'TRACE PATH CHANGED', "(true/false)вставлять путь файла при трейсе");
			register('@remote', CommandGame.remote, 'REMOTE CHANGED', "(true/false/test)удаленный вывод");
			register('@debug', CommandGame.debug, 'DEBUG CHANGED', "(true/false)отладка");
			register('@trace', CommandGame.TraceDebug, "", "(true/false)вывести в отладку");
			register('@console', CommandGame.console, 'CONSOLE CHANGED', "(true/false)вывод в консоль");
			register('@proxy', CommandGame.proxy, "", "минимальный прокси по проэкту");
			register('#', CommandGame.proxy, "", "минимальный прокси по проэкту");
			register('@quality', CommandGame.quality, 'QUALITY CHANGED', "(best/high/middle/low)качество");
			register('@local', CommandGame.local, "", "(true/false)локально тестируется");
			register('@preloader_list', CommandGame.preloaderList, "", "вывести ожидающий список в предзагружчике");
			register('@log', CommandGame.log, "", "показать логи с сервером");
			register('@preloader', CommandGame.preloader, "", "(show/hide)(label) установка ожидающого списка (если hide all -> скрыть все)");
			register("@connect", CommandGame.connect, "TRY CONNECT", "(127.0.0.1:8080 или через пробел 127.0.0.1 8080)подключиться к определенному домену-порту");
			//-------------------------------------------
			register('@help', help);
			register('?', help);
			register('help', help);
		}
		
		
		
		private function help():void
		{
			Console.WriteLine("-------COMMANDS-------");
			for (var s:String in callBack)
			{
				Console.WriteLine("HELP", s + " ::: " + callHelp[s]);
			}
			Console.WriteLine("-------COMMANDS-------");
		}
		
		public static function contains(cmd:String):Boolean
		{
			if (instance.callBack[cmd] != undefined)
			{
				return true;
			}
			return false;
		}
		
		public static function containsParse(cmd:String):Boolean
		{
			cmd = StringUtil.trim(cmd);
			var arr:Array = cmd.split(" ");
			if (arr.length > 0 && contains(arr[0]))
				return true;
			return false;
		}
		
		public static function apply(cmd:String, params:Array = null):String
		{
			if (cmd == null)
				return '#null command';
			if (contains(cmd))
			{
				(instance.callBack[cmd] as Function).apply(null, params);
				return instance.callDescription[cmd];
			}
			return '#null command';
		}
		
		public static function applyParse(cmd:String):String
		{
			if (cmd == null) {
				return '#null command';
			}
			cmd = StringUtil.trim(cmd);
			var arr:Array = cmd.split(" ");
			if (arr.length > 1 && contains(arr[0]))
			{
				var params:Array = [];
				params = params.concat(arr);
				params.splice(0, 1);
				apply(arr[0], params);
				return instance.callDescription[arr[0]];
			}
			if (arr.length == 1)
			{
				return apply(cmd);
			}
			return '#null command';
		}
	}
}