package com.D5Power.loader
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    /**
     * 二进制队列加载专用
     */ 
    public class DURLLoader extends URLLoader
    {
        
        private static const PASSWD:String='D5PowerPasswordYouMustInputIt';
        private static var _waitList:Array;
        private static var _isLoading:Boolean;
        private static var _me:DURLLoader;
        private static var _urlR:URLRequest;
        
        public var takeData:*;
        
        public static function get me():DURLLoader
        {
            if(!_me)
            {
                _me = new DURLLoader(PASSWD);
                _urlR = new URLRequest();
                _waitList = new Array();
                _me.addEventListener(Event.COMPLETE,onComplate);
                _me.addEventListener(IOErrorEvent.IO_ERROR,onError);
            }
            return _me;
        }
        
        private static function onComplate(e:Event):void
        {
            // 第0元素为原始地址，取出作为资源池地址备用
            var checksrc:String = _waitList[0][0];
            trace("[D5RPG] DURLLoader加载资源完成！",checksrc);
            // 数组第1元素为回调函数
            _waitList[0][2] ? _waitList[0][1](_me.data,checksrc,_waitList[0][2]) : _waitList[0][1](_me.data,checksrc);
            _waitList.splice(0,1);
            
            if(_waitList.length>0)
            {
                loadNext();
            }else{
                _isLoading = false;
            }
        }
        
        private static function onError(e:Event):void
        {
            var checksrc:String = _waitList[0][0];
            _waitList.splice(0,1);
            trace("[D5RPG] DURLLoader无法加载资源，请检查URL地址是否正确：",checksrc); 
            if(_waitList.length>0) loadNext();
        }
        
        private static function loadNext():void
        {
            _isLoading = true;
            _urlR.url = _waitList[0][0];
            _me.load(_urlR);
        }
        
        
        public function DURLLoader(passwd:String)
        {
            if(passwd!=PASSWD) error();
            super();
            dataFormat = URLLoaderDataFormat.BINARY;
        }
        
        public function addLoad(url:String,complate:Function,data:*=null):void
        {
            if(!url || url=='')
            {
                throw new Error("[DURLLoader] Can not load null address.");
            }
            var block:Array = new Array(url,complate,data);
            _waitList.push(block);
            
            if(!_isLoading) loadNext();
        }
        
        private function error():void
        {
            throw new Error("[DURLLoader] DURLLoader是一个单例，请使用静态的me方法进行访问。");
        }
    }
}