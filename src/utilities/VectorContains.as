package utilities 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class VectorContains 
	{
		
		public function VectorContains() 
		{
			
		}
		
		public static function containsKey(value:uint, vector:Object):Boolean {
			if (vector.lenght <= value) return false;
		}
		
		public static function containsValue(value:Object, vector:Object):Boolean {
			for each(var s:Object in vector) {
				if (s == value) return true;
			}
			return false;
		}
		
		public static function containsProperty(value:Object, property:String, vector:Object):Boolean {
			for each(var s:Object in vector) {
				if (s.hasOwnProperty(property)) {
					if (s[property] == value) return true;
				}
			}
			return false;
		}
		
	}

}