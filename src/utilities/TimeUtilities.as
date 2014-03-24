package utilities 
{
	import ui.special.UITimeFormat;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class TimeUtilities 
	{
		private static const DAY:TimeUtilitiesFormat = new TimeUtilitiesFormat(' дней ');
		private static const HOUR:TimeUtilitiesFormat = new TimeUtilitiesFormat(':');
		private static const MIN:TimeUtilitiesFormat = new TimeUtilitiesFormat(':');
		private static const SEC:TimeUtilitiesFormat = new TimeUtilitiesFormat('');
		
		
		public static function convert(time:Number, trim:Boolean = false, seconds:Boolean = true, showWhenNull:Boolean = false):String {
			if(isNaN(time)) return '';
			if (time < 0) time = 0;
			var d:Date = new Date(0, 0, 0, 0, 0, 0, 0);
			if (seconds) d.seconds = time;
			else d.milliseconds = time;
			
			var day:int = time / 60 / 60 / 24;
			var hours:int = d.hours;
			var min:int = d.minutes;
			var sec:int = d.seconds;
			
			if (showWhenNull == false) {
				if (day + hours + min + sec == 0) return "";
			}
			
			return format(day, DAY, trim) + format(hours, HOUR, trim) + format(min, MIN, trim) + format(sec, SEC, trim);
		}
		private static function format(value:int, timeFormat:TimeUtilitiesFormat, trim:Boolean):String {
			var i:String = value.toString();
			if(value == 0 && timeFormat == DAY || trim && value == 0 && timeFormat != SEC) return '';
			if(i.length < 2){
				return timeFormat == DAY? value + getDay(value) : "0" + value.toString() + timeFormat.value;
			}
			return value.toString()+timeFormat.value;
		}
		private static function getDay(value:uint):String {
			var s:String = value.toString();
			var v:uint = parseInt(s.charAt(s.length-1));
			if(v == 1){
				return " день ";
			}else if(v > 1 && v < 5){
				return " дня ";
			}else{
				return " дней ";
			}
		}
		
	}

}