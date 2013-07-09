package com.inoah.ro.controllers
{
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    public class MapController
    {
        private var _root:Sprite;
        
        private var _bgBmp:Bitmap;
        private var _currentContaner:Sprite;
        private var _bgLoader:Loader;
        
        public function MapController( root:Sprite )
        {
            _root = root;
            _bgLoader = new Loader();
            _bgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onBgLoadComplete );
            _bgLoader.load( new URLRequest( "bg.jpg" ));
            
            _currentContaner = new Sprite();
            _root.addChild( _currentContaner );
        }
        
        protected function onBgLoadComplete( e:Event):void
        {
            _bgBmp = _bgLoader.content as Bitmap;
            _bgBmp.x = - 50;
            _bgBmp.y = - 50;
            _root.addChildAt( _bgBmp , 0 );
        }
        
        public function tick( delta:Number ):void
        {
            var obj:DisplayObject;
            var len:int = _currentContaner.numChildren;
            var sortList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for( var i:int = 0;i<len;i++)
            {
                obj = _currentContaner.getChildAt( i );
                sortList.push( obj );
            }
            sortList.sort( sortObjFunc );
        }
        
        private function sortObjFunc( a:DisplayObject, b:DisplayObject ):Number
        {
            if(a.y > b.y)
            {
                if(_currentContaner.getChildIndex(a) < _currentContaner.getChildIndex(b))
                {
                    _currentContaner.swapChildren(a,b);
                }
                return 1;
            }else if(a.y < b.y)
            {
                if(_currentContaner.getChildIndex(a) > _currentContaner.getChildIndex(b))
                {
                    _currentContaner.swapChildren(a,b);
                }
                return -1;
            }else
            {
                return 0;
            }
        }
        
        public function get currentContainer():Sprite
        {
            return _currentContaner;
        }
    }
}