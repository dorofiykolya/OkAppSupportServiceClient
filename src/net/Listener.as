package net
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import messages.ModerTicketsList;
	import messages.ModerMessagesList;
	import messages.Owner;
	
	import System.Type.Type;
	
	import messages.Access;
	import messages.AccessManager;
	import messages.Message;
	import messages.MessageList;
	import messages.Moder;
	import messages.ModerList;
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
			
			c.registerCallBack("getModerators", onGetModerators);
			
			c.registerCallBack("responseTikets", onResponseTickets);
			
			c.registerCallBack("moderatorMessages", onModeratorMessages);
			
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
		
		private function onGetModerators(data:Object = null):void 
		{
			Debug.Trace(data.moderators, Debug.UNPACK);
			
			var moders:Vector.<Moder> = Connection.parse(data.moderators, Class(Vector.<Moder>)) as Vector.<Moder>;
			if (moders.length == 0) return;
			for each (var m:Moder in moders) 
			{
				ModerList.Add(m, true);
			}
			Controller.SetValue("moders", moders);
			Controller.Invoke("moders", moders);
		}
		
		private function onResponseTickets(data:Object = null):void 
		{
			Debug.Trace(data.messages, Debug.UNPACK);
			
			var mes:Vector.<Message> = Connection.parse(data.messages, Class(Vector.<Message>)) as Vector.<Message>;
			ModerTicketsList.AddList(mes);
			
			/*var mes:Vector.<Message> = new Vector.<Message>();
			
			var t1:Message = new Message();
			t1.id = 111;
			t1.title = 'first message';
			t1.createTime = 1446595100;
			t1.lastUpdate = 1446595101;
			t1.type = 'error';
			t1.state = 'scheduled';
			
			var t2:Message = new Message();
			t2.id = 222;
			t2.title = 'second message';
			t2.createTime = 1446595110;
			t2.lastUpdate = 1446595111;
			t2.type = 'proposal';
			t2.state = 'answered';
			
			var t3:Message = new Message();
			t3.id = 333;
			t3.title = 'third message';
			t3.createTime = 1446595120;
			t3.lastUpdate = 1446595121;
			t3.type = 'partnership';
			t3.state = 'scheduled';
			
			var t4:Message = new Message();
			t4.id = 444;
			t4.title = 'forth message';
			t4.createTime = 1446595150;
			t4.lastUpdate = 1446595151;
			t4.type = 'proposal';
			t4.state = 'answered';
			
			var t5:Message = new Message();
			t5.id = 555;
			t5.title = 'fifth message';
			t5.createTime = 1446595200;
			t5.lastUpdate = 1446595201;
			t5.type = 'thanks';
			t5.state = 'closed';
			
			mes.push(t1);
			mes.push(t2);
			mes.push(t3);
			mes.push(t4);
			mes.push(t5);
			
			ModerTicketsList.AddList(mes);*/
		}
		
		private function onModeratorMessages(data:Object = null):void 
		{
			trace('Listener -> onModeratorMessages');
			Debug.Trace(data.messages, Debug.UNPACK);
			
			var mes:Vector.<Word> = Connection.parse(data.messages, Class(Vector.<Word>)) as Vector.<Word>;
			ModerMessagesList.AddList(mes);
			
			/*var mes:Vector.<Word> = new Vector.<Word>();

			var m1:Word = new Word();
			m1.id = 112;
			m1.message = 'first message 1';
			m1.time = 1446595100;
			m1.from = 'Vasya';
			m1.type = 'error';
			
			var m2:Word = new Word();
			m2.id = 223;
			m2.message = 'second message 2';
			m2.time = 1446595110;
			m2.from = 'Petya';
			m2.type = 'proposal';
			
			var m3:Word = new Word();
			m3.id = 334;
			m3.message = 'third message 3';
			m3.time = 1446595120;
			m3.from = 'Kolya';
			m3.type = 'partnership';
			
			var m4:Word = new Word();
			m4.id = 445;
			m4.message = 'forth message 4';
			m4.time = 1446595150;
			m4.from = 'Volodya';
			m4.type = 'proposal';
			
			var m5:Word = new Word();
			m5.id = 556;
			m5.message = 'fifth message 5';
			m5.time = 1446595200;
			m5.from = 'Ivan';
			m5.type = 'thanks';
			
			mes.push(m1);
			mes.push(m2);
			mes.push(m3);
			mes.push(m4);
			mes.push(m5);
			
			ModerMessagesList.AddList(mes);*/
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
			
			Connection.send( {getModerators:{} } );
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
