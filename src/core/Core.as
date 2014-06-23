package core 
{
	import System.Console;
	import System.events.ConsoleEvent;
	
	import com.adobe.serialization.json.JSON;
	import com.hurlant.util.Base64;
	
	import command.Command;
	
	import core.MouseWheelTrap;
	
	import debug.FPS;
	import debug.Stats;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import net.Connection;
	import net.Listener;
	import net.log.NetLogManager;
	
	import utilities.Debug;
	import utilities.KeyboardKeyCode;
	import utilities.KeyboardShortcut;
	import utilities.TraceUtility;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Core 
	{	
		private static var connect:Connection;
		private static var listener:Listener;
		private static var keyShortcut:KeyboardShortcut; 
		
		public static function initialize():void
		{
			//FPS.show();
			
			MouseWheelTrap.setup(GlobalManager.stage);
			
			connect = Connection.getInstance();
			connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
			connect.addEventListener(Event.CONNECT, onSocketConnect);
			connect.addEventListener(Event.CLOSE, onSocketClose);
			
			listener = Listener.instance;
			
			Console.addEventListener(ConsoleEvent.READ, onConsoleRead);
			
			NetLogManager.Initilize(GlobalManager.stage, FlexGlobals.topLevelApplication.debugLayer);
			NetLogManager.useHotKay = false;
			
			keyShortcut = KeyboardShortcut.createInstance(GlobalManager.stage);
			
			GlobalManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			
			//connect.connect('188.93.22.134', 8080);
			connect.connect('support.restr.net', 8090);
//			connect.connect('192.168.1.108', 8090);
//			connect.connect('127.0.0.1', 8090);
//			connect.connect("192.168.10.51", 8080);
		}
		
		protected static function onSocketSecurityError(event:Event):void
		{
			Alert.show("Security Error");
		}
		
		private static function onSocketClose(e:Event):void 
		{
			Alert.show("Соединение разорвано,\nХотите переподключиться?", "", 3, null, onAlertClose);
		}
		
		private static function onAlertClose(e:CloseEvent):void {
			if (e.detail == Alert.YES) {
				if (connect) {
					connect.reconnect();
				}
			}else {
				Preloader.show("связь с сервером прервана, перезагрузите страницу");
			}
		}
		
		protected static function onSocketConnect(event:Event):void
		{
			Login.show();
			Preloader.hide(Preloader.CONNECTION);
		}
		
		private static function onKeyboardDown(e:KeyboardEvent):void {
			if (e.ctrlKey && e.shiftKey && e.keyCode == 82) {
				Connection.instance.reconnect();
			}
			if(e.ctrlKey && e.keyCode == KeyboardKeyCode.L){
				NetLogManager.open();
			}
			if (e.keyCode == KeyboardKeyCode.LYAMBDA && e.ctrlKey) {
				if (Console.isVisible) {
					Console.hide();
				}else {
					Console.show(GlobalManager.stage);
				}
			}
		}
		
		private static function onConsoleRead(e:ConsoleEvent):void 
		{
			if (Command.containsParse(e.text)) {
				Console.WriteLine(Command.applyParse(e.text));
			}
		}
		
	}

}