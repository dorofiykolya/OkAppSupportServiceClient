package utilities 
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Destructor 
	{
		
		public function Destructor() 
		{
			
		}
		public static function destroy(object:IDestructor):void {
			object.destroy();
		}
		public static function destroyAll(...params:IDestructor):void{
			for (var s:String in params){
				if(params[s] is IDestructor){
					params[s].destroy();
				}
			}
		}
		
	}

}