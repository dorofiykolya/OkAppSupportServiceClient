package messages
{
	import System.Collections.List;
	
	import access.AccessGame;
	
	import flash.globalization.CurrencyFormatter;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import net.Connection;

	public class AccessManager
	{
		private static var dictionary:Dictionary = new Dictionary();
		
		private static var root:XML = new XML("<root/>");
		
		public function AccessManager()
		{
			
		}
		
		public static function get Collection():XML
		{
			return root;
		}
		
		public static function Parse(list:Vector.<Access>):void
		{
			root = new XML("<root/>");
			var len:int = list.length;
			var i:int = 0;
			var current:Access;
			var find:Boolean;
			for(i = 0; i < len; i++)
			{
				current = list[i];
				find = false;
				for each (var x:XML in root.children()) 
				{
					if(x.@id == current.gameId)
					{
						pushSocial(x, current);
						find = true;
					}
				}
				if(find == false)
				{
					var child:XML = 
					<game id={current.gameId} label={Game.game(current.gameId)}>
						<social id={current.socialId} label={Social.getNameById(current.socialId)} >
							<language id={current.language} label={current.language} hide={current.hide} />
						</social>
					</game>;
					root.appendChild(child);
				}
			}
		}
		
		private static function pushSocial(root:XML, current:Access):void
		{
			var find:Boolean;
			for each(var x:XML in root.children())
			{
				find = false;
				if(x.@id == current.socialId)
				{
					pushLanguage(x, current);
					find = true;
				}
			}
			if(find == false)
			{
				var child:XML = 
					<social id={current.socialId} label={Social.getNameById(current.socialId)} >
						<language id={current.language} label={current.language} hide={current.hide} />
					</social>;
				root.appendChild(child);
			}
		}
		
		private static function pushLanguage(root:XML, current:Access):void
		{
			var find:Boolean;
			for each(var x:XML in root.children())
			{
				find = false;
				if(x.@id == current.language)
				{
					find = true;
				}
			}
			if(find == false)
			{
				var child:XML = <language id={current.language} label={current.language} hide={current.hide} />;
				root.appendChild(child);
			}
		}
		
		public static function Save():void
		{
			var list:Array = [];
			var a:Object;
			for each(var g:XML in root.children())
			{
				for each(var s:XML in g.children())
				{
					for each(var l:XML in s.children())
					{
						a = {};
						a.gameId = int(g.@id);
						a.socialId = int(s.@id);
						a.language = String(l.@id);
						a.hide = l.@hide == "true";
						list[list.length] = a;
					}
				}
			}
			Connection.send({access:{access:list}});
		}
	}
}