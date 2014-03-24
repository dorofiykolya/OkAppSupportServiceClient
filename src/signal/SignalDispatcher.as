package signal 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class SignalDispatcher 
	{
		private var data:Dictionary = new Dictionary();
		
		public function addListener(type:String, listener:Function):void {
			if (data[type] == undefined) {
				data[type] = new Vector.<Function>();
			}
			var i:int = data[type].indexOf(listener);
			if (i == -1) {
				data[type].push(listener);
			}
		}
		
		public function removeListener(type:String, listener:Function):void {
			if (data[type] == undefined) return;
			var v:Vector.<Function> = data[type];
			var i:int = v.indexOf(listener);
			if (i != -1) {
				v.splice(i, 1);
				if (v.length == 0) {
					delete data[type];
				}
			}
		}
		
		public function invoke(type:String, ...params):void {
			if (data[type] == undefined) return;
			var v:Vector.<Function> = data[type];
			for each(var f:Function in v) {
				f.apply(null, params);
			}
		}
		
		public function hasListener(type:String):Boolean {
			if (data[type] == undefined) return false;
			return true;
		}
		
	}

}