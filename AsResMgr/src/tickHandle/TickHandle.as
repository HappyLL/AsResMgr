package tickHandle
{
	import tick.ITick;
	import tick.Ticker;

	public class TickHandle
	{
		private static const FRAME_RATE:int = 60;
		private static var pIns:TickHandle;
		private var m_stTick:Ticker;
		
		public function TickHandle()
		{
			if(pIns)
				throw new Error("单例错误");
			m_stTick = new Ticker(FRAME_RATE);
		}
		
		public static function Get():TickHandle
		{
			return pIns||(pIns = new TickHandle);
		}
		
		public function AddTicker(stTk:ITick):void
		{
			m_stTick.AddNormalTick(stTk);
		}
		
		public function RemvTicker(stTk:ITick):void
		{
			m_stTick.RemoveNormalTick(stTk);
		}
		
		public function StartTicker():void
		{
			m_stTick.Start();
		}
		
		public function StopTicker():void
		{
			m_stTick.Stop();
		}
		
		public function SignalTicker():void
		{
			m_stTick.Signal();
		}
		
	}
}