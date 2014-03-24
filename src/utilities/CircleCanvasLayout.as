package utilities
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.containers.Canvas;
	import mx.core.IUIComponent;
	import mx.effects.Rotate;
	import mx.effects.easing.Linear;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	[Style(name="rotateBackgroundImage",inherit="no",type="Class",format="Class")]
	[Event(name="change", type="flash.events.Event")]
	public class CircleCanvasLayout extends Canvas
	{
		private static const TWO_PI:Number = Math.PI * 2;
		private static const PI_OVER_180:Number = Math.PI / 180;
		
		private var _rotationLayout:Number = 0;
		private var _rotateElements:Boolean = false;
		private var _liveRotation:Boolean = false;
		private var _rotateBackgroundCanvas:Canvas;
		private var _bitmapData:BitmapData;
		
		public function CircleCanvasLayout()
		{
			
		}
		
		public function set backgroundBitmapData(data:BitmapData):void {
			_bitmapData = data;
		}
		
		public function set liveRotation(value:Boolean):void
		{
			_liveRotation = value;
		}
		
		public function set rotationLayout(value:Number):void
		{
			_rotationLayout = value;
			if (_liveRotation)
			{
				updateRotation();
			}
			invalidateDisplayList();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set rotateElements(value:Boolean):void
		{
			_rotateElements = value;
			invalidateDisplayList();
		}
		
		public function get rotateElements():Boolean
		{
			return _rotateElements;
		}
		
		public function get liveRotation():Boolean
		{
			return _liveRotation;
		}
		
		public function get rotationLayout():Number
		{
			return _rotationLayout;
		}
		
		protected function validateBackground():Boolean {
			if (_bitmapData == null) return false;
			graphics.clear();
//			var matrix:Matrix = new Matrix();
//			matrix.createBox(1, 1, (_rotationLayout / 180) * Math.PI, width / 2 - _bitmapData.width / 2, height / 2 - _bitmapData.height / 2);
//			
//			graphics.beginBitmapFill(_bitmapData, matrix, false, true);
//			graphics.drawCircle(width / 2, height / 2, _bitmapData.width / 2);
//			
//			backCanvas.x = circle.x + circle.width / 2;
//			backCanvas.y = circle.y + circle.height / 2;
//			backCanvas.graphics.clear();
//			var m:Matrix = new Matrix();
//			m.createBox(1, 1, _rotationLayout * 180 / Math.PI, -_bitmapData.width / 2, -_bitmapData.height / 2);
//			graphics.beginBitmapFill(_bitmapData, m, false, true);
//			graphics.drawCircle(0, 0, _bitmapData.width / 2);
			return true;
		}
		
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			if (validateBackground()) return;
			var _rotateBackgroundImage:* = getStyle('rotateBackgroundImage');
			if (_rotateBackgroundImage != undefined)
			{
				if (_rotateBackgroundCanvas == null) {
					_rotateBackgroundCanvas = new Canvas();
					_rotateBackgroundCanvas.includeInLayout = false;
					_rotateBackgroundCanvas.clipContent = false;
					rawChildren.addChild(_rotateBackgroundCanvas);
				}
				_rotateBackgroundCanvas.setStyle('backgroundImage', _rotateBackgroundImage);
				_rotateBackgroundCanvas.setActualSize(width, height);
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateRotation();
			if (_rotateBackgroundCanvas) {
				_rotateBackgroundCanvas.setActualSize(width, height);
			}
		}
		
		protected function updateRotation():void
		{
			if (validateBackground() == false && _rotateBackgroundCanvas) {
				setRotaionAroundCenter(_rotateBackgroundCanvas, _rotationLayout);
			}
			
			var component:DisplayObject = null;
			var _width:Number = NaN;
			var _height:Number = NaN;
			var matrix:Matrix3D = null;
			var _x:Number = 0;
			var _y:Number = 0;
			var _tempWidth:Number = 0;
			var _tempHeight:Number = 0;
			var _heightValue:Number = 0;
			var _rotation:Number = 0;
			var childCount:int = this.numChildren;
			var i:int = 0;
			while (i < childCount)
			{
				component = getChildAt(i);
				component.transform.matrix3D = new Matrix3D();
				_width = component.width;              
				_height = component.height;
				if (_width > _tempWidth)
				{
					_tempWidth = _width;
				}
				if (_height > _tempHeight)
				{
					_tempHeight = _height;
				}
				++i;
			}
			var _rotateElementValue:Number = this._rotateElements ? _tempHeight : _tempWidth;
			if (unscaledWidth - _rotateElementValue > unscaledHeight - _tempHeight)
			{
				_heightValue = 0.5 * (unscaledHeight - _tempHeight);
			}
			else
			{
				_heightValue = 0.5 * (unscaledWidth - _rotateElementValue);
			}
			var j:int = 0;
			while (j < childCount)
			{
				component = getChildAt(j);
				_rotation = j / childCount * TWO_PI + _rotationLayout * PI_OVER_180;
				if (_rotateElements)
				{
					matrix = new flash.geom.Matrix3D();
					matrix.appendRotation(_rotation / PI_OVER_180 + 90, Vector3D.Z_AXIS);
					component.transform.matrix3D = matrix;
				}
				_width = component.width;
				_height = component.height;
				_x = Math.round(_heightValue * Math.cos(_rotation) + 0.5 * (unscaledWidth - _width));
				_y = Math.round(_heightValue * Math.sin(_rotation) + 0.5 * (unscaledHeight - _height));
				component.x = _x;
				component.y = _y;
				++j;
			}
			return;
		}
		
		private function setRotaionAroundCenter(object:DisplayObject, angle:Number):void
		{
			// находим центр клипа
			var rotate:Number = object.rotation;
			object.rotation = 0;
			var w:Number = object.width;
			var h:Number = object.height;
			object.rotation = rotate;
			var centerPoint:Point = new Point(w / 2, h / 2);
			var matrix:Matrix = new Matrix();
			matrix.rotate((rotate / 180) * Math.PI);
			centerPoint = matrix.transformPoint(centerPoint);
			centerPoint.offset(object.x, object.y); //теперь это настоящая точка нахождения центра клипа
			
			//находим точку , где после поворота вокруг центра клипа будет находиться 
			// его изначальная точка привязки (Top-Left)
			var newPosition:Point = new Point(-w / 2, -h / 2);
			matrix = new Matrix();
			matrix.rotate((angle / 180) * Math.PI);
			newPosition = matrix.transformPoint(newPosition);
			newPosition = newPosition.add(centerPoint);
			object.rotation = angle;
			object.x = newPosition.x;
			object.y = newPosition.y;
		}
	}
}
