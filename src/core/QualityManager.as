package core 
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class QualityManager 
	{
		public static const LOW:String = 'low';
		public static const MEDIUM:String = 'medium';
		public static const HIGH:String = 'high';
		public static const BEST:String = 'best';
		
		private static var _currentQuality:String = 'high';
		private static var _stage:Stage;
		
		public static function setHightQuality():void {
			if (_stage == null) return;
			if (_currentQuality == HIGH) return;
			_currentQuality = HIGH;
			_stage.quality = StageQuality.HIGH;
		}
		
		public static function setBestQuality():void {
			if (_stage == null) return;
			if (_currentQuality == BEST) return;
			_currentQuality = BEST;
			_stage.quality = StageQuality.BEST;
		}
		
		public static function setMediumQuality():void {
			if (_stage == null) return;
			if (_currentQuality == MEDIUM) return;
			_currentQuality = MEDIUM;
			_stage.quality = StageQuality.MEDIUM;
		}
		
		public static function setLowQuality():void {
			if (_stage == null) return;
			if (_currentQuality == LOW) return;
			_currentQuality = LOW;
			_stage.quality = StageQuality.LOW;
		}
		
		static public function get quality():String 
		{
			return _currentQuality;
		}
		
		static public function set quality(value:String):void 
		{
			switch(value) {
				case BEST:
					setBestQuality();
					break;
				case HIGH:
					setHightQuality();
					break;
				case MEDIUM:
					setMediumQuality();
					break;
				case LOW:
					setLowQuality();
					break;
			}
			_currentQuality = value;
		}
		
		static public function get stage():Stage 
		{
			return _stage;
		}
		
		static public function set stage(value:Stage):void 
		{
			_stage = value;
		}
		
	}

}