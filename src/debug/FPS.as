package debug 
{
	import core.GlobalManager;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import mx.containers.Canvas;
	import mx.controls.TextArea;

	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class FPS 
	{
		private static var txt:TextField;
		private static var last:uint = getTimer();
		private static var frame:uint;
		private static var isVisible:Boolean;
		public function FPS() 
		{
		}
		public static function show(x:int = 0, y:int = 0):void {
			if(isVisible){
				if(txt){
					txt.x = x;
					txt.y = y;
				}
				return;
			}
			txt = new TextField();
			txt.x = x;
			txt.y = y;
			txt.mouseEnabled = false;
			txt.border = true;
			txt.background = true;
			txt.width = 60;
			txt.height = 20;
			txt.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			GlobalManager.stage.addChild(txt);
			isVisible = true;
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			frame++;
            var now:uint = getTimer();
            var delta:uint = now - last;
            if (delta >= 1000) {
                var fps:Number = frame / delta * 1000;
                txt.text = fps.toFixed(1) + " fps";
                frame = 0;
                last = now;
            }
		}
		public static function hide():void {
			if(isVisible == false) return;
			txt.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if(GlobalManager.stage.contains(txt)){
				GlobalManager.stage.removeChild(txt);
				isVisible = false;
			}
			txt = null;
		}
		
	}

}