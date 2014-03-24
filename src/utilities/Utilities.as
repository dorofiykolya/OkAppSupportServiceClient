package utilities 
{
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Utilities 
	{
		private static var flashVersionNumber:Number = NaN;
		public static function getFlashVersionNumber():Number {
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