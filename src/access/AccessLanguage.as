package access
{
	import messages.Access;

	public class AccessLanguage
	{
		public var language:String;
		
		public var hide:Boolean;
		
		public function AccessLanguage(file:Access)
		{
			language = file.language;
			set(file);
		}
		
		public function get label():String
		{
			return language;
		}
		
		public function set(selected:Access):void
		{
			language = selected.language;
			hide = selected.hide;
		}
	}
}