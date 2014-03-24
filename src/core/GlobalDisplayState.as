package core 
{
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	import flash.system.System;
	/**
	 * ...
	 * @author dorofiy
	 */
	internal class GlobalDisplayState 
	{
		private static var flashVersionNumber:Number = NaN;
		private static function get flashVersion():Number {
			if (isNaN(flashVersionNumber) == false) {
				return flashVersionNumber;
			}
			var flashVersion:Array = Capabilities.version.split(',');
			var flashIndex:int = flashVersion[0].indexOf(" ");
			flashVersion[0] = flashVersion[0].substring(flashIndex + 1, flashVersion[0].length);
			flashVersionNumber = int(flashVersion[0]) + Number(int(flashVersion[1]) / 10);
			return flashVersionNumber;
		}
		
		
		public function FULLSCREEN():void {
			GlobalManager.displayState = StageDisplayState.FULL_SCREEN;
		}
		public function NORMAL():void {
			GlobalManager.displayState = StageDisplayState.NORMAL;
		}
		public function FULLSCREENINTERACTIVE():void {
			if (flashVersion >= 11.3) {
				if (StageDisplayState['FULL_SCREEN_INTERACTIVE'] == undefined) {
					FULLSCREEN();
					return;
				}
				GlobalManager.displayState = StageDisplayState['FULL_SCREEN_INTERACTIVE'];
			}else {
				FULLSCREEN();
			}
		}
		public function get fullScreenInteractiveAvailable():Boolean {
			return flashVersion >= 11;
		}
		public function get isNormalStateNow():Boolean { return GlobalManager.displayState == StageDisplayState.NORMAL; }
		public function get isFullScreenStateNow():Boolean { return GlobalManager.displayState == StageDisplayState.FULL_SCREEN; }
		public function get isFullScreenInteractiveStateNow():Boolean { return GlobalManager.displayState == StageDisplayState['FULL_SCREEN_INTERACTIVE'] }
		public function get isFullScreenBothStateNow():Boolean { return GlobalManager.displayState == StageDisplayState.FULL_SCREEN || GlobalManager.displayState == StageDisplayState['FULL_SCREEN_INTERACTIVE'] }
	}

}