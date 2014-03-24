package
{
	import core.GlobalManager;
	import utilities.Debug;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import core.game_internal;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	import utilities.DelayTimeAction;
	
	public class Preloader extends Canvas
	{
		
		public static const INITIALIZE:String = 'инициализация';
		public static const CONNECTION:String = 'подключение';
		public static const LOAD:String = 'загрузка';
		public static const LOAD_DATA:String = 'загрузка данных';
		public static const ERROR:String = 'ошибка';
		public static const AUTHORIZATION:String = "авторизация";
		public static const AUTHORIZATION_SUCCESSFUL:String = "авторизация произошла успешно";
		public static const AUTHORIZATION_FAULT:String = "ошибка авторизации";
		public static const LOAD_HISTORY:String = "загрузка истории";
		
		
		[Embed(source="Skin.swf#preloader")]
		private static var _prelaoder:Class;
		private static var isVisible:Boolean;
		private static var _stage:Stage;
		private static var txt:Label = new Label();
		private static var image:Image = new Image();
		private static var labelList:Vector.<String> = new Vector.<String>();
		public static function get list():Vector.<String> { return labelList; }
		
		public function Preloader()
		{
			_stage = GlobalManager.stage;
			_stage.addEventListener(Event.RESIZE, onResize);
			verticalScrollPolicy = horizontalScrollPolicy = 'off';
			setStyle('backgroundColor', 0x636363);
			image.source = _prelaoder;
			image.verticalCenter = 0;
			image.horizontalCenter = 0;
			image.scaleX = image.scaleY = 3;
			image.filters = [new GlowFilter(0xFFFFFF, 1, 2,2)];
			addElement(image);
			addElement(txt);
			txt.verticalCenter = 55;
			txt.horizontalCenter = 0;
			txt.setStyle('color', 0xFFFFFF);
			txt.setStyle('fontSize', 16);
			txt.filters = [new GlowFilter(0xFFFFFF, 1, 2,2)];
			validate();
		}
		
		private function validate():void {
			width = _stage.stageWidth;
			height = _stage.stageHeight;
			graphics.clear();
			graphics.beginFill(0x636363);
			graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			opaqueBackground = 0x636363;
			cacheAsBitmap = true;
		}
		
		private function onResize(e:Event):void {
			validate();
			if (isVisible == false) return;
			validateNow();
		}
		
		
		private static var inst:Preloader;
		
		
		public static function show(label:String):void {
			
			if (labelList.indexOf(label) == -1) {
				labelList.push(label);
			}
			Preloader.txt.text = label;
			if (isVisible) return;
			
			FlexGlobals.topLevelApplication.preloader.addElement(instance);
			isVisible = true;
			instance.validateNow();
		}
		game_internal static function get waitList():Vector.<String> {
			return labelList;
		}
		public static function hide(label:String, hideDelay:uint = 500):void {
			var i:int = labelList.indexOf(label);
			if (i != -1) {
				labelList.splice(i, 1);
			}
			if (label == "all") {
				labelList.splice(0, labelList.length);
			}
			if (isVisible == false) return;
			if (labelList.length == 0) {
				new DelayTimeAction(removePreloader, hideDelay);
				isVisible = false;
			}
		}
		private static function removePreloader():void {
			if (FlexGlobals.topLevelApplication.preloader.contains(instance)) {
				FlexGlobals.topLevelApplication.preloader.removeElement(instance);
			}
		}
		public static function getInstance():Preloader{
			if(inst == null) inst = new Preloader();
			return inst as Preloader;
		}
		public static function get instance():Preloader{
			if(inst == null) inst = new Preloader();
			return inst as Preloader;
		}
	}
}