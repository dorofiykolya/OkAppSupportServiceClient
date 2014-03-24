package utilities
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public final class DisplayObjectUtil
	{
		public function DisplayObjectUtil()
		{
		
		}
		
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid)
			{
				var rect:Rectangle = target.scale9Grid;
				
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			if (autoAdd && target.parent)
			{
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
		
		public static function getChildren(parent:DisplayObjectContainer):Array
		{
			const children:Array = [];
			var i:int = -1;
			
			while (++i < parent.numChildren)
				children.push(parent.getChildAt(i));
			
			return children;
		}
		
		/**
		 * Returns the X and Y offset to the top left corner of the <code>DisplayObject</code>. The offset can be used to position <code>DisplayObject</code>s whose alignment point is not at 0, 0 and/or is scaled.
		 * @param       displayObject: The <code>DisplayObject</code> to align.
		 * @return  The X and Y offset to the top left corner of the <code>DisplayObject</code>.
		 * @example
		   <code>
		   var box:CasaSprite = new CasaSprite();
		   box.scaleX         = -2;
		   box.scaleY         = 1.5;
		   box.graphics.beginFill(0xFF00FF);
		   box.graphics.drawRect(-20, 100, 50, 50);
		   box.graphics.endFill();
		
		   const offset:Point = DisplayObjectUtil.getOffsetPosition(box);
		
		   trace(offset)
		
		   box.x = 10 + offset.x;
		   box.y = 10 + offset.y;
		
		   this.addChild(box);
		   </code>
		 */
		public static function getOffsetPosition(displayObject:DisplayObject):Point
		{
			const bounds:Rectangle = displayObject.getBounds(displayObject);
			const offset:Point = new Point();
			
			offset.x = (displayObject.scaleX > 0) ? bounds.left * displayObject.scaleX * -1 : bounds.right * displayObject.scaleX * -1
			offset.y = (displayObject.scaleY > 0) ? bounds.top * displayObject.scaleY * -1 : bounds.bottom * displayObject.scaleY * -1
			
			return offset;
		}
		
		/**
		 * Converts a rotation in the coordinate system of a display object
		 * to a global rotation relative to the stage.
		 *
		 * @param obj The display object
		 * @param rotation The rotation
		 *
		 * @return The rotation relative to the stage's coordinate system.
		 */
		public static function localToGlobalRotation(obj:DisplayObject, rotation:Number):Number
		{
			var rot:Number = rotation + obj.rotation;
			for (var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent)
			{
				rot += current.rotation;
			}
			return rot;
		}
		
		/**
		 * Converts a global rotation in the coordinate system of the stage
		 * to a local rotation in the coordinate system of a display object.
		 *
		 * @param obj The display object
		 * @param rotation The rotation
		 *
		 * @return The rotation relative to the display object's coordinate system.
		 */
		public static function globalToLocalRotation(obj:DisplayObject, rotation:Number):Number
		{
			var rot:Number = rotation - obj.rotation;
			for (var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent)
			{
				rot -= current.rotation;
			}
			return rot;
		}
		
		public static function setRotaionAroundCenter(object:DisplayObject, angle:Number):void
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