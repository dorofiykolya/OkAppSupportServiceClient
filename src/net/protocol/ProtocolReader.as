package net.protocol 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import utilities.Compression;
	/**
	 * ...
	 * @author dorofiy
	 */
	public class ProtocolReader 
	{
		
		private static var readType:Boolean = true;
		private static var currentId:int;
		private static var currentProtocol:Protocol;
		private static var requiredBytes:int;
		private static var currentClass:Object;
		private static var requiredText:Boolean;
		private static var currentProperty:String;
		private static var readText:Boolean;
		private static var readNext:Boolean = true;
		private static var currentProtocolType:int;
		private static var buffer:ByteArray = new ByteArray();
		
		public static function read(byte:ByteArray):void {
			ProtocolEnumerable.instance;
			
			byte.position = 0;
			
			var tempByte:ByteArray = new ByteArray();
			buffer.position = 0;
			tempByte.writeBytes(buffer, 0, buffer.length);
			tempByte.writeBytes(byte, 0, byte.length);
			tempByte.position = 0;
			
			
			while (tempByte.bytesAvailable) {
				if (readType) {
					currentId = tempByte.readUnsignedByte();
					currentProtocol = ProtocolManager.getProtocolById(currentId);
					if (currentProtocol.lenght > 0) {
						currentProtocol.reset();
						currentClass = { };
						readType = false;
					}
					continue;
				}
				if (currentProtocol) {
					if (readNext) {
						var type:int = currentProtocol.getNext();
						currentProtocolType = type;
						currentProperty = currentProtocol.currentProperty;
						readNext = false;
						switch(type) {
							case ProtocolType.UINT:
								requiredText = false;
								requiredBytes = 4;
								break;
							case ProtocolType.INT:
								requiredText = false;
								requiredBytes = 4;
								break;
							case ProtocolType.SHORT:
								requiredText = false;
								requiredBytes = 2;
								break;
							case ProtocolType.USHORT:
								requiredText = false;
								requiredBytes = 2;
								break;
							case ProtocolType.BYTE:
								requiredText = false;
								requiredBytes = 1;
								break;
							case ProtocolType.UBYTE:
								requiredText = false;
								requiredBytes = 1;
								break;
							case ProtocolType.DOUBLE:
								requiredText = false;
								requiredBytes = 8;
								break;
							case ProtocolType.FLOAT:
								requiredText = false;
								requiredBytes = 4;
								break;
							case ProtocolType.BOOLEAN:
								requiredText = false;
								requiredBytes = 4;
								break;
							case ProtocolType.ANSI:
								requiredBytes = 4;
								requiredText = true;
								break;
							case ProtocolType.UTF:
								requiredBytes = 4;
								requiredText = true;
						}
					}
					if (tempByte.bytesAvailable < requiredBytes) {
						buffer.writeBytes(tempByte, tempByte.position, tempByte.bytesAvailable);
						continue;
					}
					if (requiredText) {
						requiredBytes = tempByte.readUnsignedInt();
						readText = true;
						requiredText = false;
						continue;
					}
					if (readText) {
						if (currentProtocolType == ProtocolType.UTF) {
							currentClass[currentProperty] = Compression.decompress(tempByte.readMultiByte(requiredBytes, 'utf-8'));
						}else {
							currentClass[currentProperty] = Compression.decompress(tempByte.readMultiByte(requiredBytes, 'us-ascii'));
						}
						readText = false;
						readNext = true;
						if (currentProtocol.end) {
							ProtocolManager.Run(currentProtocol.id, currentClass);
							readType = true;
						}
						continue;
					}
					switch(currentProtocolType) {
							case ProtocolType.UINT:
								currentClass[currentProperty] = tempByte.readUnsignedInt();
								break;
							case ProtocolType.INT:
								currentClass[currentProperty] = tempByte.readInt();
								break;
							case ProtocolType.SHORT:
								currentClass[currentProperty] = tempByte.readShort();
								break;
							case ProtocolType.USHORT:
								currentClass[currentProperty] = tempByte.readUnsignedShort();
								break;
							case ProtocolType.BYTE:
								currentClass[currentProperty] = tempByte.readByte();
								break;
							case ProtocolType.UBYTE:
								currentClass[currentProperty] = tempByte.readUnsignedByte();
								break;
							case ProtocolType.DOUBLE:
								currentClass[currentProperty] = tempByte.readDouble();
								break;
							case ProtocolType.FLOAT:
								currentClass[currentProperty] = tempByte.readFloat();
								break;
							case ProtocolType.BOOLEAN:
								currentClass[currentProperty] = tempByte.readBoolean();
								break;
					}
					readNext = true;
					if (currentProtocol.end) {
						ProtocolManager.Run(currentProtocol.id, currentClass);
						readType = true;
					}
				}
			}
		}
	}
}