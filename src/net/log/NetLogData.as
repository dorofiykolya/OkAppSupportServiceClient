package net.log
{
	public class NetLogData
	{
		private static var _list:Array = [];
		
		public static const TYPE_GET:String = 'GET';
		public static const TYPE_SEND:String = 'SEND';
		
		public static function writeSend(o:Object):void {
			if (o == null) return;
			var d:Date = new Date();
			for (var nm:String in o) {
				var n:NetLog = new NetLog();
				n.name = nm;
				var ms:String = d.milliseconds > 99? d.milliseconds.toString() : '0' + d.milliseconds;
				n.time = d.hours + ":" + d.minutes + ":" + d.seconds + "::" + ms;
				n.object = o[nm];
				n.type = TYPE_SEND;
				_list.push(n);
			}
		}
		public static function writeGet(o:Object):void {
			if (o == null) return;
			var d:Date = new Date();
			for (var nm:String in o) {
				var n:NetLog = new NetLog();
				n.name = nm;
				var ms:String = d.milliseconds > 99? d.milliseconds.toString() : '0' + d.milliseconds;
				n.time = d.hours + ":" + d.minutes + ":" + d.seconds + "::" + ms;
				n.object = o[nm];
				n.type = TYPE_GET;
				_list.push(n);
			}
		}
		
		public static function get list():Array {
			return _list;
		}
	}
}