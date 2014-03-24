package utilities
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class ContentSpaceConverter
	{
		public function ContentSpaceConverter()
		{
		}
		public static function convert(p:Point, from:DisplayObject, to:DisplayObject):Point{
			var g:Point = from.localToGlobal(p);
			return to.globalToLocal(g);
		}
	}
}