package resource
{
	import flash.utils.Dictionary;

	/**
	 * 资源管理器基类
	 * 
	 */
	public class ResMgrBase
	{
		private var m_dUrlMapHasLoadedRes:Dictionary;
		private var m_dUrlMapCallFunc:Dictionary;
		
		public function ResMgrBase()
		{
			m_dUrlMapHasLoadedRes = new Dictionary;
			m_dUrlMapCallFunc = new Dictionary;
		}
		/**
		 * 判断资源是否有被加载过
		 * @param strUrl:String 资源加载路径
		 * @param pFunc:Function 资源的回调函数
		 */
		protected function JudgeRes(strUrl:String,pFunc:Function):Boolean
		{
			if(m_dUrlMapHasLoadedRes[strUrl])
			{
				return true;
			}
			
			if(m_dUrlMapCallFunc[strUrl])
			{
				m_dUrlMapCallFunc[strUrl].push(pFunc);
			}
			else 
			{
				m_dUrlMapCallFunc[strUrl] = new Vector.<Function>;
				m_dUrlMapCallFunc[strUrl].push(pFunc);
			}
			return false;
		}
		
		protected function GetRes(strUrl:String):*
		{
			return m_dUrlMapHasLoadedRes[strUrl];
		}
		
		protected function RetRes(strUrl:String,resObj:*):void
		{
			m_dUrlMapHasLoadedRes[strUrl] = resObj;
		
			if(m_dUrlMapCallFunc[strUrl]==null) return ;
			
			var vstFunc:Vector.<Function> = m_dUrlMapCallFunc[strUrl] as Vector.<Function>;
			if(vstFunc==null)return;
			
			var pFunc:Function;
			for(var i:int = 0;i<vstFunc.length;++i)
			{
				pFunc = vstFunc[i];
				pFunc(resObj);
			}
			
			m_dUrlMapCallFunc[strUrl] = null;
			delete m_dUrlMapCallFunc[strUrl];
			 
		}
		
	}
}