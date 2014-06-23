package access
{
	import messages.Access;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;
	import mx.collections.XMLListCollection;

	public class AccessGame
	{
		public var gameId:int;
		public var socialId:Vector.<AccessSocial> = new Vector.<AccessSocial>();
		public var hide:Boolean;
		public var count:int;
		
		public function AccessGame(file:Access)
		{
			gameId = file.gameId;
			setAccess(file);
		}
		
		public function get label():String
		{
			return Game.game(gameId);
		}
		
		public function setAccess(selected:Access):void
		{
			var i:int;
			var current:AccessSocial;
			var find:Boolean;
			for(i = 0; i < socialId.length; i++)
			{
				current = socialId[i];
				if(current.socialId == selected.socialId)
				{
					current.setAccess(selected);
					find = true;
					break;
				}
			}
			if(find == false)
			{
				socialId[socialId.length] = new AccessSocial(selected);
			}
			count += selected.count;
		}
	}
}