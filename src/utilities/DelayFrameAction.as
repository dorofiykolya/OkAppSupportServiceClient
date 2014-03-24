package utilities
{
	import flash.events.Event;

	public class DelayFrameAction
	{
		private var delayHandle:Function;
		private var parameters:Array;
		private var delay:int;
		public function DelayFrameAction(handle:Function, delayFrame:uint = 1, ...params)
		{
			delay = delayFrame;
			delayHandle = handle;
			parameters = params;
			War.instance.addEventListener(Event.ENTER_FRAME, onDelayActionEnterFrame);
		}
		
		private function onDelayActionEnterFrame(e:Event):void 
		{
			if (--delay > 0) {
				return;
			}
			War.instance.removeEventListener(Event.ENTER_FRAME, onDelayActionEnterFrame);
			delayHandle.apply(null, parameters);
			delayHandle = null;
			parameters = null;
		}
	}
}