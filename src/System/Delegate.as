package System
{
	import System.Exception.ObjectDisposedException;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Delegate implements IDisposable, ICloneable, IDelegate
	{
		
		public static function Wrap(handler:Function, ... args):Function
		{
			return function(... innerArgs):void
			{
				var handlerArgs:Array = [];
				if (innerArgs != null)
				{
					handlerArgs = innerArgs;
				}
				if (args != null)
				{
					handlerArgs = handlerArgs.concat(args);
				}
				handler.apply(this, handlerArgs);
			};
		}
		
		private var list:Vector.<Function>;
		private var stoped:Boolean;
		protected var count:int;
		
		public function Delegate(list:Vector.<Function> = null)
		{
			if (list)
			{
				this.list = list;
				count = list.length;
			}
			else
			{
				this.list = new Vector.<Function>();
			}
		}
		
		public function Add(listener:Function/*, index:int = int.MAX_VALUE*/):void
		{
			if (listener == null)
			{
				throw new ArgumentError("listener is null");
			}
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			var index:int = int.MAX_VALUE;
			if (index < 0)
			{
				index = 0;
			}
			var lenght:int = list.length;
			if (index > lenght)
			{
				index = lenght;
			}
			var i:int = list.indexOf(listener);
			if (i == -1)
			{
				if (index == lenght)
				{
					list.push(listener);
				}
				else
				{
					list.splice(index, 0, listener);
				}
				count++;
			}
			else
			{
				if (count == 1)
				{
					return;
				}
				if (i == index)
				{
					return;
				}
				list.splice(i, 1);
				list.splice(index, 0, listener);
			}
		}
		
		public function Remove(listener:Function):void
		{
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			var i:int = list.indexOf(listener);
			if (i == -1)
			{
				return;
			}
			list[i] = null;
			count--;
		}
		
		public function RemoveAll():void
		{
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			if (list.length == 0)
			{
				return;
			}
			list.length = 0;
			count = 0;
		}
		
		public function Invoke(... params):void
		{
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			var len:int = list.length;
			if (len == 0)
			{
				stoped = false;
				return;
			}
			var current:Function;
			var index:int;
			
			for (var i:int = 0; i < len; i++)
			{
				if (count <= 0 || stoped)
				{
					stoped = false;
					return;
				}
				current = list[i];
				if (current as Function)
				{
					if (index != i)
					{
						list[index] = current;
						list[i] = null;
					}
					current.apply(null, params);
					index++;
				}
			}
			if (index != i)
			{
				len = list.length; // count might have changed!
				while (i < len)
				{
					list[index++] = list[i++];
				}
				
				list.length = index;
			}
			stoped = false;
		}
		
		public function Stop():void
		{
			stoped = true;
		}
		
		public function get Count():int
		{
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			return count;
			//return list.length;
		}
		
		public function Dispose():void
		{
			list = null;
		}
		
		public function Clone():Object
		{
			if (list == null)
			{
				throw new ObjectDisposedException("Delegate was disposed");
			}
			return new Delegate(list.concat());
		}
	
	}

}