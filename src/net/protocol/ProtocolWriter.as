package net.protocol 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolWriter 
	{
		public static function write(protocol:Protocol):ByteArray {
			protocol = protocol.copy();
			var byte:ByteArray = new ByteArray();
			var lenght:int = protocol.lenght;
			protocol.reset();
			byte.writeByte(protocol.id);
			for (var i:int = 0; i < lenght; i++) 
			{
				var current:int = protocol.getNext();
			}
		}
		
	}

}