package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mike Silanin
	 */
	public class StateChange extends Event 
	{
		public static const CHANGE_GROUP:String = 'changeGroup';
		private var _group:String = "";
		
		public function StateChange(type:String, group:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this._group = group;
		}
		
		public function get Group():String {
			return _group;
		}
		
		public function set Group(value:String):void {
			_group = value;
		}
		
		public override function clone():Event 
		{ 
			return new StateChange(type, _group, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateChange", _group, "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}