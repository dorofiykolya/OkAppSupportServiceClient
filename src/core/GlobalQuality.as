package core 
{
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	/**
	 * ...
	 * @author dorofiy
	 */
	internal class GlobalQuality 
	{
		public function HIGH():void {
			GlobalManager.quality = StageQuality.HIGH;
		}
		public function LOW():void {
			GlobalManager.quality = StageQuality.LOW;
		}
		public function MIDDLE():void {
			GlobalManager.quality = StageQuality.MEDIUM;
		}
		public function BEST():void {
			GlobalManager.quality = StageQuality.BEST;
		}
	}

}