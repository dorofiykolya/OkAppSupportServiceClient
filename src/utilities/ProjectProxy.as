package utilities 
{
	import core.Core;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public dynamic class ProjectProxy extends Proxy 
	{
		
		public function ProjectProxy() 
		{
			
		}
		
		override flash_proxy function callProperty(name:*, ...rest):* 
		{
			try {
				if (name != 'call') return;
					var classReference:Class = getDefinitionByName(rest[0]) as Class;
					if (classReference == null) {
						Debug.Trace('Class undefined, by name: ' + name);
						return null;
					}
					if ((classReference[rest[1]] as Function).length == 0) {
						(classReference[rest[1]] as Function)();
						return;
					}
					if (rest.length > 2) {
						(classReference[rest[1]] as Function).apply(null, rest[2] as Array);
						return null;
					}
					classReference[rest[1]]();
				
			}catch (e:Error) {
				Debug.Trace(e.message);
			}
		}
		override flash_proxy function getProperty(name:*):* 
		{
			
		}
		override flash_proxy function setProperty(name:*, value:*):void 
		{
			
		}
		
		private static var inst:ProjectProxy;
		public static function get instance():ProjectProxy{
			if(inst == null) inst = new ProjectProxy();
			return inst as ProjectProxy;
		}
		
	}

}