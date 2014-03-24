package utilities 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class SafeInvoke 
	{
		public static function Invoke(func:Function, ...params):void {
			InvokeParams(func, params);
		}
		public static function InvokeParams(func:Function, params:Array = null):void {
			try {
				func.apply(null, params);
			}catch (e:Error) {
				Debug.Trace(e.message, e.getStackTrace());
			}
		}
	}

}