package messages
{
	
	import events.MessageEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name="messageCountChange",type="events.MessageEvent")]
	[Event(name="messageFavoriteChange",type="events.MessageEvent")]
	[Event(name="messageUpdate",type="events.MessageEvent")]
	[Event(name="messageStateChange",type="events.MessageEvent")]
	[Event(name="messageRemove",type="events.MessageEvent")]
	[Event(name="messageRemoveState",type="events.MessageEvent")]
	
	public class MessageList
	{
		private static var _messageCount:int;
		
		private static var _countScheduled:int;
		private static var _countAnswered:int;
		private static var _countFavorite:int;
		private static var _countClosed:int;
		
		private static var _event:EventDispatcher = new EventDispatcher();
		private static var _dictionary:Dictionary = new Dictionary(true);
		private static var _list:Vector.<Message> = new Vector.<Message>();
		
		public static function Add(m:Message, dispatch:Boolean = false):void
		{
			if (_dictionary[m.id]) {
				Update(m);
				return;
			}
			_dictionary[m.id] = m;
			_list.push(m);
			sort();
			if (dispatch) {
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_ADD);
				evt.message = m;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function Remove(m:Message):void
		{
			trace('MessageList -> Remove ' + m.id);
			delete _dictionary[m.id];
			var i:int = _list.indexOf(m);
			if (i != -1)
			{
				_list.splice(i, 1);
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_REMOVE);
				evt.message = m;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function RemoveById(id:uint):void
		{
			trace('MessageList -> RemoveById ' + id);
			var m:Message = _dictionary[id];
			if (m == null)
				return;
			var i:int = _list.indexOf(m);
			if (i != -1)
			{
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_REMOVE);
				evt.message = _list[i];
				_event.dispatchEvent(evt);
				_list.splice(i, 1);
			}
		}
		
		public static function RemoveStateMessage(state:String):void {
			trace('MessageList -> RemoveStateMessage ' + state);
			var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_REMOVE_STATE);
			evt.value = state;
			_event.dispatchEvent(evt);
			
			var deleteList:Vector.<Message> = new Vector.<Message>();
			for each (var m:Message in _list) 
			{
				if (m.state == state) {
					deleteList.push(m);
				}
			}
			for each (var item:Message in deleteList) 
			{
				Remove(item);
			}
		}
		
		public static function Update(m:Message = null):void
		{
			if (m == null) {
				//trace('MessageList -> Update');
				_event.dispatchEvent(new MessageEvent(MessageEvent.MESSAGE_UPDATE_LIST));
				return
			}
			//trace('MessageList -> Update ' + m.id);
			var mes:Message = _dictionary[m.id];
			if (mes == null)
			{
				Add(m);
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_ADD);
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
			if (mes.favorite != m.favorite) {
				Favorite(m.id, m.favorite);
			}
			if (mes.state != m.state) {
				State(m);
				return;
			}
			
			var uevt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_UPDATE);
			uevt.message = m;
			_event.dispatchEvent(uevt);
		}
		
		public static function GetById(id:uint):Message
		{
			return _dictionary[id];
		}
		
		public static function get List():Vector.<Message>
		{
			sort();
			return _list;
		}
		
		private static function sort():void
		{
			if(_list.length > 1)
			{
				quicksort(_list, 0, _list.length - 1);
				
			}
		}
		
		private static function quicksort(array:Vector.<Message>, left:int, right:int):void
		{
			var i:int = left;
			var j:int = right;
			var x:Message = array[int((left + right) >> 1)];
			do
			{
				while (array[i].lastUpdate < x.lastUpdate)
					i++;
				while (array[j].lastUpdate > x.lastUpdate)
					j--;
				if (i <= j)
				{
					var temp:Message = array[i];
					array[i] = array[j];
					array[j] = temp;
					i++;
					j--;
				}
			} while (i < j);
			if (left < j)
				quicksort(array, left, j);
			if (i < right)
				quicksort(array, i, right);
		}
		
		public static function Favorite(id:uint, favorite:Boolean):void
		{
			var m:Message = _dictionary[id];
			if (m == null)
				return;
			m.favorite = favorite;
			if (_event.hasEventListener(MessageEvent.MESSAGE_FAVORITE_CHANGE))
			{
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_FAVORITE_CHANGE);
				evt.message = m;
				_event.dispatchEvent(evt);
			}
		}
		public static function State(m:Message):void {
			var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_STATE_CHANGE);
			evt.message = m;
			_event.dispatchEvent(evt);
		}
		
		public static function Reset():void
		{
			trace('MessageList -> Reset');
			_dictionary = new Dictionary();
			_list.length = 0;
			ResetCount();
		}
		
		public static function ResetCount():void {
			trace('MessageList -> ResetCount');
			_messageCount = 0;
			_countAnswered = 0;
			_countClosed = 0;
			_countFavorite = 0;
			_countScheduled = 0;
		}
		
		
		public static function get messageCount():int
		{
			return _messageCount;
		}
		public static function set messageCount(value:int):void{
			if (value == _messageCount)
				return;
			_messageCount = value;
		}
		
		[Bindable]
		public static function get countScheduled():int {
			return _countScheduled;
		}
		public static function set countScheduled(value:int):void {
			if (_countScheduled == value)
				return;
			_countScheduled = value;
			messageCount = _countAnswered + _countClosed + _countFavorite + _countScheduled;
			_event.dispatchEvent(new MessageEvent(MessageEvent.MESSAGE_COUNT_CHANGE));
		}
		
		[Bindable]
		public static function get countAnswered():int {
			return _countAnswered;
		}
		public static function set countAnswered(value:int):void {
			if (_countAnswered == value)
				return;
			_countAnswered = value;
			messageCount = _countAnswered + _countClosed + _countFavorite + _countScheduled;
			_event.dispatchEvent(new MessageEvent(MessageEvent.MESSAGE_COUNT_CHANGE));
		}
		
		[Bindable]
		public static function get countFavorite():int {
			return _countFavorite;
		}
		public static function set countFavorite(value:int):void {
			if (_countFavorite == value) {
				return;
			}
			_countFavorite = value;
			messageCount = _countAnswered + _countClosed + _countFavorite + _countScheduled;
			_event.dispatchEvent(new MessageEvent(MessageEvent.MESSAGE_COUNT_CHANGE));
		}
		
		[Bindable]
		public static function get countClosed():int {
			return _countClosed;
		}
		public static function set countClosed(value:int):void {
			if (_countClosed == value) {
				return;
			}
			_countClosed = value;
			messageCount = _countAnswered + _countClosed + _countFavorite + _countScheduled;
			_event.dispatchEvent(new MessageEvent(MessageEvent.MESSAGE_COUNT_CHANGE));
		}
		
		public static function addListener(type:String, listener:Function):void{
			_event.addEventListener(type, listener);
		}
		
		public static function removeListener(type:String, listener:Function):void{
			_event.removeEventListener(type, listener);
		}
	}
}