package net.protocol 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolTest 
	{
		
		public function ProtocolTest() 
		{
			var p:ProtocolConstructor = new ProtocolConstructor('location', 0, { x:100, y:100, text:"Str" } );
			ProtocolReader.read(p.byteArray);
		}
		
	}

}