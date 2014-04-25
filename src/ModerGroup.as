package
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ModerGroup extends EventDispatcher
	{
		
		public static var moderGroup:ModerGroup = new ModerGroup();
		
		private var current:ModerPlaceholder;
		private var dict:Dictionary = new Dictionary();
		private var count:int;
		
		public function Add(m:ModerPlaceholder):void{
			if (dict[m.moder.id] == undefined) {
				count++;
			}
			dict[m.moder.id] = m;
		}
		public function Remove(m:ModerPlaceholder):void {
			if (m.selected) {
				m.unselect();
			}
			if (dict[m.moder.id] != undefined) {
				count--;
			}
			delete dict[m.moder.id];
		}
		public function get selected():ModerPlaceholder{
			return current;
		}
		public function Select(m:ModerPlaceholder):void{
			if(current == m) return;
			if(current){
				current.unselect();
			}
			current = m;
			m.select();
		}
		public function Unselect(t:ModerPlaceholder):void{
			if(current == t){
				current.unselect();
				current = null;
				return;
			}
			t.unselect();
		}
		public function get Count():int {
			return count;
		}
		public function Reset():void{
			dict = new Dictionary();
			current = null;
			count = 0;
		}
		public function UnselectCurrent():void {
			if (current == null) return;
			current.unselect();
			current = null;
		}
		public function UnselectAll():void{
			for(var i:Object in dict){
				var m:ModerPlaceholder = dict[i] as ModerPlaceholder;
				if(m){
					m.unselect();
				}
			}
			current = null;
		}
		public function GetByMessageId(id:uint):ModerPlaceholder {
			return dict[id];
		}
		
		public function SelectFirst():void
		{
			UnselectAll();
			var min:int = int.MAX_VALUE;
			var current:ModerPlaceholder;
			
			/*current = dict[
			for each (var m:ModerPlaceholder in dict) 
			{
				if(m.visible && m.moder.lastUpdate < min)
				{
					min = m.moder.lastUpdate;
					current = m;
				}
			}*/
			if(current)
			{
				Select(current);
			}
		}
	}
}