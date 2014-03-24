package utilities 
{
	import mx.core.UIComponent;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class CircleComponent extends UIComponent 
	{
		
		private var _radius:Number = 10;
		private var _color:uint = 0;
		public function CircleComponent() 
		{
			
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			validate();
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			validate();
		}
		
		protected function validate():void {
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawEllipse(0, 0, _radius, _radius);
			setActualSize(_radius, _radius);
		}
		
	}

}