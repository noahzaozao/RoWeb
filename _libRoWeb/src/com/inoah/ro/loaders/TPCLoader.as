package com.inoah.ro.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    public class TPCLoader extends EventDispatcher implements ILoader
    {
        protected var _tpcUrl:String;
        protected var _tpcLoader:URLLoader;
        
        public function TPCLoader( tpcPath:String )
        {
            _tpcUrl = tpcPath;
        }
        
        public function get url():String
        {
            return _tpcUrl;
        }
        
        public function get tpcData():ByteArray
        {
            return _tpcLoader.data;
        }
        
        public function load():void
        {
            _tpcLoader = new URLLoader();
            _tpcLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _tpcLoader.addEventListener( Event.COMPLETE, onActLoaderComplete );
            _tpcLoader.load( new URLRequest( _tpcUrl ) );
        }
        
        protected function onActLoaderComplete( e:Event):void
        {
            _tpcLoader.removeEventListener( Event.COMPLETE, onActLoaderComplete );
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
    }
}