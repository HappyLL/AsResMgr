package resource
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	public class ResBitmap extends Sprite
	{
		private var m_stBitmap:Bitmap;
		
		private var m_strClassName:String;
		
		public function ResBitmap()
		{
			m_stBitmap = new Bitmap;
			this.addChild(m_stBitmap);
		}
		
		public function UpdateSwf(strUrl:String,strClassName:String):void
		{
			m_strClassName = strClassName;
			ResMgr.Get().LoadBySwf(strUrl,OnCompleteSwf);
		}
		
		private function OnCompleteSwf(stApplicationDomain:ApplicationDomain):void
		{
			if(!stApplicationDomain.hasDefinition(m_strClassName))
			{
				return;
			}
			var m_cls:Class = stApplicationDomain.getDefinition(m_strClassName) as Class;
			if(m_cls==null)
				return;
			var stBitmapData:BitmapData = new m_cls();
			m_stBitmap.bitmapData = stBitmapData;
		}
		
		public function UpdateImg(strUrl:String):void
		{
			ResMgr.Get().LoadByImage(strUrl,OnCompleteImage);
		}
		
		private function OnCompleteImage(stBitmapData:BitmapData):void
		{
			m_stBitmap.bitmapData = stBitmapData;
		}
		
	}
}