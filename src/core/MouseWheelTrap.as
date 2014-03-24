package core 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class MouseWheelTrap {
		static private var _mouseWheelTrapped :Boolean;
		public static function setup(mainStage:Stage):void {
			mainStage.addEventListener(Event.ACTIVATE, function(e:Event):void {
				allowBrowserScroll(false);
			});
			mainStage.addEventListener(Event.DEACTIVATE, function(e:Event):void {
				allowBrowserScroll(true);
			});
			mainStage.addEventListener(Event.MOUSE_LEAVE, function(e:Event):void {
				allowBrowserScroll(true);
			});
			mainStage.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{ 
				allowBrowserScroll(false); 
				}
			);
			mainStage.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{ 
				allowBrowserScroll(true); 
				}
			);
			mainStage.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{ 
				allowBrowserScroll(false); 
				}
			);
		}
		private static function allowBrowserScroll(allow:Boolean):void
		{
			createMouseWheelTrap();
			if (ExternalInterface.available){
				ExternalInterface.call("allowBrowserScroll", allow);
			}
		}
		private static function createMouseWheelTrap():void
		{
			if (_mouseWheelTrapped) {return;} _mouseWheelTrapped = true; 
			if (ExternalInterface.available) {
				ExternalInterface.call("eval", "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;}}if(window.addEventListener){window.addEventListener('DOMMouseScroll',wheel,false);}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);");
			}
		}
	}
}
