package utilities
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class SectorRadius
	{
		public static function createCircle(radius:int, cutSector:int, lineThickness:Number = 0, lineColor:uint = 0, lineAlpha:Number = 1, fillColor:uint = 0, fillAlpha:Number = 1, curSprite:Sprite = null):Sprite
		{
			var sprite:Sprite;
			if(curSprite)
			{
				sprite = curSprite;
				sprite.graphics.clear();
			}
			else sprite = new Sprite();
			if(lineThickness > 0){
				sprite.graphics.lineStyle(lineThickness, lineColor, lineAlpha); 
			}
			sprite.graphics.beginFill(fillColor, fillAlpha);
			
			var i:int = cutSector * 3.6;
			for(; i < 360; i++)
			{
				sprite.graphics.lineTo(radius * Math.cos((Math.PI / 180) * i), radius * Math.sin((Math.PI / 180) * i));
			}
			sprite.graphics.lineTo(0,0);
			sprite.rotation = -90;
			return sprite;
		}
		//public static function createCircleGraphics(drawInObject:Object = null, radius:int, cutSector:int, lineThickness:Number = 0, lineColor:uint = 0, lineAlpha:Number = 1, fillColor:uint = 0, fillAlpha:Number = 1):void {
			//var g:Graphics = drawInObject.graphics;
			//if (g == null) {
				//throw new Error("drawInObject don't have property graphics typeof Graphics");
				//return;
			//}
			//g.lineStyle(lineThickness, lineColor, lineAlpha);
			//g.beginFill(fillColor, fillAlpha);
			//
			//var i:int = cutSector * 3.6;
			//for(; i < 360; i++)
			//{
				//g.lineTo(radius * Math.cos((Math.PI / 180) * i), radius * Math.sin((Math.PI / 180) * i));
			//}
			//g.lineTo(0,0);
		//}
	}
}