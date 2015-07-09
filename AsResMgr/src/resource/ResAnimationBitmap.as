package resource
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	import gameSceneHandle.GameSceneHandle;
	
	import tick.ITick;
	
	import tickHandle.TickHandle;

	public class ResAnimationBitmap extends Sprite implements ITick 
	{
		private var m_stBitmap:Bitmap;
		private var m_vstBitmapData:Vector.<BitmapData>;
		private var m_vPoint:Vector.<Point>;
		
		private var m_iFrameSpeed:int;
		private var m_iCurPos:int;
		private var m_iTotTick:int;
		private var m_bIsComplete:Boolean;
		private var m_bActive:Boolean;
		private var m_strClassName:String;
		private var m_bAutoHide:Boolean;
		private var m_bIsLoop:Boolean;
		private var m_bIsStop:Boolean;
		public function ResAnimationBitmap()
		{
			m_stBitmap = new Bitmap;
			this.addChild(m_stBitmap);
			
			m_vstBitmapData = new Vector.<BitmapData>;
			m_vPoint = new Vector.<Point>;
			
			m_iFrameSpeed = 3;
			m_iCurPos = 0;
			m_iTotTick = -1;
			m_bIsComplete = false;
		}
		
		public function Update(strUrl:String,strClassName:String,iFrameSpeed:int = 3,bAutoHide:Boolean = false,bIsLoop:Boolean = true):void
		{
			m_strClassName = strClassName;
			m_bAutoHide = bAutoHide;
			m_bIsLoop = bIsLoop;
			m_iFrameSpeed = iFrameSpeed;
			ResMgr.Get().LoadBySwf(strUrl,OnCompleteSwf);
			
			m_bIsStop = false;
			TickHandle.Get().AddTicker(this);
		}
		
		private function OnCompleteSwf(stApplicationDomain:ApplicationDomain):void
		{
			if(stApplicationDomain==null)
				return;
			if(!stApplicationDomain.hasDefinition(m_strClassName))
				return;
			var stClass:Class = stApplicationDomain.getDefinition(m_strClassName) as Class;
			if(stClass==null)
				return;
			var stMc:MovieClip = new stClass() as MovieClip;
			var stBitmapData:BitmapData;
			var stMartix:Matrix = new Matrix(1,0,0,1,0,0);
			
			//this.addChild(stMc);
			GameSceneHandle.Get().GetStage().addChild(stMc);
			for(var i:int = 0;i<stMc.totalFrames;++i)
			{
				stMc.gotoAndStop(i+1);
				stBitmapData = new BitmapData(stMc.width,stMc.height,true,0x00ffffff);
				stMartix.tx = -stMc.transform.pixelBounds.left;
				stMartix.ty = -stMc.transform.pixelBounds.top;
				stBitmapData.draw(stMc,stMartix);
				m_vstBitmapData.push(stBitmapData);
				m_vPoint.push(new Point(-stMartix.tx,-stMartix.ty));
			}
			GameSceneHandle.Get().GetStage().removeChild(stMc);
			//this.removeChild(stMc);
			
			m_bIsComplete = true;
		}
		
		public function PlayAgain(bAutoHide:Boolean = false,bIsLoop:Boolean = true):void
		{
			m_bAutoHide = bAutoHide;
			m_bIsLoop = bIsLoop;

			if(!m_bIsStop||m_bIsComplete==false)return;
			m_bIsStop = false;
			
			TickHandle.Get().AddTicker(this);
		}
		
		public function SetFrameSpeed(iFrameSpeed:int):void
		{
			m_iFrameSpeed = iFrameSpeed;
			if(iFrameSpeed==0)return;
			m_iCurPos = (int)(m_iTotTick/m_iFrameSpeed);
			m_iTotTick = m_iCurPos*m_iFrameSpeed;
		}
		
		public function Stop():void
		{
			if(m_bIsStop)
				return;
			if(m_bIsComplete&&m_bAutoHide)
			{
				m_stBitmap.bitmapData = null;
			}
			m_bIsStop = true;
			TickHandle.Get().RemvTicker(this);
			
			
		}
		
		public function Tick(uiTickCount:uint):void
		{
			//处理数据
			if(!m_bIsComplete||m_iFrameSpeed==0)return;
			m_iTotTick++;
			if(m_iTotTick%m_iFrameSpeed)return;
			m_iCurPos = m_iTotTick/m_iFrameSpeed;
			
			if(m_iCurPos>=m_vstBitmapData.length)
			{
				m_iTotTick = -1;
				m_iCurPos = 0;
				if(m_bIsLoop==false)
				{
					Stop();
				}
				return;
			}
			
			m_stBitmap.bitmapData = m_vstBitmapData[m_iCurPos];
			m_stBitmap.x = m_vPoint[m_iCurPos].x;
			m_stBitmap.y = m_vPoint[m_iCurPos].y;
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
			return "ResAnimationBitmap";
		}
		
	}
}