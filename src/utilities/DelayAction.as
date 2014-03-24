package utilities 
{
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class DelayAction 
	{
		private var _handle:Function;
		private var _params:Array;
		private var _timer:Timer;
		public var started:Boolean;
		public var completed:Boolean;
		public function DelayAction(handle:Function = null, ...params) 
		{
			_handle = handle;
			_params = params;
		}
		public function start(delay:uint = 1000, count:uint = 1):void {
			stop();
			if (_timer == null) _timer = new Timer(delay, count);
			_timer.delay = delay;
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			_timer.start();
			started = true;
		}
		
		public function resume():void {
			if (started == false) {
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				_timer.start();
			}
			started = true;
		}
		
		private function onComplete(e:TimerEvent):void 
		{
			if (_handle != null && _handle as Function != null) {
				_handle.apply(null, _params);
			}
			completed = true;
		}
		public function stop():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				_timer.stop();
			}
			started = false;
		}
		public function destroy():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				_timer.stop();
			}
			_handle = null;
			_params = null;
			completed = false;
			_timer = null;
			started = false;
		}
	}

}