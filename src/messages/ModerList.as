package messages
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import events.ModerEvent;
	
	[Event(name="moderCountChange",type="events.ModerEvent")]
	[Event(name="moderFavoriteChange",type="events.ModerEvent")]
	[Event(name="moderUpdate",type="events.ModerEvent")]
	[Event(name="moderStateChange",type="events.ModerEvent")]
	[Event(name="moderSelect",type="events.ModerEvent")]
	
	public class ModerList
	{
		private static var _messageCount:int;
		private static var _countModer:int;
		
		private static var _event:EventDispatcher = new EventDispatcher();
		private static var _dictionary:Dictionary = new Dictionary(true);
		private static var _list:Vector.<Moder> = new Vector.<Moder>();
		
		public static function Add(m:Moder, dispatch:Boolean = false):void
		{
			if (_dictionary[m.id]) {
				Update(m);
				return;
			}
			_dictionary[m.id] = m;
			_list.push(m);
			if (dispatch) {
				var evt:ModerEvent = new ModerEvent(ModerEvent.MODER_ADD);
				evt.moder = m;
				_event.dispatchEvent(evt);
			}
		}
		
		/*public static function Remove(m:Moder):void
		{
			trace('MessageList -> Remove ' + m.id);
			delete _dictionary[m.id];
			var i:int = _list.indexOf(m);
			if (i != -1)
			{
				_list.splice(i, 1);
				var evt:ModerEvent = new ModerEvent(ModerEvent.MODER_REMOVE);
				evt.moder = m;
				_event.dispatchEvent(evt);
			}
		}
		
		public static function RemoveById(id:uint):void
		{
			trace('MessageList -> RemoveById ' + id);
			var m:Moder = _dictionary[id];
			if (m == null)
				return;
			var i:int = _list.indexOf(m);
			if (i != -1)
			{
				var evt:ModerEvent = new ModerEvent(ModerEvent.MODER_REMOVE);
				evt.moder = _list[i];
				_event.dispatchEvent(evt);
				_list.splice(i, 1);
			}
		}*/
		
		public static function Update(m:Moder = null):void
		{
			if (m == null) {
				_event.dispatchEvent(new ModerEvent(ModerEvent.MODER_UPDATE_LIST));
				return
			}
			var mes:Moder = _dictionary[m.id];
			if (mes == null)
			{
				Add(m);
				var evt:ModerEvent = new ModerEvent(ModerEvent.MODER_ADD);
				evt.moder = m;
				_event.dispatchEvent(evt);
				return;
			}
			var i:int = _list.indexOf(mes);
			if (i != -1)
			{
				_list[i] = m;
			}
			_dictionary[m.id] = m;
			
			var uevt:ModerEvent = new ModerEvent(ModerEvent.MODER_UPDATE);
			uevt.moder = m;
			_event.dispatchEvent(uevt);
		}
		
		public static function GetById(id:uint):Moder
		{
			return _dictionary[id];
		}
		
		public static function get List():Vector.<Moder>
		{
			return _list;
		}
		
		public static function Reset():void
		{
			_dictionary = new Dictionary();
			_list.length = 0;
			ResetCount();
		}
		
		public static function ResetCount():void {
			_messageCount = 0;
			_countModer = 0;
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
		public static function get countModer():int {
			return _countModer;
		}
		public static function set countModer(value:int):void {
			if (_countModer == value)
				return;
			_countModer = value;
			messageCount = _countModer;
			_event.dispatchEvent(new ModerEvent(ModerEvent.MODER_COUNT_CHANGE));
		}
		
		public static function addListener(type:String, listener:Function):void{
			_event.addEventListener(type, listener);
		}
		
		public static function removeListener(type:String, listener:Function):void{
			_event.removeEventListener(type, listener);
		}
	}
}