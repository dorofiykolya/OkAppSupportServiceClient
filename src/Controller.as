package  
{
	import flash.utils.Dictionary;
	import signal.SignalDispatcher;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Controller 
	{
		private static var _signal:SignalDispatcher = new SignalDispatcher();
		private static var _dict:Dictionary = new Dictionary();
		
		public static function AddHandler(type:String, handler:Function):void {
			_signal.addListener(type, handler);
		}
		
		public static function RemoveHandler(type:String, handler:Function):void {
			_signal.removeListener(type, handler);
		}
		
		public static function SetValue(id:String, objec:Object):void{
			_dict[id] = objec;
		}
		
		public static function GetValue(id:String):Object{
			return _dict[id];
		}
		
		public static function Invoke(type:String, ...params):void {
			params.unshift(type);
			_signal.invoke.apply(null, params);
		}
	}

}