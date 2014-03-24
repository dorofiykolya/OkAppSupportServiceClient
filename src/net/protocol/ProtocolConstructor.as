package net.protocol 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import utilities.Compression;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolConstructor
	{
		private var byte:ByteArray;
		private var protocol:Protocol;
		public function ProtocolConstructor(name:String, id:int, object:Object) 
		{
			ProtocolEnumerable.instance;
			
			protocol = ProtocolManager.getProtocolById(id);
			if (protocol == null) {
				throw new Error('protocol == null');
			}
			
			if ((protocol.type && object is protocol.type) == false) {
				trace('Object Class Not Found');
			}
			byte = new ByteArray();
			byte.writeByte(id);
			for (var i:int = 0; i < protocol.lenght; i++) 
			{
				var currentType:int = protocol.getNext();
				if (object.hasOwnProperty(protocol.currentProperty) == false) {
					throw new Error('currentProperty is not exist in object');
				}
				switch(currentType) {
					case ProtocolType.UINT:
						byte.writeUnsignedInt(object[protocol.currentProperty]);
						break;
					case ProtocolType.INT:
						byte.writeInt(object[protocol.currentProperty]);
						break;
					case ProtocolType.SHORT:
						byte.writeShort(object[protocol.currentProperty]);
						break;
					case ProtocolType.USHORT:
						byte.writeShort(object[protocol.currentProperty]);
						break;
					case ProtocolType.BYTE:
						byte.writeByte(object[protocol.currentProperty]);
						break;
					case ProtocolType.UBYTE:
						byte.writeByte(object[protocol.currentProperty]);
						break;
					case ProtocolType.DOUBLE:
						byte.writeDouble(object[protocol.currentProperty]);
						break;
					case ProtocolType.FLOAT:
						byte.writeFloat(object[protocol.currentProperty]);
						break;
					case ProtocolType.BOOLEAN:
						byte.writeBoolean(object[protocol.currentProperty]);
						break;
					case ProtocolType.ANSI: 
						var str:String = Compression.decompress(String(object[protocol.currentProperty]));
						var strLenght:int = str.length;
						byte.writeInt(strLenght);
						byte.writeMultiByte(str, 'us-ascii');
						break;
					case ProtocolType.UTF:
						var strUtf:String = Compression.decompress(String(object[protocol.currentProperty]));
						var strUtfLenght:int = strUtf.length;
						byte.writeInt(strUtfLenght);
						byte.writeMultiByte(strUtf, 'utf-8');
						break;
				}
			}
			byte.position = 0;
		}
		
		public function get byteArray():ByteArray {
			return byte;
		}
	}

}