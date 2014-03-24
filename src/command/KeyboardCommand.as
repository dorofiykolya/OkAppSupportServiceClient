package command 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class KeyboardCommand 
	{
		private static var _stage:Stage;
		public function KeyboardCommand() 
		{
			
		}
		
		public static function register():void {
			
		}
		public static function unregister():void {
			
		}
		
		
		public static function Initilize(stage:Stage, keyboardType = 'keyDown'):void {
			if (stage == null) return;
			_stage = stage;
			_stage.addEventListener(keyboardType, listener);
		}
		
		static private function listener(e:Event):void 
		{
			
		}
		
		
		
		private static var inst:KeyboardCommand;
		public static function get instance():KeyboardCommand{
			if(inst == null) inst = new KeyboardCommand();
			return inst as KeyboardCommand;
		}
	}

}