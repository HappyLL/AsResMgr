package gameSceneHandle
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import resource.ResAnimationBitmap;
	import resource.ResBitmap;
	import resource.ResMovieClip;
	
	import xml.XmlHandle;

	public class GameSceneHandle
	{
		private static var pIns:GameSceneHandle;

		private var m_stStage:Stage;
		
		private var m_stBitmapTest1:ResBitmap;
		private var m_stBitmapTest2:ResBitmap;
		private var m_stBitmapTest3:ResBitmap;
		private var m_stBitmapTest4:ResBitmap;
		
		private var m_stAniBitmap:ResAnimationBitmap;
		private var m_stAniBitmap2:ResAnimationBitmap;
		
		private var m_stMovieClip:ResMovieClip;
		
		private var m_stSpeed:int = 1;
		
		public function GameSceneHandle()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public static function Get():GameSceneHandle
		{
			return pIns||(pIns = new GameSceneHandle);
		}
		
		public function InitStage(stStage:Stage):void
		{
			m_stStage = stStage;
			
			m_stBitmapTest4 = new ResBitmap;
			m_stBitmapTest4.UpdateImg("res/background.png");
			m_stStage.addChild(m_stBitmapTest4);
			
			m_stBitmapTest1 = new ResBitmap;
			m_stBitmapTest1.UpdateSwf("res/battleGifts.swf","FlProBasePic");
			m_stStage.addChild(m_stBitmapTest1);
			
			m_stBitmapTest2 = new ResBitmap;
			m_stBitmapTest2.UpdateSwf("res/battleGifts.swf","FlProLang_1");
			m_stStage.addChild(m_stBitmapTest2);
			
			m_stBitmapTest3 = new ResBitmap;
			m_stBitmapTest3.x = 200;
			m_stBitmapTest3.UpdateSwf("res/battleGifts.swf","FlProLang_3");
			m_stStage.addChild(m_stBitmapTest3);
			
			m_stAniBitmap = new ResAnimationBitmap;
			m_stAniBitmap.x = 880;
			m_stAniBitmap.y = 400;
			m_stStage.addChild(m_stAniBitmap);
			m_stAniBitmap.Update("res/305.swf","IDLE",3,true,true);
			
//			m_stAniBitmap2 = new ResAnimationBitmap;
//			m_stAniBitmap2.x = 200;
//			m_stAniBitmap2.y = 600;
//			m_stStage.addChild(m_stAniBitmap2);
//			m_stAniBitmap2.Update("res/321.swf","IDLE",2);
			XmlHandle.Get().Load("res/item.xml",OnCompleteXML);
			XmlHandle.Get().Load("res/investment_plans.xml",OnCompleteXML);
			//XmlHandle.Get().Load("res/item_attr.xml",OnCompleteXML);
			//XmlHandle.Get().Load("res/lottery_draw.xml",OnCompleteXML);
			m_stMovieClip = new ResMovieClip;
			m_stMovieClip.x = 500;
			m_stMovieClip.y = 300;
			m_stMovieClip.Update("res/321.swf","IDLE",2,true);
			m_stMovieClip.Play();
			m_stStage.addChild(m_stMovieClip);
			
			m_stStage.addEventListener(MouseEvent.CLICK,OnClickMouse);
			m_stStage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,OnClickMouseDou);
			m_stStage.addEventListener(MouseEvent.RIGHT_CLICK,OnRig);
			
		}
		
		protected function OnRig(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			m_stMovieClip.SetFrameSpeed(m_stSpeed);
			m_stSpeed++;
			//m_stMovieClip.Stop();
			
		}
		
		protected function OnClickMouseDou(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
		    //m_stAniBitmap.PlayAgain();
			
		}
		
		protected function OnClickMouse(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
		    //m_stAniBitmap.Stop();
			m_stMovieClip.Play();
		}		
		
		protected function OnCompleteXML(stData:XML):void
		{
			trace(stData);
		}
		
		public function GetStage():Stage
		{
			return m_stStage;
		}
		
	}
}