package
{
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Game
	{
		public static const WAR:int = 1;
		public static const ZOMBIE:int = 2;
		public static const PIRATES:int = 3;
		public static const MILITARY:int = 3;
		
		public static function game(id:int):String
		{
			switch (id)
			{
				case WAR: 
					return "Война Миров";
				case ZOMBIE: 
					return "Битва Зомби";
				case PIRATES: 
					return "Пираты";
				case MILITARY: 
					return "Милитари";
			}
			return "";
		}
		
		public static function getIcon(id:int):Class
		{
			switch (id)
			{
				case Game.WAR: 
					return GameIconManager.ww;
				case Game.ZOMBIE: 
					return GameIconManager.bz;
				case Game.PIRATES: 
					return GameIconManager.pi;
				case Game.PIRATES: 
					return GameIconManager.mi;
			}
			return GameIconManager.clear;
		}
	}

}