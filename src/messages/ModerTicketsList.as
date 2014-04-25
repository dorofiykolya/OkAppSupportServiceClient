package messages 
{
	/**
	 * ...
	 * @author Mike Silanin
	 */
	import events.ModerMessagesEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name = "moderTicketsUpdate", type = "events.ModerTicketsEvent")]
	[Event(name = "moderTicketsAdd", type = "events.ModerTicketsEvent")]
	[Event(name = "moderTicketsAddList", type = "events.ModerTicketsEvent")]
	[Event(name = "moderTicketsRemove", type = "events.ModerTicketsEvent")]
	[Event(name = "moderMessagesUpdate", type = "events.ModerTicketsEvent")]
	[Event(name = "moderMessagesAdd", type = "events.ModerTicketsEvent")]
	[Event(name = "moderMessagesAddList", type = "events.ModerTicketsEvent")]
	[Event(name = "moderMessagesRemove", type = "events.ModerTicketsEvent")]
	
	public class ModerTicketsList 
	{

		private static var _event:EventDispatcher = new EventDispatcher();
		private static var _dictionary:Dictionary = new Dictionary(true);
		private static var _list:Vector.<Message> = new Vector.<Message>();
		
		public static function AddList(list:Vector.<Message> = null):void
		{
			trace('ModerTicketsList -> AddList');
			if (list == null) {
				trace('ModerTicketsList -> AddList: list == null');
				return;
			}
			if (list.length == 0) {
				trace('ModerTicketsList -> AddList: list.length == 0');
				return;
			}
			for each (var m:Message in list) 
			{
				Add(m);
			}
			
			var evt:ModerMessagesEvent = new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_ADD_LIST);
			_event.dispatchEvent(evt);
		}
		
		public static function Add(m:Message, dispatch:Boolean = false):void
		{
			trace('ModerTicketsList -> Add ' + m.id);
			if (_dictionary[m.id]) {
				Update(m);
				return;
			}
			_dictionary[m.id] = m;
			_list.push(m);
			if (dispatch) {
				var evt:ModerMessagesEvent = new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_ADD);
				evt.message = m;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function Update(m:Message = null):void
		{
			if (m == null) {
				//trace('ModerTicketsList -> Update ');
				_event.dispatchEvent(new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_UPDATE));
				return
			}
			//trace('ModerTicketsList -> Update ' + m.id);
			var mes:Message = _dictionary[m.id];
			if (mes == null)
			{
				Add(m);
				var evt:ModerMessagesEvent = new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_ADD);
				evt.message = m;
				_event.dispatchEvent(evt);
				return;
			}
			var i:int = _list.indexOf(mes);
			if (i != -1)
			{
				_list[i] = m;
			}
			_dictionary[m.id] = m;
			
			var uevt:ModerMessagesEvent = new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_UPDATE);
			uevt.message = m;
			_event.dispatchEvent(uevt);
		}
		
		public static function Remove(m:Message):void
		{
			trace('ModerTicketsList -> Remove ' + m.id);
			delete _dictionary[m.id];
			var i:int = _list.indexOf(m);
			if (i != -1)
			{
				_list.splice(i, 1);
				var evt:ModerMessagesEvent = new ModerMessagesEvent(ModerMessagesEvent.MODER_TICKETS_REMOVE);
				evt.message = m;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function GetById(id:uint):Message
		{
			return _dictionary[id];
		}
		
		public static function get List():Vector.<Message>
		{
			return _list;
		}
		
		public static function Reset():void
		{
			_dictionary = new Dictionary();
			_list.length = 0;
		}
		
		public static function addListener(type:String, listener:Function):void{
			_event.addEventListener(type, listener);
		}
		
		public static function removeListener(type:String, listener:Function):void{
			_event.removeEventListener(type, listener);
		}
		
	}

}