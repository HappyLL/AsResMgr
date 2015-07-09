package resource
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	import tick.ITick;
	
	import tickHandle.TickHandle;
	
	public class ResMovieClip extends Sprite implements ITick
	{
		private var m_stMovieClip:MovieClip;
		
		private var m_strClassName:String;
		private var m_iFrameSpeed:int;
		private var m_iCurPos:int;
		private var m_iTotTicks:int;
		private var m_bIsComplete:Boolean;
		private var m_bAutoHide:Boolean;
		private var m_bIsLoop:Boolean;
		private var m_bActive:Boolean;
		private var m_bIsStop:Boolean;
		
		public function ResMovieClip()
		{
			m_iFrameSpeed = 3;
			m_iCurPos = 0;
			m_iTotTicks = -1;
			m_bIsStop = true;
		}
		
		public function Update(strUrl:String,strClassName:String,iFrameSpeed:int = 3,bAutoHide:Boolean = false,bIsLoop:Boolean = true):void
		{
			m_strClassName = strClassName;
			m_iFrameSpeed = iFrameSpeed;
			m_bAutoHide = bAutoHide;
			m_bIsLoop = bIsLoop;
			
			
			ResMgr.Get().LoadBySwf(strUrl,OnCompleteSwf);
			//TickHandle.Get().AddTicker(this);
		}
		
		private function OnCompleteSwf(stApplicationDomain:ApplicationDomain):void
		{
			if(stApplicationDomain==null)
				return;
			if(!stApplicationDomain.hasDefinition(m_strClassName))
				return;
			
			var stClass:Class =stApplicationDomain.getDefinition(m_strClassName) as Class;
			if(stClass==null)
				return;
			m_bIsComplete = true;
			m_stMovieClip = (new stClass()) as MovieClip;
			this.addChild(m_stMovieClip);
			
		}
		
		public function Play():void
		{	
			if(m_bIsStop==false)
				return;
			
			if(m_bIsComplete)
			{
				m_stMovieClip.visible = true;
			}
			
			if(m_bIsStop)
				TickHandle.Get().AddTicker(this);
			m_bIsStop = false;
		}
		
		public function Stop():void
		{
			if(m_bIsStop)
				return;
			m_bIsStop = true;
			if(m_bAutoHide&&m_bIsComplete)
			{
				m_stMovieClip.visible = false;	
			}
			
			TickHandle.Get().RemvTicker(this);
		}
		
		public function SetFrameSpeed(iFrameSpeed:int):void
		{
			m_iFrameSpeed = iFrameSpeed;
			if(iFrameSpeed==0)return;
			m_iCurPos = (int)(m_iTotTicks/m_iFrameSpeed);
			m_iTotTicks = m_iCurPos*m_iFrameSpeed;
		}
		public function Tick(uiTickCount:uint):void
		{
			if(!m_bIsComplete||m_iFrameSpeed==0)
				return;
			m_iTotTicks++;
			if(m_iTotTicks%m_iFrameSpeed)
				return;
			m_iCurPos = m_iTotTicks/m_iFrameSpeed;
			if(m_iCurPos>=m_stMovieClip.totalFrames)
			{
				m_iCurPos = 0;
				m_iTotTicks = -1;
				if(!m_bIsLoop)
				{
					Stop();
				}
				return;
			}
			m_stMovieClip.gotoAndStop(m_iCurPos+1);
		}
		
		
		public function StartTick():void
		{
			m_bActive = true;
		}
		
		
		public function EndTick():void
		{
			m_bActive = false;
		}
		
		
		public function IsTickActive():Boolean
		{
			return m_bActive;
		}
		
		
		public function GetName():String
		{
			return "ResMovieClip";
		}
	}
}