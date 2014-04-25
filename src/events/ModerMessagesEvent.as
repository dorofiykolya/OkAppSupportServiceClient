package events 
{
	import flash.events.Event;
	import messages.Message;
	import messages.Word;
	
	/**
	 * ...
	 * @author Mike Silanin
	 */
	public class ModerMessagesEvent extends Event 
	{
		public static const MODER_MESSAGES_ADD:String = 'moderMessagesAdd';
		public static const MODER_MESSAGES_ADD_LIST:String = 'moderMessagesAddList';
		public static const MODER_MESSAGES_UPDATE:String = 'moderMessagesUpdate';
		public static const MODER_MESSAGES_REMOVE:String = 'moderMessagesRemove';
		
		public static const MODER_TICKETS_UPDATE:String = 'moderTicketsUpdate';
		public static const MODER_TICKETS_ADD:String = 'moderTicketsAdd';
		public static const MODER_TICKETS_ADD_LIST:String = 'moderTicketsAddList';
		public static const MODER_TICKETS_REMOVE:String = 'moderTicketsRemove';
		
		public var message:Message;
		public var word:Word;
		
		public function ModerMessagesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ModerMessagesEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModerMessagesEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}