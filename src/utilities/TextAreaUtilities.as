package utilities
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.TextArea;
	import mx.core.IUITextField;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	use namespace mx_internal;
	
	public class TextAreaUtilities
	{
		public static const RESIZE_TYPE_AUTOSIZE:String = 'resize_type_autosize';
		public static const RESIZE_TYPE_NUMLINES:String = 'resize_type_numlines';
		
		public function TextAreaUtilities()
		{
		
		}
		
		public static function resizeFromText(field:TextArea, resizeType:String = 'resize_type_numlines'):void
		{
			if (RESIZE_TYPE_AUTOSIZE)
			{
				field.validateNow();
				field.mx_internal::getTextField().autoSize = TextFieldAutoSize.LEFT;
				field.height = field.mx_internal::getTextField().height;
				field.mx_internal::getTextField().autoSize = TextFieldAutoSize.NONE;
			}
			if (RESIZE_TYPE_NUMLINES)
			{
				var h:int;
				var t:IUITextField = field.mx_internal::getTextField();
				for (var i:int = 0; i < t.numLines; i++)
				{
					h += t.getLineMetrics(i).height;
				}
				field.height = h;
			}
		}
		
		public static function getNumLinesHeightFromText(field:TextArea):int
		{
			var h:int;
			var t:IUITextField = field.mx_internal::getTextField();
			for (var i:int = 0; i < t.numLines; i++)
			{
				h += t.getLineMetrics(i).height;
			}
			return h;
		}
	
	}

}