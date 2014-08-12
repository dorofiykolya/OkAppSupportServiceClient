package messages 
{
	/**
	 * ...
	 * @author Mike Silanin
	 */
	import events.ModerMessagesEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name = "moderMessagesUpdate", type = "events.ModerMessagesEvent")]
	[Event(name = "moderMessagesAdd", type = "events.ModerMessagesEvent")]
	[Event(name = "moderMessagesAddList", type = "events.ModerMessagesEvent")]
	[Event(name = "moderMessagesRemove", type = "events.ModerMessagesEvent")]
	
	[Event(name = "moderTicketsUpdate", type = "events.ModerMessagesEvent")]
	[Event(name = "moderTicketsAdd", type = "events.ModerMessagesEvent")]
	[Event(name = "moderTicketsAddList", type = "events.ModerMessagesEvent")]
	[Event(name = "moderTicketsRemove", type = "events.ModerMessagesEvent")]
	
	public class ModerMessagesList 
	{
		private static var _event:EventDispatcher = new EventDispatcher();
		private static var _dictionary:Dictionary = new Dictionary(true);
		private static var _list:Vector.<Word> = new Vector.<Word>();
		
		public static function AddList(list:Vector.<Word> = null, tickets:Boolean = false):void
		{
			Reset();
			if (list == null) {
				return;
			}
			if (list.length == 0) {
				return;
			}
			for each (var w:Word in list) 
			{
				Add(w, false, tickets);
			}
			var evt:ModerMessagesEvent = new ModerMessagesEvent(tickets ? ModerMessagesEvent.MODER_TICKETS_ADD_LIST : ModerMessagesEvent.MODER_MESSAGES_ADD_LIST);
			_event.dispatchEvent(evt);
		}
		
		public static function Add(w:Word, dispatch:Boolean = false, ticket:Boolean = false):void
		{
			if (_dictionary[w.id])
			{
				Update(w, ticket);
				return;
			}
			_dictionary[w.id] = w;
			_list.push(w);
			
			if (dispatch == false)
			{
				return;
			}
			var evt:ModerMessagesEvent = new ModerMessagesEvent(ticket ? ModerMessagesEvent.MODER_TICKETS_ADD : ModerMessagesEvent.MODER_MESSAGES_ADD);
			evt.word = w;
			_event.dispatchEvent(evt);
		}
		
		public static function Update(w:Word = null, ticket:Boolean = false):void
		{
			if (w == null)
			{
				_event.dispatchEvent(new ModerMessagesEvent(ticket ? ModerMessagesEvent.MODER_TICKETS_UPDATE : ModerMessagesEvent.MODER_MESSAGES_UPDATE));
				return
			}
			var mes:Word = _dictionary[w.id];
			if (mes == null)
			{
				Add(w, true, ticket);
				return;
			}
			var i:int = _list.indexOf(mes);
			if (i != -1)
			{
				_list[i] = w;
			}
			_dictionary[w.id] = w;
			
			var uevt:ModerMessagesEvent = new ModerMessagesEvent(ticket ? ModerMessagesEvent.MODER_TICKETS_UPDATE : ModerMessagesEvent.MODER_MESSAGES_UPDATE);
			uevt.word = w;
			_event.dispatchEvent(uevt);
		}
		
		public static function Remove(w:Word, ticket:Boolean = false):void
		{
			delete _dictionary[w.id];
			var i:int = _list.indexOf(w);
			if (i != -1)
			{
				_list.splice(i, 1);
				var evt:ModerMessagesEvent = new ModerMessagesEvent(ticket ? ModerMessagesEvent.MODER_TICKETS_REMOVE : ModerMessagesEvent.MODER_MESSAGES_REMOVE);
				evt.word = w;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function GetById(id:uint):Word
		{
			return _dictionary[id];
		}
		
		public static function get List():Vector.<Word>
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