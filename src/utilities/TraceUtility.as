package utilities 
{
	import flash.trace.Trace;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class TraceUtility 
	{
		private static var isInit:Boolean;
		private static var linesExecuted:uint = 0;
		private static var remoteTrace:Boolean;
		public function TraceUtility() 
		{
			
		}
		
		public static function startTrace(remote:Boolean = false):void {
			remoteTrace = remote;
			if (isInit == false) {
				Trace.setListener(traceListener);
				isInit = true;
			}
			Trace.setLevel(Trace.METHODS_AND_LINES_WITH_ARGS, Trace.LISTENER);
		}
		
		
		public static function stopTrace():void {
			remoteTrace = false;
			Trace.setLevel(Trace.OFF, Trace.LISTENER); 
			trace('Total lines executed: ' + linesExecuted);
            linesExecuted = 0;
		}
		
		private static function traceListener(fileInfo:String, lineNumber:String, classAndMethod:String, methodArguments:String):void {
            linesExecuted++;
			while (lineNumber.length <= 5) {
				lineNumber = ' ' + lineNumber;
			}
			var message:String = lineNumber + " [" + classAndMethod + '](' + methodArguments + ')';
            trace(message); 
			if (remoteTrace) DebugRemote.Send(message);
        }
		
	}

}