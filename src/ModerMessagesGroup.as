package  
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Mike Silanin
	 */
	public class ModerMessagesGroup extends EventDispatcher 
	{
		public static var tickets:ModerMessagesGroup = new ModerMessagesGroup();
		public static var messages:ModerMessagesGroup = new ModerMessagesGroup();
		
		private var current:ModerMessagePlaceholder;
		private var dict:Dictionary = new Dictionary();
		private var count:int;
		
		public function Add(t:ModerMessagePlaceholder):void {
			if (dict[t.Id] == undefined) {
				count++;
			}
			dict[t.Id] = t;
		}
		public function Remove(t:ModerMessagePlaceholder):void {
			if (t.selected) {
				t.unselect();
			}
			if (dict[t.Id] != undefined) {
				count--;
			}
			delete dict[t.Id];
		}
		
		public function get selected():ModerMessagePlaceholder{
			return current;
		}
		
		public function Select(t:ModerMessagePlaceholder):void{
			if(current == t) return;
			if (current) {
				current.unselect();
			}
			current = t;
			t.select();
		}
		public function Unselect(t:ModerMessagePlaceholder):void{
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
				var t:ModerMessagePlaceholder = dict[i] as ModerMessagePlaceholder;
				if(t){
					t.unselect();
				}
			}
			current = null;
		}
		public function GetByMessageId(id:uint):ModerMessagePlaceholder {
			return dict[id];
		}
	}

}