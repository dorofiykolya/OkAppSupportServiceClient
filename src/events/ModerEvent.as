package events
{
	import flash.events.Event;
	
	import messages.Moder;
	
	public class ModerEvent extends Event
	{
		public static const MODER_COUNT_CHANGE:String = 'moderCountChange';
		public static const MODER_UPDATE:String = 'moderUpdate';
		public static const MODER_ADD:String = 'moderAdd';
		public static const MODER_UPDATE_LIST:String = 'moderUpdateList';
		public static const MODER_SELECT:String = 'moderSelect';
		
		public var moder:Moder;
		
		public function ModerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}