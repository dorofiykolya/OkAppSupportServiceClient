package
{
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Social
	{
		public static const VKONTAKTE:int = 1;
		public static const MAILRU:int = 2;
		public static const FACEBOOK:int = 3;
		public static const ODNOKLASSNIKI:int = 4;
		public static const ANDROID:int = 5;
		public static const QZone:int = 6;
		public static const APPSTORE:int = 7;
		
		public static function getNameById(id:int):String
		{
			switch (id)
			{
				case VKONTAKTE: 
					return "вконтакте";
				case MAILRU: 
					return "mailru";
				case FACEBOOK: 
					return "facebook";
				case ODNOKLASSNIKI: 
					return "одноклассники";
				case ANDROID:
					return "Android";
				case QZone:
					return "QZone";
				case APPSTORE:
					return "AppStore";
			}
			return "...";
		}
	
		public static function getIcon(id:int):Class
		{
			switch (id)
			{
				case VKONTAKTE: 
					return SocialIconManager.vkontakte;
				case MAILRU: 
					return SocialIconManager.mailru;
				case FACEBOOK: 
					return SocialIconManager.facebook;
				case ODNOKLASSNIKI: 
					return SocialIconManager.odnoklassniki;
				case ANDROID:
					return SocialIconManager.android;
				case QZone:
					return SocialIconManager.qzone;
				case APPSTORE:
					return SocialIconManager.appstore;
			}
			return SocialIconManager.clear;
		}
	}

}