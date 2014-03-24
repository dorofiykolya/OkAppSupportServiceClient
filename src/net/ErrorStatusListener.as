package net 
{
	import utilities.DelayFrameAction;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ErrorStatusListener 
	{
		private var callBacks:Object = { };
		public function ErrorStatusListener() 
		{
			
		}
		
		public function registerCallBack(name:String, value:Function):void {
			callBacks[name] = value;
		}
		public function unregisterCallBack(name:String):void {
			delete callBacks[name];
		}
		public static function get callBack():Object {
			return instance.callBacks;
		}
		private static var inst:ErrorStatusListener;
		public static function get instance():ErrorStatusListener{
			if(inst == null) inst = new ErrorStatusListener();
			return inst as ErrorStatusListener;
		}
		
	}

}