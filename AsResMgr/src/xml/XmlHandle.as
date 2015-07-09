package xml
{
	import flash.utils.Dictionary;
	
	import resource.ResMgr;

	public class XmlHandle
	{
		private static var pIns:XmlHandle;
		
		public function XmlHandle()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public static function Get():XmlHandle
		{
			return pIns||(pIns = new XmlHandle);
		
		}
		
		public function Load(strUrl:String,pCallFunc:Function):void
		{
			ResMgr.Get().LoadByXML(strUrl,pCallFunc);	
		}
		
	}
}