package access
{
	import messages.Access;

	public class AccessSocial
	{
		public var language:Vector.<AccessLanguage> = new Vector.<AccessLanguage>();
		public var socialId:int;
		public var hide:Boolean;
		public var count:int;
		
		public function AccessSocial(file:Access)
		{
			socialId = file.socialId;
			setAccess(file);
		}
		
		public function get label():String
		{
			return Social.getNameById(socialId);
		}
		
		public function setAccess(selected:Access):void
		{
			var i:int;
			var current:AccessLanguage;
			var find:Boolean;
			for(i = 0; i < language.length; i++)
			{
				current = language[i];
				if(current.language == selected.language)
				{
					current.setAccess(selected);
					find = true;
					break;
				}
			}
			if(find == false)
			{
				language[language.length] = new AccessLanguage(selected);
			}
			count += selected.count;
		}
	}
}