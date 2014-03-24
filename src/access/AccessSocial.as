package access
{
	import messages.Access;

	public class AccessSocial
	{
		public var language:Vector.<AccessLanguage> = new Vector.<AccessLanguage>();
		public var socialId:int;
		public var hide:Boolean;
		
		public function AccessSocial(file:Access)
		{
			socialId = file.socialId;
			set(file);
		}
		
		public function get label():String
		{
			return Social.getNameById(socialId);
		}
		
		public function set(selected:Access):void
		{
			var i:int;
			var current:AccessLanguage;
			var find:Boolean;
			for(i = 0; i < language.length; i++)
			{
				current = language[i];
				if(current.language == selected.language)
				{
					current.set(selected);
					find = true;
					break;
				}
			}
			if(find == false)
			{
				language.push(new AccessLanguage(selected));
			}
		}
	}
}