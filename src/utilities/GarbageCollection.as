package utilities 
{
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class GarbageCollection 
	{
		private static var collect:Object;
		private static var dictionary:Dictionary;
		
		public static function InvokeDebug():Boolean {
			if (Capabilities.isDebugger) {
				try {
					System.gc();
				}catch (e:Error) {
					Debug.Trace(e.message, e.getStackTrace());
				}
				Debug.Trace("DEBUG GarbageCollection Success!");
				return true;
			}
			return false;
		}
		public static function TryInvoke():Boolean {
			if (InvokeDebug()) return true;
			try {
				test();
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			}catch (e:Error) {
				Debug.Trace(e.message);
			}finally {
				return Test();
			}
		}
		private static function Test():Boolean {
			var cleared:Boolean = true;
			for each (var key:* in dictionary) 
			{
				cleared = false;
			}
			if (cleared) {
				Debug.Trace("GarbageCollection success!");
			}else {
				Debug.Trace("GarbageCollection fail!");
			}
			return cleared;
		}
		private static function test():void {
			collect = { };
			dictionary = new Dictionary(true);
			dictionary[collect] = true;
			collect = null;
		}
	}

}