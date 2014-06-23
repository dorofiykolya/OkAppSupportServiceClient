package messages
{
	import access.AccessGame;
	import access.AccessLanguage;
	import access.AccessSocial;
	import flash.utils.Dictionary;
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
		
		private static function parse(list:Vector.<Access>):void
		{
			var game:AccessGame;
			for each (var current:Access in list) 
			{
				game = dictionary[current.gameId];
				if (game == null)
				{
					game = new AccessGame(current);
					dictionary[current.gameId] = game;
				}
				else
				{
					game.setAccess(current);
				}
			}
		}
		
		private static function createGame():void
		{
			root = <root/>;
			
			for each (var current:AccessGame in dictionary) 
			{
				var label:String = current.label + "\t\t\t\t(" + current.count + ")";
				var child:XML = <game id={current.gameId} label={label} />
				root.appendChild(child);
				
				createSocial(current, child)
			}
		}
		
		private static function createSocial(item:AccessGame, root:XML):void
		{
			for each (var current:AccessSocial in item.socialId) 
			{
				var label:String = current.label + "\t\t\t\t(" + current.count + ")";
				var child:XML = <social id={current.socialId} label={label} />
				root.appendChild(child);
				
				createLanguage(current, child);
			}
		}
		
		private static function createLanguage(item:AccessSocial, root:XML):void
		{
			for each (var current:AccessLanguage in item.language) 
			{
				var label:String = current.language + "\t\t\t\t(" + current.count + ")";
				var child:XML = <language id={current.language} label={label} hide={current.hide} />;
				
				root.appendChild(child);	
			}
		}
		
		public static function Parse(list:Vector.<Access>):void
		{
			parse(list);
			createGame();
			
			//root = new XML("<root/>");
			//var len:int = list.length;
			//var i:int = 0;
			//var current:Access;
			//var find:Boolean;
			//for(i = 0; i < len; i++)
			//{
				//current = list[i];
				//find = false;
				//for each (var x:XML in root.children()) 
				//{
					//if(x.@id == current.gameId)
					//{
						//pushSocial(x, current);
						//find = true;
					//}
				//}
				//if(find == false)
				//{
					//var child:XML = 
					//<game id={current.gameId} label={Game.game(current.gameId)}>
						//<social id={current.socialId} label={Social.getNameById(current.socialId)} >
							//<language id={current.language} label={current.language} hide={current.hide} />
						//</social>
					//</game>;
					//root.appendChild(child);
				//}
			//}
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
				var lang:String = current.language + "\t\t\t(" + current.count + ")";
				var child:XML = <language id={current.language} label={lang} hide={current.hide} />;
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