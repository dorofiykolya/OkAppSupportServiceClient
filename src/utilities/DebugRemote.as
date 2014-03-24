package utilities 
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class DebugRemote 
	{
		private static var localConnection:LocalConnection = new LocalConnection();
		private static var air:Boolean = true;
		private static var appID:String = 'DebugViewer';
		private static var connectionName:String = 'DebugViewer';
		private static var method:String = 'remoteHandle';
		private static var isInit:Boolean;
		public static const FORCIBLY:String = "forcibly";
		public function DebugRemote() 
		{
			
		}
		
		public static function Setting(air:Boolean = true, appID:String = 'DebugViewer', connectionName:String = 'DebugViewer', method:String = 'remoteHandle'):void {
			DebugRemote.air = air;
			DebugRemote.appID = appID;
			DebugRemote.connectionName = connectionName;
			init();
		}
		
		public static function Send(...params):void {
			if (isInit == false) init();
			try {
				if (air) {
					params.unshift('app#' + appID + ":" + connectionName, method);
					localConnection.send.apply(null, params);
					return;
				}
				params.unshift(connectionName, method);
				localConnection.send.apply(null, params);
			}catch (e:Error) {
				trace(Debug.Stack(e.message, e.getStackTrace()));
			}
		}
		
		private static function init():void {
			if (isInit) return;
			localConnection.addEventListener(StatusEvent.STATUS, function(e:StatusEvent):void {
				if (e.level == 'error') trace(Debug.Stack('LocalConnection.send() failed'));
			});
			isInit = true;
		}
		
	}

}