package net 
{
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;

	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ErrorListener 
	{
		private static var inst:ErrorListener;
		private var callBacks:Object = { };
		public function ErrorListener() 
		{
			registerCallBack("userAuth", onUserAuth);
			
			registerCallBack("deleteMessage", onDeleteMessage);
		}
		
		private function onDeleteMessage(data:String):void 
		{
			Alert.show(data);
		}
		
		private function onUserAuth(data:String):void
		{
			Preloader.show(Preloader.AUTHORIZATION_FAULT);
			Preloader.hide(Preloader.AUTHORIZATION);
			Alert.show(data, "", 4, null, Login.instance.showAuthorization);
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
		
		public static function get instance():ErrorListener{
			if(inst == null) inst = new ErrorListener();
			return inst as ErrorListener;
		}
		public static function getInstance():ErrorListener{
			if(inst == null) inst = new ErrorListener();
			return inst as ErrorListener;
		}
	}

}