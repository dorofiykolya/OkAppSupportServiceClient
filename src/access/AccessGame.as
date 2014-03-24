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
		
		public function AccessGame(file:Access)
		{
			gameId = file.gameId;
			set(file);
		}
		
		public function get collection():Object
		{
			var x:XMLListCollection = new XMLListCollection();
			return x;
//			var a:Array = [];
//			for each (var s:Object in socialId) 
//			{
//				a.push(s);
//			}
			//return new ArrayCollection(a);
		}
		
		public function get label():String
		{
			return Game.game(gameId);
		}
		
		public function set(selected:Access):void
		{
			var i:int;
			var current:AccessSocial;
			var find:Boolean;
			for(i = 0; i < socialId.length; i++)
			{
				current = socialId[i];
				if(current.socialId == selected.socialId)
				{
					current.set(selected);
					find = true;
					break;
				}
			}
			if(find == false)
			{
				socialId.push(new AccessSocial(selected));
			}
		}
	}
}