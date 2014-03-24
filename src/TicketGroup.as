package
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class TicketGroup extends EventDispatcher
	{
		
		public static var scheduledGroup:TicketGroup = new TicketGroup();
		public static var answeredGroup:TicketGroup = new TicketGroup();
		public static var closedGroup:TicketGroup = new TicketGroup();
		public static var favoriteGroup:TicketGroup = new TicketGroup();
		
		private var current:TicketPlaceholder;
		private var dict:Dictionary = new Dictionary();
		private var count:int;
		
		public function Add(t:TicketPlaceholder):void{
			if (dict[t.message.id] == undefined) {
				count++;
			}
			dict[t.message.id] = t;
		}
		public function Remove(t:TicketPlaceholder):void {
			if (t.selected) {
				t.unselect();
			}
			if (dict[t.message.id] != undefined) {
				count--;
			}
			delete dict[t.message.id];
		}
		public function get selected():TicketPlaceholder{
			return current;
		}
		public function Select(t:TicketPlaceholder):void{
			if(current == t) return;
			if(current){
				current.unselect();
			}
			current = t;
			t.select();
		}
		public function Unselect(t:TicketPlaceholder):void{
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
				var t:TicketPlaceholder = dict[i] as TicketPlaceholder;
				if(t){
					t.unselect();
				}
			}
			current = null;
		}
		public function GetByMessageId(id:uint):TicketPlaceholder {
			return dict[id];
		}
		
		public function SelectFirst():void
		{
			UnselectAll();
			var min:int = int.MAX_VALUE;
			var current:TicketPlaceholder;
			for each (var ticket:TicketPlaceholder in dict) 
			{
				if(ticket.visible && ticket.message.lastUpdate < min)
				{
					min = ticket.message.lastUpdate;
					current = ticket;
				}
			}
			if(current)
			{
				Select(current);
			}
		}
	}
}