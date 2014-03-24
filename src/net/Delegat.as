package net 
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Delegat 
	{
		private var v:Vector.<Function>;
		public function Delegat() 
		{
			v = new Vector.<Function>();
		}
		public function add(listener:Function):void {
			v.push(listener);
		}
		public function remove(listener:Function):void {
			var i:int = v.indexOf(listener);
			if (i != -1) {
				v.splice(i, 1);
			}
		}
		public function clear():void {
			if (v.length == 0) return;
			v.splice(0, v.length);
		}
		public function run(...params):void {
			for each(var l:Function in v) {
				if (params.length == 0) {
					l.apply();
				}else {
					l.apply(null, params);
				}
			}
		}
		public function get listeners():Vector.<Function> {
			return v;
		}
		
	}

}