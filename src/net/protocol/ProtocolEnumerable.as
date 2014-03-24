package net.protocol 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolEnumerable 
	{
		
		public function ProtocolEnumerable() 
		{
			var p:Protocol = new Protocol('location', 0, null);
			p.add(ProtocolType.UINT, 'x');
			p.add(ProtocolType.UINT, 'y');
			p.add(ProtocolType.UTF, 'text');
			ProtocolManager.add(p, doSome);
		}
		
		private function doSome(o:Object):void {
			trace(o.x, o.y, o.text);
		}
		
		private static var inst:ProtocolEnumerable;
		public static function get instance():ProtocolEnumerable{
			if(inst == null) inst = new ProtocolEnumerable();
			return inst as ProtocolEnumerable;
		}
		
	}

}