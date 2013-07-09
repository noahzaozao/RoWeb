package com.D5Power.net
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    /**
     * 分步加载器以及资源池
     * @author D5Power Studio
     */ 
    public class D5StepLoader
    {
        private static const PASSWD:String='D5PowerPasswordYouMustInputIt';
        private static var _pool:Dictionary;
        private static var _waitList:Array;
        private static var _isLoading:Boolean;
        private static var _loader:URLLoader;
        private static var _imgloader:Loader;
        private static var _me:D5StepLoader;
        
        
        public static const TYPE_BITMAP:String = 'bitmap';
        
        public static const TYPE_XML:String = 'xml';
        
        public static const TYPE_STRING:String = 'string';
        
        public static const TYPE_SWF:String = 'swf';
        
        
        
        public static function get me():D5StepLoader
        {
            if(!_me) _me = new D5StepLoader(PASSWD);
            return _me;
        }
        
        private static function onImageComplate(e:Event):void
        {
            var mode:String = _waitList[0][3];
            
            var data:Object;
            switch(mode)
            {
                case TYPE_SWF:
                    data = _imgloader.content;
                    break;
                default:
                    
                    data = _imgloader.content as Bitmap;
                    break;
            }
            
            
            doComplate(data);
        }
        
        private static function onComplate(e:Event):void
        {
            var bytes:ByteArray = _loader.data;
            if(_waitList[0])
            {
                switch(_waitList[0][3])
                {
                    case TYPE_BITMAP:
                    case TYPE_SWF:
                        var lc:LoaderContext= new LoaderContext();
                        lc.allowCodeImport = true;
                        _imgloader.loadBytes(bytes,lc);
                        break;
                    case TYPE_STRING:
                        var string:String = bytes.readUTFBytes(bytes.bytesAvailable);
                        doComplate(string);
                        break;
                    case TYPE_XML:
                        var xmlbase:String = bytes.readUTFBytes(bytes.bytesAvailable);
                        doComplate(new XML(xmlbase));
                        break;
                    default:
                        doComplate(_loader.data);
                        break;
                }
                
                
            }else{
                trace("[D5StepLoader] 当加载结果返回时，未发现符合条件的处理数据。");
            }
        }
        
        private static function doComplate(data:*):void
        {
            // 数组第1元素为回调函数
            _waitList[0][1](data);
            // 第0元素为原始地址，取出作为资源池地址备用
            var checksrc:String = _waitList[0][0];
            // 第2元素为是否入池
            var isPool:Boolean = _waitList[0][2];
            // 第3元素为处理模式
            var mode:String = _waitList[0][3];
            
            _waitList.splice(0,1);
            var findList:Array = [];
            
            
            // 当加载完一个资源后，循环检查加载队列中是否还有其他同地址的加载请求，一并处理
            for(var id:uint = 0,j:uint = _waitList.length;id<j;id++)
            {
                if(_waitList[id][0]==checksrc)
                {
                    _waitList[id][1](data);
                    findList.push(id);
                }
            }
            
            // 删除已处理的资源
            var i:uint;
            for each(id in findList)
            {
                // 删除后队列下标发生移位，因此必须每次进行偏移
                _waitList.splice(id-i,1);
                i++;
            }
            
            // 将加载完成的资源加入资源池
            if(isPool)
            {
                _pool[checksrc] = data;
            }else{
                trace("未入资源池");
            }
            
            loadNext();
        }
        
        private static function onError(e:Event):void
        {
            var checksrc:String = _waitList[0] ? _waitList[0][0] : '';
            _waitList.splice(0,1);
            trace("[D5Power] StepLoader无法加载资源，请检查URL地址是否正确：",checksrc); 
            loadNext();
        }
        
        private static function loadNext():void
        {
            if(_waitList.length>0)
            {
                load();
            }else{
                _isLoading = false;
            }
        }
        
        private static function load():void
        {
            _isLoading = true;
            _loader.load(new URLRequest(_waitList[0][0]));
        }
        
        public function D5StepLoader(passwd:String='')
        {
            if(passwd!=PASSWD) error();
            if(_waitList==null)
            {
                _pool = new Dictionary();
                _waitList = new Array();
                _loader = new URLLoader();
                _loader.dataFormat = URLLoaderDataFormat.BINARY;
                _loader.addEventListener(Event.COMPLETE,onComplate);
                _loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
                
                _imgloader = new Loader();
                _imgloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageComplate);
            }
        }
        
        /**
         * 新增加载文件
         * @param	url			文件地址
         * @param	compalte	加载结束触发函数
         * @param	isPool		是否入资源池
         * @param	type		文件类型
         */ 
        public function addLoad(url:String,complate:Function,isPool:Boolean=false,type:String='bitmap'):void
        {
            if(!url || url=='')
            {
                throw new Error("[StepLoader] Can not load null address.");
            }
            
            if(_pool[url]!=null)
            {
                // 资源池中存在该资源，直接回叫
                complate(_pool[url]);
                //trace("[StepLoader] 资源池中存在同地址资源，直接处理无需进入队列。",url);
                loadNext();
                return;
            }
            var block:Array = new Array(url,complate,isPool,type);
            _waitList.push(block);
            loadNext();
        }
        
        /**
         * 删除资源
         */ 
        public function deleteRes(url:String):void
        {
            var res:Object = _pool[url];
            if(res is Bitmap)
            {
                (res as Bitmap).bitmapData.dispose();
            }
            
            delete _pool[url];
        }
        
        private function error():void
        {
            throw new Error("StepLoader是一个单例，请使用静态的me方法进行访问。");
        }
    }
}