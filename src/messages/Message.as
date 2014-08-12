package messages
{
	public class Message
	{
		public static const STATE_SCHEDULED:String = 'scheduled';
		public static const STATE_ANSWERED:String = 'answered';
		public static const STATE_CLOSED:String = 'closed';
		public static const STATE_READ:String = 'read';
		
		public static const TYPE_ERROR:String = 'error';
		public static const TYPE_PROPOSAL:String = 'proposal';
		public static const TYPE_PARTNERSHIP:String = 'partnership';
		public static const TYPE_THANKS:String = 'thanks';
		public static const TYPE_COMPLAINT:String = 'complaint';
		
		public static function getType(type:String):String{
			switch(type){
				case TYPE_ERROR: return "ошибка";
				case TYPE_PROPOSAL: return "предложение";
				case TYPE_PARTNERSHIP: return "партнерство";
				case TYPE_THANKS: return "благодарность";
				case TYPE_COMPLAINT: return "жалоба";
			}
			return "...";
		}
		
		public static function getState(state:String):String{
			switch(state){
				case STATE_SCHEDULED: return "обработано";
				case STATE_ANSWERED: return "отвечено";
				case STATE_CLOSED: return "закрыто";
				case STATE_READ: return "прочтено";
			}
			return "...";
		}
		
		public var id:uint;
		public var title:String;
		public var game_id:int;
		public var owner:Owner;
		public var createTime:Number;
		public var favorite:Boolean;
		public var lastUpdate:Number;
		public var type:String;
		public var state:String;
		
		public var isDonator:Boolean;
		public var clientVersion:String;
		public var deviceName:String;
		
		public var language:String;
	}
}