package utilities 
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class DelayTimeAction 
	{
		private var time:int;
		private var func:Function;
		private var arr:Array;
		public var completed:Boolean;
		public function DelayTimeAction(handle:Function, delay:int = 1000, ...params:Array) 
		{
			func = handle;
			arr = params;
			time = setTimeout(onTime, delay);
		}
		private function onTime():void {
			clearTimeout(time);
			if (arr) {
				if(func != null) func.apply(null, arr);
			}else {
				if(func != null) func();
			}
			func = null;
			arr = null;
			completed = true;
		}
		
	}

}