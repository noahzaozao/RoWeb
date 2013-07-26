package inoah.game.managers
{
    import flash.events.Event;
    
    import inoah.game.interfaces.IMgr;
    import inoah.game.loaders.ActSprLoader;
    import inoah.game.loaders.ActTpcLoader;
    import inoah.game.loaders.AtfLoader;
    import inoah.game.loaders.ILoader;
    import inoah.game.loaders.JpgLoader;
    
    /**
     * 资源加载管理器 
     * @author inoah
     */    
    public class AssetMgr implements IMgr
    {
        private var _cacheList:Vector.<ILoader>;
        private var _cacheListIndex:Vector.<String>;
        private var _loaderList:Vector.<ILoader>;
        private var _callBackList:Vector.<Function>;
        private var _isLoading:Boolean;
        
        public function AssetMgr()
        {
            _cacheList = new Vector.<ILoader>();
            _cacheListIndex = new Vector.<String>();
            _loaderList = new Vector.<ILoader>();
            _callBackList = new Vector.<Function>(); 
        }
        
        public function dispose():void
        {
            
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
        
        public function getResList( resPathList:Vector.<String>, callBack:Function, onProgress:Function = null ):void
        {
            var len:int = resPathList.length;
            for( var i:int =0;i<len;i++)
            {
                if( i == len - 1 )
                {
                    getRes( resPathList[i] , callBack );
                }
                else
                {
                    getRes( resPathList[i] , null );
                }
            }
        }
        public function getRes( resPath:String, callBack:Function ):ILoader
        {
            if( _cacheListIndex.indexOf( resPath ) != -1  )
            {
                if( callBack != null )
                {
                    callBack.apply( null, [ _cacheList[ _cacheListIndex.indexOf( resPath ) ] ] );
                }
                return _cacheList[ _cacheListIndex.indexOf( resPath ) ];
            }
            switch( resPath.split( "." )[1] )
            {
                case "tpc":
                {
                    _loaderList.push( new ActTpcLoader( resPath ) );
                    break;
                }
                case "act":
                {
                    _loaderList.push( new ActSprLoader( resPath ) );
                    break;
                }
                case "atf":
                {
                    _loaderList.push( new AtfLoader( resPath ) );
                    break;
                }
                case "jpg":
                {
                    _loaderList.push( new JpgLoader( resPath ) );
                    break;
                }
                case "png":
                {
                    _loaderList.push( new JpgLoader( resPath ) );
                    break;
                }
            }
            _callBackList.push( callBack );
            
            if( _isLoading == false )
            {
                loadNext();
            }
            return null;
        }
        
        private function loadNext():void
        {
            var callBack:Function;
            var loader:ILoader;
            if( _loaderList.length > 0 )
            {
                if( _cacheListIndex.indexOf( _loaderList[0].url ) == -1  )
                {
                    _isLoading = true;
                    _loaderList[0].addEventListener( Event.COMPLETE , onLoadComplete );
                    //                    RoGlobal.debugTxt.appendText( "start load" + _loaderList[0].url + "\n");
                    trace( "start load" + _loaderList[0].url );
                    _loaderList[0].load();
                }
                else
                {
                    callBack = _callBackList[0];
                    loader = _loaderList[0];
                    _loaderList.shift();
                    _callBackList.shift();
                    if( callBack != null )
                    {
                        callBack.apply( null, [ _cacheList[ _cacheListIndex.indexOf( loader.url ) ] ] );
                    }
                    loadNext();
                }
            }
        }
        
        private function onLoadComplete( e:Event ):void
        {
            var loader:ILoader = e.currentTarget as ILoader;
            var callBack:Function = _callBackList[0]
            loader.removeEventListener( Event.COMPLETE, onLoadComplete );
            _loaderList.shift();
            _callBackList.shift();
            //            RoGlobal.debugTxt.appendText( "load complete..." + loader.url + "\n");
            trace( "load complete..." + loader.url );
            _cacheList.push( loader );
            _cacheListIndex.push( loader.url );
            
            if( callBack != null )
            {
                callBack.apply( null, [loader]);
            }
            _isLoading = false;
            loadNext();
        }
    }
}