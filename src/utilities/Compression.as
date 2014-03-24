package utilities
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Compression
	{
		public static function compress(source:String):String
		{
			var i:int;
			var size:int;
			
			var xstr:String;
			
			var chars:int = 256;
			
			var dict:Dictionary = new Dictionary();
			
			for (i = 0; i < chars; i++)
			{
				dict[String(i)] = i;
			}
			
			var current:String;
			
			var result:String = "";
			
			var splitted:Array = source.split("");
			
			var buffer:Vector.<Number> = new Vector.<Number>();
			
			size = splitted.length;
			
			for (i = 0; i <= size; i++)
			{
				current = new String(splitted[i]);
				xstr = (buffer.length == 0) ? String(current.charCodeAt(0)) : (buffer.join("-") + "-" + String(current.charCodeAt(0)));
				
				if (dict[xstr] !== undefined)
				{
					buffer.push(current.charCodeAt(0));
				}
				else
				{
					result += String.fromCharCode(dict[buffer.join("-")]);
					
					dict[xstr] = chars;
					
					chars++;
					
					buffer = new Vector.<Number>();
					buffer.push(current.charCodeAt(0));
				}
			}
			return result;
		}
		
		public static function decompress(source:String):String
		{
			var i:int;
			var chars:int = 256;
			var dict:Array = [];
			
			for (i = 0; i < chars; i++)
			{
				dict[i] = String.fromCharCode(i);
			}
			var splitted:Array = source.split("");
			var size:int = splitted.length;
			var buffer:String = "";
			var chain:String = "";
			var result:String = "";
			var current:String;
			var code:Number;
			for (i = 0; i < size; i++)
			{
				code = source.charCodeAt(i);
				current = dict[code];
				if (buffer == "")
				{
					buffer = current;
					result += current;
				}
				else
				{
					if (code <= 255)
					{
						result += current;
						chain = buffer + current;
						dict[chars] = chain;
						chars++;
						buffer = current;
					}
					else
					{
						chain = dict[code];
						if (chain == null)
						{
							chain = buffer + buffer.slice(0, 1);
						}
						result += chain;
						dict[chars] = buffer + chain.slice(0, 1);
						chars++;
						buffer = chain;
					}
				}
			}
			return result;
		}
	
	}

}