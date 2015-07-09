package resource
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 资源加载管理类(简易版)
	 * 外部加载资源通过swf
	 * 外部直接加载图片
	 * 加载xml
	 * 作者:Happyli
	 * 参考:师傅 
	 */
	public class ResMgr extends ResMgrBase
	{
		
		private static var pIns:ResMgr;

		public function ResMgr()
		{
			if(pIns)
			{
				throw new Error("单例错误");
			}
		}
		
		public  static function Get():ResMgr
		{
			return pIns||(pIns = new ResMgr);
		}
		
		/**
		 * 通过swf来加载
		 * @param strPath:String 资源路径
		 * @param OnCompleteFunc:Function 回调函数
		 */
		public function LoadBySwf(strPath:String,OnCompleteFunc:Function):void
		{
			if(JudgeRes(strPath,OnCompleteFunc))
			{
				var stObj:Object = GetRes(strPath);
				if(stObj==null)return;
				OnCompleteFunc(stObj);
				return;
			}
			
			var stLoader:Loader = new Loader;
			stLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,OnComplete);	
			stLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,OnProgress);
			stLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IoErrorHandler);
			stLoader.load(new URLRequest(strPath));
		
			function OnComplete(e:Event):void
			{
			
				RetRes(strPath,stLoader.contentLoaderInfo.applicationDomain);
				Remove();
			}
			
			function OnProgress(e:Event):void
			{
				//加载进度
			}
			
			function IoErrorHandler(e:IOErrorEvent):void
			{
				trace("IOERROR: "+ e);
				Remove();
			}
			
			function Remove():void
			{
				stLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,OnComplete);	
				stLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,OnProgress);
				stLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IoErrorHandler);
				stLoader = null;
			}
			
		}
		
		/**
		 * 直接从外部加载图片文件
		 * @param strPath:String 加载文件的外部路径
		 * @param OnCompleteFunc:Function 回调函数
		 */
		public function LoadByImage(strPath:String,OnCompleteFunc:Function):void
		{
			if(JudgeRes(strPath,OnCompleteFunc))
			{
				var stObj:Object = GetRes(strPath);
				if(stObj==null)return;
				OnCompleteFunc(stObj);
				return;
			}
			var stLoader:Loader = new Loader;
			stLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,OnComplete);	
			stLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,OnProgress);
			stLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IoErrorHandler);
			stLoader.load(new URLRequest(strPath));
			
			function OnComplete(e:Event):void
			{
				var stBitmapData:BitmapData = (stLoader.content as Bitmap).bitmapData;
				if(stBitmapData==null)return;
				RetRes(strPath,stBitmapData);
				Remove();
			}
			
			function OnProgress(e:Event):void
			{
				//加载进度
			}
			
			function IoErrorHandler(e:IOErrorEvent):void
			{
				trace("IOERROR: "+ e);
				Remove();
			}
			
			function Remove():void
			{
				stLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,OnComplete);
				stLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,OnProgress);
				stLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,IoErrorHandler);
				stLoader = null;
			}
		}
		
		/**
		 * 加载xml
		 * @param strPath:String 加载文件的外部路径
		 * @param OnCompleteFunc:Function 回调函数
		 */
		public function LoadByXML(strPath:String,OnCompleteFunc:Function):void
		{
			if(JudgeRes(strPath,OnCompleteFunc))
			{
				var stObj:Object = GetRes(strPath);
				if(stObj==null)return;
				OnCompleteFunc(stObj);
				return;
			}
			var stLoader:URLLoader = new URLLoader;
			stLoader.addEventListener(Event.COMPLETE,OnComplete);
			stLoader.addEventListener(ProgressEvent.PROGRESS,OnProgress);
			stLoader.addEventListener(IOErrorEvent.IO_ERROR,IoErrorHandler);
			stLoader.load(new URLRequest(strPath));
			
			function OnComplete(e:Event):void
			{
				var stData:XML = new XML(stLoader.data);
				if(stData==null)
					return;
				RetRes(strPath,stData);
				Remove();
			}
			
			function OnProgress(e:Event):void
			{
				//加载进度
			}
			
			function IoErrorHandler(e:IOErrorEvent):void
			{
				trace("IOERROR: "+ e);
				Remove();
			}
			
			function Remove():void
			{
				stLoader.removeEventListener(Event.COMPLETE,OnComplete);
				stLoader.removeEventListener(ProgressEvent.PROGRESS,OnProgress);
				stLoader.removeEventListener(IOErrorEvent.IO_ERROR,IoErrorHandler);
				stLoader = null;
			}
			
		}
		
	}
}