package utilities 
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class TextFieldUtils 
	{
		
		public static function getTextField(component:TextArea):TextField {
			 var len:int = component.numChildren;
                var r:TextField;
                for(var i:int=0; i<len; i++){
                    var thisChild:DisplayObject = component.getChildAt(i);
                    if(thisChild is TextField){
                        r = thisChild as TextField;
                    }
                }
                return r;
		}
		
	}

}