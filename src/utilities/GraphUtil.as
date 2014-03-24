/*The MIT License
 
Copyright (c) 2011 Dmitriy [focus] Yukhanov | http://blog.codestage.ru
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package ru.codestage.utils.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.system.Capabilities;

	/**
	 * Provides utility functions for dealing with <code>DisplayObject</code> and <code>BitmapData</code> instances
	 * @author focus | http://blog.codestage.ru
	 */
	public final class GraphUtil
	{
		// Self-explained constants)
		public static const ALIGN_BOTTOM: String = "alignBottom";
		public static const ALIGN_BOTTOM_LEFT: String = "alignBottomLeft";
		public static const ALIGN_BOTTOM_RIGHT: String = "alignBottomRight";
		public static const ALIGN_LEFT: String = "alignLeft";
		public static const ALIGN_MIDDLE: String = "alignMiddle";
		public static const ALIGN_RIGHT: String = "alignRight";
		public static const ALIGN_TOP: String = "alignTop";
		public static const ALIGN_TOP_LEFT: String = "alignTopLeft";
		public static const ALIGN_TOP_RIGHT: String = "alignTopRight";
		
		/**
		 * Fits a <code>DisplayObject</code> into a rectangular area with several options for scale
		 * and alignment. This method will return the <code>Matrix</code> required to duplicate the
		 * transformation and can optionally apply this matrix to the <code>DisplayObject</code>
		 *
		 * @param displayObject The <code>DisplayObject</code> that needs to be fitted into the <code>Rectangle</code>
		 * @param rectangle     A <code>Rectangle</code> object representing the space which the <code>DisplayObject</code> should fit into
		 * @param fillRect
		 * Whether the <code>DisplayObject</code> should fill the entire <code>Rectangle</code> or just fit within it.
		 * If true, the <code>DisplayObject</code> will be cropped if its aspect ratio differs to that of
		 * the target Rectangle
         *
		 * @param align
		 * The alignment of the <code>DisplayObject</code> within the target <code>Rectangle</code>.
         * Use a static constant from the <code>GraphUtil</code> class
		 *
		 * @param applyTransform
		 * Whether to apply the generated transformation matrix to the <code>DisplayObject</code>. By setting this
		 * to false you can leave the <code>DisplayObject</code> as it is but store the returned <code>Matrix</code> for to use
		 * either with a DisplayObject's transform property or with, for example, <code>DisplayObject</code>
		 *
		 * @return <code>Matrix</code> required to duplicate the transformation
		 */
		public static function fitIntoRect(displayObject: DisplayObject, rectangle: Rectangle, fillRect: Boolean = true, align: String = "alignMiddle", applyTransform: Boolean = true): Matrix
		{
            var matrix: Matrix = new Matrix();
			
			var wD: Number = displayObject.width / displayObject.scaleX;
			var hD: Number = displayObject.height / displayObject.scaleY;
			
			var wR: Number = rectangle.width;
			var hR: Number = rectangle.height;
			
			var sX: Number = wR / wD;
			var sY: Number = hR / hD;
			
			var rD: Number = wD / hD;
			var rR: Number = wR / hR;
			
			var sH: Number = fillRect ? sY : sX;
			var sV: Number = fillRect ? sX : sY;
			
			var s: Number = rD >= rR ? sH : sV;
			var w: Number = wD * s;
			var h: Number = hD * s;
			
			var tX: Number = 0.0;
			var tY: Number = 0.0;
			
			switch(align)
			{
				case ALIGN_LEFT:
				case ALIGN_TOP_LEFT:
				case ALIGN_BOTTOM_LEFT:
					tX = 0.0;
					break;
					
				case ALIGN_RIGHT:
				case ALIGN_TOP_RIGHT:
				case ALIGN_BOTTOM_RIGHT:
					tX = w - wR;
					break;
					
				default:
					tX = 0.5 * (w - wR);
			}
			
			switch(align)
			{
				case ALIGN_TOP:
				case ALIGN_TOP_LEFT:
				case ALIGN_TOP_RIGHT:
					tY = 0.0;
					break;
					
				case ALIGN_BOTTOM:
				case ALIGN_BOTTOM_LEFT:
				case ALIGN_BOTTOM_RIGHT:
					tY = h - hR;
					break;
					
				default:
					tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);
			
			if(applyTransform)
			{
				displayObject.transform.matrix = matrix;
			}
			
			return matrix;
		}
		
		/**
		 * Creates a thumbnail of a <code>BitmapData</code>. The thumbnail can be any size as
		 * the copied image will be scaled proportionally and cropped if necessary
		 * to fit into the thumbnail area. If the image needs to be cropped in order
		 * to fit the thumbnail area, the alignment of the crop can be specified
		 *
		 * @param image  The source image for which a thumbnail should be created. The source will not be modified
		 * @param width  The width of the thumbnail
		 * @param height The height of the thumbnail
		 * @param align
		 * If the thumbnail has a different aspect ratio to the source image, although
		 * the image will be scaled to fit along one axis it will be necessary to crop
		 * the image. Use this parameter to specify how the copied and scaled image should
		 * be aligned within the thumbnail boundaries.
         * Use a static constant from the <code>GraphUtil</code> class
         *
		 * @param smooth Whether to apply bitmap smoothing to the thumbnail
		 *
		 * @return Created bitmap with thumbnail
		 */
		public static function createThumb(image: BitmapData, width: int, height: int, align: String = "alignMiddle", smooth: Boolean = true): Bitmap
		{
			var source: Bitmap = new Bitmap(image);
			var thumbnail: BitmapData = new BitmapData(width, height, false, 0x0);
			
			thumbnail.draw(image, fitIntoRect(source, thumbnail.rect, true, align, false), null, null, null, smooth);
			source = null;
			
			return new Bitmap(thumbnail, PixelSnapping.AUTO, smooth);
		}
				
		/**
		 * This function works like <code>BitmapData</code>, except it will find the full
		 * bounds of any display object, even after its scrollRect has been set
		 *
		 * @param displayObject A display object that may have a <code>scrollRect</code> applied
		 *
		 * @return A rectangle describing the dimensions of the unmasked content
		 */
		public static function getFullBounds(displayObject:DisplayObject):Rectangle
		{
			var bounds:Rectangle;
			var transform:Transform;
			var toGlobalMatrix:Matrix;
			var currentMatrix:Matrix;
		
			transform = displayObject.transform;
			currentMatrix = transform.matrix;
			toGlobalMatrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;
			
			bounds = transform.pixelBounds.clone();
			
			transform.matrix = currentMatrix;
			return bounds;
		}
		
		/**
		 * Checks bitmapData for transparency
		 *
		 * @param bitmapData <code>BitmapData</code> instance to check for transparency
		 *
		 * @return True if bitmapData has transparency
		 */
		public static function isBitmapDataTransparent(bitmapData:BitmapData):Boolean
		{
			return	bitmapData.transparent && bitmapData.threshold( bitmapData, bitmapData.rect, new Point(), '!=', 0xFF000000, 0, 0xFF000000, true ) > 0;
		}
		
		/**
		 * Performs <code>BitmapData</code> slicing into 9 rectangles and returns <code>Shape</code> with them.
		 * Returned <code>Shape</code> will be vector bitmapData analog, available for scaling
		 *
		 * @param bd
		 * Source <code>BitmapData</code> instance, which will be sliced into 9 rectangles and "converted" to the <code>Shape</code>
		 *
		 * @param splitter
		 * This rectangle is a guides for the slicing
		 *
		 * @return <code>Shape</code> with 9 slices of the original <code>BitmapData</code>, available for scaling
		 */
		public static function bitmap9slice(bd:BitmapData, splitter:Rectangle):Shape
		{
			var shape:Shape = new Shape();
			var c:Array = [0, splitter.left, splitter.right, bd.width];
			var r:Array = [0, splitter.top, splitter.bottom, bd.height];
			
			var i:uint = 0;
			for (i; i < 9; ++i)
			{
				var dx:uint = i % 3;
				var dy:uint = i / 3;
				var x:Number = c[dx];
				var y:Number = c[dy];
				var w:Number = c[dx+1] - c[dx];
				var h:Number = r[dy + 1] - r[dy];
				
				shape.graphics.beginBitmapFill(bd);
				shape.graphics.drawRect(x, y, w, h);
				shape.graphics.endFill();
			}
			shape.scale9Grid = splitter;
			return shape;
		}
		
		/**
		 * Use this function to enable or disable any <code>DisplayObject</code> instance with predefined settings
		 *
		 * @param target
		 * <code>DisplayObject</code> instance to enable or disable
		 * 
		 * @param enable
		 * Enable or disable <code>DisplayObject</code>
		 *
		 * @param tweenSettings
		 * <code>Object</code> with links to the greensock classes and a duration value.
		 * This object should contain fields with links to the classes with the same name:
		 * tweenPlugin - link to the TweenPlugin class
		 * endArrayPlugin - link to the EndArrayPlugin class
		 * colorMatrixFilterPlugin - link to the ColorMatrixFilterPlugin class
		 * tween - link to the TweenLite or TweenMax class
		 * overwriteManager - link to the OverwriteManager class
		 * duration - tween's duration value
		 *
		 * @param disabledColor
		 * Color to tint the disabled <code>DisplayObject</code>
		 *
		 * @param touchChildren
		 * Apply disable state to the DisplayObject's children or not
		 *
		 * @return void
		 */
		public static function enableDisplayObject(target:DisplayObject, enable:Boolean = true, tweenSettings:Object = null, disabledColor:uint = 0x999999, touchChildren:Boolean = true):void
		{
			if (tweenSettings)
			{
				var tweenPlugin:Class = tweenSettings.tweenPlugin;
				var endArrayPlugin:Class = tweenSettings.endArrayPlugin;
				var colorMatrixFilterPlugin:Class = tweenSettings.colorMatrixFilterPlugin;
				var tween:Class = tweenSettings.tween;
				var overwriteManager:Class = tweenSettings.overwriteManager;
				var duration:Number = tweenSettings.duration
				
				(tweenPlugin as Class).activate([(endArrayPlugin as Class), colorMatrixFilterPlugin]);
				
				if (enable)
				{
					(tween as Class).to(target, duration, { overwrite:(overwriteManager as Class).AUTO, colorMatrixFilter:{}} );
				}
				else
				{
					(tween as Class).to(target, duration, { overwrite:(overwriteManager as Class).AUTO, colorMatrixFilter:{colorize:disabledColor}} );
				}
			}
			else
			{
				if (enable)
				{
					ColorUtil.setTint(target, 0, disabledColor);
				}
				else
				{
					ColorUtil.setTint(target, 50, disabledColor);
				}
			}
			
			if (target is InteractiveObject)
			{
				(target as InteractiveObject).mouseEnabled = enable;
			}
			
			if ((touchChildren) && (target is DisplayObjectContainer))
			{
				(target as DisplayObjectContainer).mouseChildren = enable;
			}
		}
		
		/**
		 * Converts millimeters to pixels
		 *
		 * @param mm
		 * Millimeters to convert
		 *
		 * @return mm, converted to pixels
		 */
		public static function mmToPixels(mm:Number):int
		{
		   return Math.round(Capabilities.screenDPI * (mm / 25.4));
		}
		
		/**
		 * Center one <code>DisplayObject</code> relative to another
		 *
		 * @param foreground
		 * <code>DisplayObject</code> to be centered
		 */
		public static function center(foreground:DisplayObject, background:DisplayObject):void
		{
			foreground.x = (background.width / 2) - (foreground.width / 2);
			foreground.y = (background.height / 2) + (foreground.height / 2);
		}

        /**
         * Extremely Fast Line Algorithm
         * Use it to draw a lines very fast
         *
         * @author Po-Han Lin (original version: http://www.edepot.com/algorithm.html)
         * @author Simo Santavirta (AS3 port: http://www.simppa.fi/blog/?p=521)
         * @author Jackson Dunstan (minor formatting)
         *
         * @param x X component of the start point
         * @param y Y component of the start point
         * @param x2 X component of the end point
         * @param y2 Y component of the end point
         * @param color <code>Color</code> of the line
         * @param bmd <code>Bitmap</code> to draw on
         */
        public static function efla(x:int, y:int, x2:int, y2:int, color:uint, bmd:BitmapData): void
        {
            var shortLen:int = y2-y;
            var longLen:int = x2-x;

            if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
            {
                shortLen ^= longLen;
                longLen ^= shortLen;
                shortLen ^= longLen;

                var yLonger:Boolean = true;
            }
            else
            {
                yLonger = false;
            }

            var inc:int = longLen < 0 ? -1 : 1;

            var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

            if (yLonger)
            {
                for (var i:int = 0; i != longLen; i += inc)
                {
                    bmd.setPixel(x + i*multDiff, y+i, color);
                }
            }
            else
            {
                for (i = 0; i != longLen; i += inc)
                {
                    bmd.setPixel(x+i, y+i*multDiff, color);
                }
            }
        }
	}
	
}