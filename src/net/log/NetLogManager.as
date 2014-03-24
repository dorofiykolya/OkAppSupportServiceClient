package net.log 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class NetLogManager 
	{
		private static var _stage:Stage;
		private static var _container:UIComponent;
		private static var _hotKay:Boolean = true;
		private static var _key:uint = 76;
		private static var _alt:Boolean;
		private static var _ctrl:Boolean;
		private static var _shift:Boolean;
		
		public static function open():void {
			net.log.NetLogViewer.show();
		}
		
		public static function close():void {
			net.log.NetLogViewer.hide();
			for each(var w:net.log.NetLogWindow in net.log.NetLogWindow.windows) {
				w.hide();
			}
		}
		
		public static function Initilize(stage:Stage, container:UIComponent):void {
			_stage = stage;
			_container = container;
			validateHotKey();
		}
		
		public static function setHotKey(key:uint = 76, ctrl:Boolean = false, shift:Boolean = false):void {
			_key = key;
			_ctrl = ctrl;
			_shift = shift;
			if (_stage == null) {
				throw new Error('NetLogManager::setHotKey -> Stage == null, Initilize please!');
			}
			validateHotKey();
		}
		
		static public function get useHotKay():Boolean {
			return _hotKay;
		}
		
		static public function set useHotKay(value:Boolean):void {
			_hotKay = value;
			validateHotKey();
		}
		
		static private function validateHotKey():void {
			if (_stage == null) return;
			if (_hotKay) _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);	
			else _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);	
		}
		
		static private function onKeyboardDown(e:KeyboardEvent):void 
		{
			if (e.ctrlKey == _ctrl && e.shiftKey == e.shiftKey && _key == e.keyCode) {
				net.log.NetLogViewer.show();
			}
		}
		
		static internal function get container():UIComponent {
			return _container;
		}
		
		
	}

}