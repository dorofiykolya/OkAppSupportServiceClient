package events
{
	import flash.events.Event;
	
	import messages.Message;
	
	public class MessageEvent extends Event
	{
		public static const MESSAGE_COUNT_CHANGE:String = 'messageCountChange';
		public static const MESSAGE_FAVORITE_CHANGE:String = 'messageFavoriteChange';
		public static const MESSAGE_UPDATE:String = 'messageUpdate';
		public static const MESSAGE_ADD:String = 'messageAdd';
		public static const MESSAGE_UPDATE_LIST:String = 'messageUpdateList';
		public static const MESSAGE_STATE_CHANGE:String = 'messageStateChange';
		public static const MESSAGE_REMOVE:String = 'messageRemove';
		public static const MESSAGE_REMOVE_STATE:String = 'messageRemoveState';
		
		public var message:Message;
		public var value:Object;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}