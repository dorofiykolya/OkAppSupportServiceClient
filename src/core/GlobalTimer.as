package core 
{
	import flash.utils.Timer;
	import core.game_internal;
	/**
	 * ...
	 * @author dorofiy
	 */
	use namespace game_internal;
	public class GlobalTimer 
	{
		private var _secondTimer:Timer = new Timer(1000);
		private var _frameTimer:Timer = new Timer(40);
		
		public function get secondTimer():Timer { return _secondTimer; }
		public function get frameTimer():Timer { return _frameTimer; }
		
		game_internal function start():void {
			_secondTimer.start();
			_frameTimer.start();
		}
	}

}