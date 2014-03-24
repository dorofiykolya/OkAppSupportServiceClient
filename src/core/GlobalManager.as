package core
{
	import core.game_internal;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import flash.display.Stage;
	
	use namespace game_internal;
	public class GlobalManager
	{
		private static var _stage:Stage;
		private static var _root:DisplayObjectContainer;
		private static var _globalDisplayState:GlobalDisplayState = new GlobalDisplayState();
		private static var _globalQuality:GlobalQuality = new GlobalQuality();
		private static var _globalTimer:GlobalTimer = new GlobalTimer();
		private static var _globalKeyboard:GlobalKeyboard = new GlobalKeyboard();
		
		private static var _lastTime:uint = getTimer();
		private static var _frame:uint;
		private static var _fps:Number;
		
		game_internal static function initialize(stage:Stage, root:DisplayObjectContainer):void{
			_stage = stage;
			_root = root;
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_globalTimer.game_internal::start();
			_globalKeyboard.game_internal::initialize(stage);
		}
		
		private static function onEnterFrame(e:Event):void 
		{
			_frame++;
            var now:uint = getTimer();
            var delta:uint = now - _lastTime;
            if (delta >= 1000) {
                _fps = _frame / delta * 1000;
                _frame = 0;
                _lastTime = now;
            }
		}
		
		/* DELEGATE flash.display.Stage */
		
		public static function get focus():InteractiveObject { return _stage.focus; }
		public static function set focus(value:InteractiveObject):void { _stage.focus = value; }
		
		public static function get displayState():String { return _stage.displayState; }
		public static function set displayState(value:String):void {_stage.displayState = value;}
		public static function get quality():String { return _stage.quality; }
		public static function set quality(value:String):void {	_stage.quality = value; }
		public static function get stage():Stage { return _stage; };
		public static function get parameters():Object { return _stage.loaderInfo.parameters; }
		public static function get qualityManager():GlobalQuality { return _globalQuality; }
		public static function get displayStateManager():GlobalDisplayState { return _globalDisplayState; }
		public static function get fps():Number { return _fps }
		public static function get timerManager():GlobalTimer { return _globalTimer; }
		public static function get keyboardManager():GlobalKeyboard { return _globalKeyboard; }
		public static function get root():DisplayObjectContainer { return _root; }
		
		private static var flashVersionNumber:Number = NaN;
		public static function get flashVersion():Number {
			if (isNaN(flashVersionNumber) == false) {
				return flashVersionNumber;
			}
			var flashVersion:Array = Capabilities.version.split(',');
			var flashIndex:int = flashVersion[0].indexOf(" ");
			flashVersion[0] = flashVersion[0].substring(flashIndex + 1, flashVersion[0].length);
			flashVersionNumber = int(flashVersion[0]) + Number(int(flashVersion[1]) / 10);
			return flashVersionNumber;
		}
	}
}