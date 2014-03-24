package net.protocol 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolManager 
	{
		private static var protocolsName:Object = { };
		private static var protocolsId:Object = { };
		private static var protocolsHandle:Object = { };
		public function ProtocolManager() 
		{
			
		}
		
		public static function Run(id:int, object:Object):void {
			(protocolsHandle[id] as Function).apply(null, [object]);
		}
		
		public static function add(p:Protocol, handle:Function):void {
			protocolsName[p.name] = p;
			protocolsId[p.id] = p;
			protocolsHandle[p.id] = handle;
		}
		
		public static function getProtocolByName(name:String):Protocol {
			return protocolsName[name] as Protocol;
		}
		
		public static function getProtocolById(id:int):Protocol {
			return protocolsId[id];
		}
		
	}

}