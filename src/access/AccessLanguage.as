package access
{
	import messages.Access;

	public class AccessLanguage
	{
		public var language:String;
		public var hide:Boolean;
		public var count:int;
		
		public function AccessLanguage(file:Access)
		{
			language = file.language;
			setAccess(file);
		}
		
		public function get label():String
		{
			return language;
		}
		
		public function setAccess(selected:Access):void
		{
			language = selected.language;
			hide = selected.hide;
			count += selected.count;
		}
	}
}