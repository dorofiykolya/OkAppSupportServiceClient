package messages
{
	import flash.utils.Dictionary;

	public class AccessInfo
	{
		public var gameId:int;
		
		public var socialId:Dictionary = new Dictionary();
		public var hide:Dictionary = new Dictionary();
		
		public var language:Dictionary = new Dictionary();
		
		public function AccessInfo()
		{
			
		}
	}
}