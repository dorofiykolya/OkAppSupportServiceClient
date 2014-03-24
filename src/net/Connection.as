package net
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	
	import core.GlobalManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.*;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;
	
	import net.log.NetLogData;
	
	import utilities.Debug;

	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Connection extends EventDispatcher 
	{
		private static var inst:Connection;
		private var socket:Socket;
		private var socketDomain:String;
		private var socketPort:int;
		private var callBacks:Array = [];
		private var socketData:String = "";
		private var tryReconnect:Boolean;
		private var safeRestartMode:Boolean;
		private var tempBuffer:ByteArray;
		
		public function registerCallBack(request:String, value:Function, type:Class = null):void {
			callBacks[request] = {handle:value, type:type};
		}
		public function uregisterCallBack(request:String):void {
			delete callBacks[request];
		}
		public function get socketHostEntry():String {
			return socketDomain + ":" + socketPort;
		}
		
		private function socketConstructor():void {
			if (socket && socket.connected) socket.close();
			try{
				socket = new Socket();
			}catch(e:Error){
				Debug.Trace(e.message, e.getStackTrace());
			}
			socket.addEventListener(Event.CLOSE, onSocketClose);
			socket.addEventListener(Event.CONNECT, onSocketConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketProgress);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurity);
			try
			{
				Security.loadPolicyFile("xmlsocket:"+socketDomain+":"+socketPort);
			} 
			catch(error:Error) 
			{
				Debug.Trace(error.message, error.getStackTrace());
			}
			
		}
		public function ping():void{
			var arr:Array = [];
			arr['ok'] = [];
			GlobalManager.timerManager.secondTimer.addEventListener(TimerEvent.TIMER, function():void{	if(socket.connected)send(arr);});
		}
		public function send(data:Object = null):void {
			//Debug.Trace(ObjectUtil.toString(data), new Error().getStackTrace()); 
			var sendString:String = '';
			try {
				sendString = com.adobe.serialization.json.JSON.encode(data);
			}catch (e:JSONParseError) {
				Debug.Trace(e.message, e.text, e.location);
			}catch (err:Error) {
				Debug.Trace(err.message);
			}
			NetLogData.writeSend(data); // TODO
			if (socket) {
				if (socket.connected){
					socket.writeUTFBytes(sendString+String.fromCharCode(0));
					socket.flush();
				}else {
					Debug.Trace("ERROR socket connected false", "SOCKET CONNECTED FALSE");
				}
			}else{
				Debug.Trace("ERROR Socket == null", "SOCKET IS NULL");
			}	
		}
		public function sendAsString(str:String = ''):void {
			if(socket){
				socket.writeUTFBytes(str+String.fromCharCode(0));
				socket.flush();
			}else{
				Debug.Trace("ERROR Socket == null", "SOCKET IS NULL");
			}
		}
		public function reconnect():void {
			if (socket && socket.connected) socket.close();
			if (socket) {
				byte.clear();
				buffer.clear();
				readByteLength = true;
				totalByte = 0;
				tempByte.clear();
				try {
					socket.connect(socketDomain, socketPort);
				}catch (e:Error) {
					Debug.Exception(e);
				}
			}else {
				Debug.Trace("ERROR Socket == null", "SOCKET IS NULL");
			}
			/**
			 * SHOW ERROR
			 */
		}
		public function connect(domain:String, port:int):void {
			socketDomain = domain;
			socketPort = port;
			socketConstructor();
			if (socket) {
					byte.clear();
					buffer.clear();
					readByteLength = true;
					totalByte = 0;
					tempByte.clear();
				Security.loadPolicyFile("xmlsocket:" + socketDomain + ":" + socketPort);
				try {
					socket.connect(socketDomain, socketPort);
				}catch (e:Error) {
					Debug.Exception(e);
				}
			}else {
				Debug.Trace("ERROR Socket == null", "SOCKET IS NULL");
			}
			
		}
		
		private function doHandle(str:String):void {
			if (str == "") return;
			var ans:Object;
			try {
				ans = com.adobe.serialization.json.JSON.decode(str, false);
			}catch (jsError:JSONParseError) {
				Debug.Trace("JSON PARSER EXCEPTION: ", jsError.message +"\n" + jsError.text, jsError.location);
				Controller.SetValue("screenShotLink", null);
				Controller.SetValue("screenBytes", tempBuffer);
				Controller.Invoke("screenBytes", tempBuffer);
				return;
			}
			NetLogData.writeGet(ans);
			var count:int = 0;
			for (var str:String in ans)
			{
				count++;
				try {
					var status:Object = ans[str].status;
					if (status && String(status) != "1") {
						Alert.show(ans[str].status);
//						Debug.Trace('не обнаружен статус в пакете', ans);
//						Alert.show("не обнаружен статус в пакете", "ошибка");
						if (ErrorStatusListener.callBack[str]) {
							(ErrorStatusListener.callBack[str] as Function)(String(status));
						}
						continue;
					}
				}catch (e:Error) {
					Debug.Trace(e);
					continue;
				}
				
				if(callBacks[str] && callBacks[str].handle)
				{
					if (callBacks[str].type != null) {
						(callBacks[str].handle as Function)(parse(ans[str], callBacks[str].type))
					}else {
						(callBacks[str].handle as Function)(ans[str]);
					}
				}						
			}
		}
		private var byte:ByteArray = new ByteArray();
		private var buffer:ByteArray = new ByteArray();
		private var readByteLength:Boolean = true;
		private var totalByte:uint = 0;
		private var tempByte:ByteArray = new ByteArray();
		private var handleOnConnectParams:Array;
		private function onSocketProgress(e:ProgressEvent):void {
			byte.clear();
			byte.position = 0;
			byte.endian = Endian.LITTLE_ENDIAN;
			if (tempByte.length > 0) {
				tempByte.endian = Endian.LITTLE_ENDIAN;
				byte.writeBytes(tempByte, 0, tempByte.length);
				tempByte.clear();
			}
			socket.readBytes(byte, byte.position, socket.bytesAvailable);
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.position = 0;
				
			while (byte.bytesAvailable) {
				if (readByteLength) {
					if (byte.bytesAvailable < 4) {
						tempByte.writeBytes(byte, byte.position, byte.bytesAvailable);
						return;
					}
					try {
						var _1:int = byte.readUnsignedByte();
						var _2:int = byte.readUnsignedByte();
						var _3:int = byte.readUnsignedByte();
						var _4:int = byte.readUnsignedByte();
						
						totalByte = _1 * 256 * 256 * 256 + _2 * 256 * 256 + _3 * 256 + _4;
					}catch (e:Error) {
						Debug.Trace(Debug.UNPACK, e);
						return;
					}
					readByteLength = false;
				}
				if (byte.bytesAvailable == 0) continue;
				var currentByte:int = byte.readByte();
				buffer.writeByte(currentByte);
				totalByte--;
				if (totalByte == 0) {
					buffer.position = 0;
					try {
						buffer.uncompress();
					}catch (e:Error) {
						Debug.Trace(e);
						buffer.clear();
						readByteLength = true;
						continue;
					}
					buffer.position = 0;
					tempBuffer = buffer;
					doHandle(buffer.readMultiByte(buffer.bytesAvailable, 'utf-8'));
					//doHandle(buffer.readUTFBytes(buffer.bytesAvailable));
					buffer.position = 0;
					buffer = new ByteArray();
					readByteLength = true;
				}
			}
		}
		
		private function onSocketConnect(e:Event):void {
			Debug.Trace("SOCKET CONNECT");
			dispatchEvent(e);
		}
		private function onSocketIOError(e:IOErrorEvent):void {
			if (safeRestartMode) {
				reconnect();
				safeRestartMode = false;
				return;
			}
		}
		private function onSocketClose(e:Event):void {
			if (safeRestartMode) {
				reconnect();
				safeRestartMode = false;
				return;
			}
			Debug.Trace("SOCKET CLOSE");
			dispatchEvent(e);
		}
		private function onSocketSecurity(e:SecurityErrorEvent):void {
			Debug.Trace(e.text);
			dispatchEvent(e);
		}
		public function onError(err:String, str:String, ans:Object):void{
			Debug.Trace("ERROR: " + err);
			var callBack:Object = ErrorListener.callBack;
			if (callBack[str]) {
				(callBack[str] as Function)(err);
			}else {
				if (err.length > 0 && err.charAt(0) == "#") {
					Debug.Trace(err);
				}else {
					Debug.Trace(err);
				}
			}
		}	
		public function getSocket():Socket {
			return socket as Socket;
		}
		
		public static function setSafeRestart():void {
			instance.safeRestartMode = true;
		}
		
		public static function send(data:Object=null):void {
			instance.send(data);
		}
		public static function getInstance():Connection {
			if (inst == null) inst = new Connection();
			return inst as Connection;
		}
		public static function get instance():Connection {
			if (inst == null) inst = new Connection();
			return inst as Connection;
		}
		
		public static function parse(o:*, type:Class, arrayType:Class = null):* {
			if (o == undefined) return o;
			if (o == null) return o;
			
			var cls:String = getQualifiedClassName(type);
			
			var arr:Array;
			var i:int;
			if (cls.indexOf("__AS3__.vec::Vector.") == 0) {
				var left:int = cls.indexOf("<");
				var right:int = cls.lastIndexOf(">");
				if (left >= right) {
					throw new Error("Connection, parse");
				}
				arrayType = getDefinitionByName(cls.substring(left + 1, right)) as Class;
				arr = o as Array;
				var resultVector:Object = new type();
				for (i = 0; i < arr.length; i++) 
				{
					resultVector.push(parse(arr[i], arrayType));
				}
				return resultVector;
			}
			
			if (arrayType != null && cls == "Array") {
				var resultArray:Array = [];
				arr = o as Array;
				for (i = 0; i < arr.length; i++) 
				{
					resultArray.push(parse(arr[i], arrayType));
				}
				return resultArray;
			}
			
			switch(cls) {
				case "String":
				case "Number":
				case "Array":
				case "Object":
				case "int":
				case "uint":
				case "Boolean":
					return o;
			}
			
			if (cls == "Dictionary") {
				var d:Dictionary = new Dictionary();
				for (var s:String in o) {
					d[s] = o[s];
				}
				return d;
			}
			
			var x:XML = describeType(type);
			var out:Object = new type();
			for each(var f:XML in x.factory.variable) {
				var fieldType:Class = getDefinitionByName(f.@type.toString()) as Class;
				var fieldTypeName:String = getQualifiedClassName(fieldType);
				var fieldName:String = f.@name.toString();
				if (fieldTypeName == "Array") {
					try {
						if (type["__meta"] != undefined) {
							var meta:Object = type["__meta"];
							var metaClass:* = meta[fieldName];
							if (metaClass != null && metaClass is Class) {
								out[fieldName] = parse(o[fieldName], fieldType, metaClass as Class);
								continue;
							}
						}
					}catch (e:Error) {
						Debug.Trace(e.message);
					}
				}
				out[fieldName] = parse(o[fieldName], fieldType);
			}
			return out;
		}
		
	}

}