package net.protocol 
{
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Protocol 
	{
		private var _i:int = -1;
		private var queue:Vector.<ProtocolProperty> = new Vector.<ProtocolProperty>();
		private var _name:String;
		private var _type:Class;
		private var _id:int;
		
		public function Protocol(name:String, id:int, type:Class) 
		{
			_name = name;
			_type = type;
			_id = id;
		}
		
		public function reset():void {
			_i = -1;
		}
		
		public function add(type:int, property:String):void {
			var p:ProtocolProperty = new ProtocolProperty(type, property);
			queue.push(p);
		}
		
		public function get lenght():int {
			return queue.length;
		}
		
		public function getNext():int {
			if (queue.length == 0) {
				throw new RangeError('Queue Protocol Lenght == 0' + name);
			}
			_i++;
			return queue[_i].type;
		}
		
		public function get end():Boolean {
			return (_i >= queue.length - 1);
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get current():ProtocolProperty {
			if (queue.length == 0) {
				throw new RangeError('Queue Protocol Lenght == 0' + name);
			}
			return queue[_i];
		}
		
		public function get currentType():int {
			if (queue.length == 0) {
				throw new RangeError('Queue Protocol Lenght == 0' + name);
			}
			return queue[_i].type;
		}
		
		public function get currentProperty():String {
			if (queue.length == 0) {
				throw new RangeError('Queue Protocol Lenght == 0' + name);
			}
			return queue[_i].property;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get type():Class {
			return _type;
		}
		
		public function get position():int {
			return _i;
		}
		
		public function set position(value:int):void {
			if (queue.length < 0) {
				throw new RangeError('Queue Protocol ' + name);
			}
			_i = value;
		}
		
		public function toString():String {
			return '[Protocol, name = ' + _name +", type = " + _id + ", class = " + _type + "]";
		}
		
		public function copy():Protocol {
			return new Protocol(_name, _id, _type);
		}
		
	}

}