package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gameSceneHandle.GameSceneHandle;
	
	import tickHandle.TickHandle;
	
	[SWF(width="1440", height="900", frameRate="60")]
	
	public class AsResMgr extends Sprite
	{
		public function AsResMgr()
		{
		
			stage.addEventListener(Event.ADDED_TO_STAGE,OnAddToStage);
			stage.addEventListener(Event.ENTER_FRAME,OnEnterFrame);
			
			OnAddToStage(null);
		}
		public function OnAddToStage(e:Event):void
		{
			GameSceneHandle.Get().InitStage(stage);
		}
		
		public function OnEnterFrame(e:Event):void
		{
			TickHandle.Get().SignalTicker();
		}
	}
}