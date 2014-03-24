package core 
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	import core.game_internal;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	use namespace game_internal;
	internal class GlobalKeyboard 
	{
		private static var _stage:Stage;
		private static var isCtrl:Boolean;
		private static var isShift:Boolean;
		private static var isAlt:Boolean;
		game_internal function initialize(stage:Stage):void {
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			isCtrl = e.ctrlKey;
			isShift = e.shiftKey;
			isAlt = e.altKey;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			isCtrl = e.ctrlKey;
			isShift = e.shiftKey;
			isAlt = e.altKey;
		}
		
		public function get ctrlKey():Boolean {
			return isCtrl;
		}
		public function get shiftKey():Boolean {
			return isShift;
		}
		public function get altKey():Boolean {
			return isAlt;
		}
		
		public static function get ctrlKey():Boolean {
			return isCtrl;
		}
		public static function get shiftKey():Boolean {
			return isShift;
		}
		public static function get altKey():Boolean {
			return isAlt;
		}
		
	}

}