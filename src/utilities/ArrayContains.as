package utilities 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ArrayContains 
	{
		
		public function ArrayContains() 
		{
			
		}
		
		public static function containsKey(key:Object, array:Array):Boolean {
			if (array[key] == undefined) return false;
		}
		
		public static function containsValue(value:Object, array:Array):Boolean {
			for each(var s:Object in array) {
				if (s == value) return true;
			}
			return false;
		}
		
	}

}