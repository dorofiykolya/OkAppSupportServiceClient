package net
{
	import System.Type.Type;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import messages.Access;
	import messages.AccessManager;
	import messages.Message;
	import messages.MessageList;
	import messages.TicketsHistoryManager;
	import messages.Word;
	
	import utilities.Debug;
	
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Listener extends EventDispatcher
	{
		
		private var c:Connection;
		
		public function Listener()
		{
			c = Connection.getInstance();
			
			c.registerCallBack("messageCount", onMessageCount);
			
			c.registerCallBack("messageList", onMessageList);
			
			c.registerCallBack("message", onMessage, Message);
			
			c.registerCallBack("messages", onMessages);
			
			c.registerCallBack("setFavorite", onSetFavorite);
			
			c.registerCallBack("screenShots", onScreenShots);
			
			c.registerCallBack("messageAt", onMessageAt);
			
			c.registerCallBack("deleteMessage", onDeleteMessage);
			
			c.registerCallBack("findMessage", onfindMessage, Message);
			
			c.registerCallBack("access", onAccess);
			
			c.registerCallBack("getUserMessages", onGetUserMessages);
		}
		
		private function onGetUserMessages(data:Object = null):void
		{
			if(data == null)
			{
				return;
			}
			TicketsHistoryManager.Parse(data.tickets);
			TicketsHistory.Show();
//			Preloader.hide(Preloader.LOAD_HISTORY);
		}
		
		private function onAccess(data:Object):void
		{
			var list:Array = data.access as Array;
			if(list)
			{
				AccessManager.Parse( Type.Parse(list, Class(Vector.<Access>)) as  Vector.<Access>);
			}
		}
		
		private function onfindMessage(data:Message):void 
		{
			TicketGroup.answeredGroup.UnselectCurrent(); 
			TicketGroup.closedGroup.UnselectCurrent();
			TicketGroup.favoriteGroup.UnselectCurrent();
			TicketGroup.scheduledGroup.UnselectCurrent();
			
			if (TicketGroup.answeredGroup.GetByMessageId(data.id)) {
				TicketGroup.answeredGroup.GetByMessageId(data.id).selected = true;
			}
			if (TicketGroup.closedGroup.GetByMessageId(data.id)) {
				TicketGroup.closedGroup.GetByMessageId(data.id).selected = true;
			}
			if (TicketGroup.favoriteGroup.GetByMessageId(data.id)) {
				TicketGroup.favoriteGroup.GetByMessageId(data.id).selected = true;
			}
			if (TicketGroup.scheduledGroup.GetByMessageId(data.id)) {
				TicketGroup.scheduledGroup.GetByMessageId(data.id).selected = true;
			}
			
			Controller.SetValue("message", data);
			Controller.Invoke("message", data);
			Connection.send( { getMessages: { id: data.id }} );
		}
		
		private function onDeleteMessage(data:Object):void 
		{
			MessageList.RemoveById(data.id);
		}
		
		private function onMessageAt(data:Object):void 
		{
			var mes:Vector.<Message> = Connection.parse(data.messageAt, Class(Vector.<Message>));
			if (mes.length == 0) return;
			if (mes[0] as Message) {
				MessageList.RemoveStateMessage(mes[0].state);
			}
			for each (var m:Message in mes) 
			{
				MessageList.Add(m, true);
			}
		}
		
		private function onScreenShots(data:Object):void 
		{
			Controller.SetValue("screenBytes", null);
			Controller.SetValue("screenShotLink", data.screenShot);
			Controller.Invoke("screenShotLink", data.screenShot);
		}
		
		private function onSetFavorite(data:Object):void 
		{
			MessageList.Favorite(data.id, data.type); 
		}
		
		private function onMessages(data:Object):void 
		{
			var screen:Vector.<int> = Connection.parse(data.screenShots, Class(Vector.<int>)) as Vector.<int>;
			var word:Vector.<Word> = Connection.parse(data.messages, Class(Vector.<Word>)) as Vector.<Word>;
			Controller.SetValue("messages", word);
			Controller.Invoke("messages", word);
			
			Controller.SetValue("screen", screen);
			Controller.Invoke("screen", screen);
		}
		
		private function onMessage(m:Message):void 
		{
			MessageList.Update(m);
		}
		
		private function onMessageList(data:Object = null):void
		{
			Preloader.show(Preloader.INITIALIZE);
			Preloader.hide(Preloader.AUTHORIZATION);
			
			MessageList.Reset();
			
			MessageList.countScheduled = int(data.countScheduled);
			MessageList.countAnswered = int(data.countAnswered);
			MessageList.countClosed = int(data.countClosed);
			MessageList.countFavorite = int(data.countFavorite);
			
			var mes:Vector.<Message> = Connection.parse(data.messageList, Class(Vector.<Message>)) as Vector.<Message>;
			for each (var m:Message in mes) 
			{
				MessageList.Add(m);
			}
			MessageList.Update();
			
			Preloader.hide(Preloader.INITIALIZE, 1500);
		}
		
		private function onMessageCount(data:Object = null):void
		{
			MessageList.messageCount = int(data.count);
			Debug.Trace(data.count);
		}		
		
		private static var inst:Listener;
		
		public static function getInstance():Listener
		{
			if (inst == null)
				inst = new Listener();
			return inst as Listener;
		}
		
		public static function get instance():Listener
		{
			if (inst == null)
				inst = new Listener();
			return inst as Listener;
		}
	
	}

}
