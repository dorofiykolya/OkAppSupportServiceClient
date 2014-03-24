package utilities 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class StringUtilities 
	{
		
		public function StringUtilities() 
		{
			
		}
		public static function charIsNumber(char:String):Boolean {
			switch(char){
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9":
					return true;
			}
			return false;
		}
		public static function charIsLatin(char:String, exception:String = null, excluded:String = "[\\]^_`"):Boolean {
			if (char >= "A" && char <= "Z" || char >= "a" && char <= "z") return true;
			if (exception && exception.indexOf(char) != -1) return true;
			return false;
		}
		public static function charIsCyrillic(char:String, exception:String = null):Boolean {
			if (char <= "я" && char >= "А" || exception && exception.indexOf(char) != -1) return true;
			return false;
		}
		public static function charInText(char:String, text:String = "_"):Boolean {
			if (text.indexOf(char) != -1) return true;
			return false;
		}
		public static function removeHtmlBR(text:String):String {
			text = text.replace(/<BR>/gi, " ");
			text = text.replace(/<br\/>/gi, " ");
			return text;
		}
		public static function removeFromText(text:String, remove:String = ' ', global:Boolean = true, ignoreCase:Boolean = true):String {
			if (text == null || remove == null) return null;
			var option:String = '';
			if (global) option += 'g';
			if (ignoreCase) option += 'i';
			var reg:RegExp = new RegExp(remove, option);
			return text.replace(reg, '');
		}
		public static function replaceFromText(text:String, remove:String, paste:String, global:Boolean = true, ignoreCase:Boolean = true):String {
			if (text == null || remove == null || paste == null) return null;
			var option:String = '';
			if (global) option += 'g';
			if (ignoreCase) option += 'i';
			var reg:RegExp = new RegExp(remove, option);
			return text.replace(reg, paste);
		}
		
	}

}