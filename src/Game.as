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
		public static const PIRATES1:int = 3;
		public static const PIRATES2:int = 4;
		public static const MILITARY:int = 5;
		
		public static function game(id:int):String
		{
			switch (id)
			{
				case WAR: 
					return "Война Миров";
				case ZOMBIE: 
					return "Битва Зомби";
				case PIRATES1: 
					return "Пираты"; 
				case PIRATES2: 
					return "Pirate War: Age of Strike";
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
				case Game.PIRATES1: 
					return GameIconManager.pi;
				case Game.PIRATES2: 
					return GameIconManager.pi2;
				case Game.MILITARY: 
					return GameIconManager.mi;
			}
			return GameIconManager.clear;
		}
	}

}