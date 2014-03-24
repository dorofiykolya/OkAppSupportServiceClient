package messages
{
	public class TicketsHistoryManager
	{
		private static var xml:XML = new XML("<root/>");
		private static var data:Object;
		
		public function TicketsHistoryManager()
		{
		}
		
		public static function Parse(value:Object):void
		{
			xml = new XML("<root/>");
			var list:Array = value as Array;
			if(list && list.length > 0)
			{
				var i:int;
				var current:Object;
				for(i = 0;i < list.length; i++)
				{
					current = list[i];
					
					var ticket:XML = <ticket label={current.title} time={current.createTime} type={current.type} state={current.state} favorite={current.favorite} />;
					
					xml.appendChild(ticket);
					
					var mesList:Array = current.messages as Array;
					if(mesList && mesList.length)
					{
						var j:int;
						for(j=0;j<mesList.length;j++)
						{
							var m:XML = <message label={mesList[j].from} text={mesList[j].message} type={mesList[j].type} time={mesList[j].time} />;
							ticket.appendChild(m);
						}
					}
				}
			}
			trace(xml);
		}
		
		public static function get Data():Object
		{
			return xml;
		}
			
	}
}