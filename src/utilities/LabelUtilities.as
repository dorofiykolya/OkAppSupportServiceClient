package utilities 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class LabelUtilities 
	{
		
		public function LabelUtilities() 
		{
			
		}
		public static function getLabelByCount(value:uint, _1:String = 'день', _2_4:String = 'дня', other:String = 'дней'):String {
			var s:String = value.toString();
			var v:uint = parseInt(s.charAt(s.length-1));
			if(v == 1){
				return _1;
			}else if(v > 1 && v < 5){
				return _2_4;
			}else{
				return other;
			}
		}
		
	}

}