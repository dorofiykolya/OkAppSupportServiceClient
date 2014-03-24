package utilities 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flexlib.controls.Highlighter;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class TextFieldHighliter extends Highlighter 
	{
		private var startIndex:int;
		private var lastIndex:int;
		
		private var textField:TextField;
		
		public function TextFieldHighliter(textArea:UIComponent) 
		{
			getTextField(textArea);
			super(textField);
			textField.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			textField.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			textField.parent.addEventListener(Event.RESIZE, onResize, true, 2, true);
		}
		
		private function getTextField(textArea:UIComponent):void {
			var len:int = textArea.numChildren;
			var r:TextField;
                for(var i:int=0; i<len; i++){
                    var thisChild:DisplayObject = textArea.getChildAt(i);
                    if(thisChild is TextField){
                        r = thisChild as TextField;
                    }
                }
            if (r == null) {
				throw new Error("TextFieldHighliter textArea is not have TextField");
			}
			textField = r;
		}
		
		private function onResize(e:Event):void 
		{
			bitmap.width = textField.width;
			bitmap.height = textField.height;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			//startIndex = textField.
		}
		
	}

}