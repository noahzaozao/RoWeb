package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    
    /**
     * 显示管理器 （层管理 )
     * @author inoah
     */    
    public class DisplayMgr implements IMgr
    {
        private var _stage:Stage;
        private var _displayList:Vector.<Sprite>;
        
        public function DisplayMgr( stage:Stage )
        {
            _stage = stage;
            _displayList = new Vector.<Sprite>();
            for( var i:int = 0;i< 5; i++)
            {
                _displayList[i] = new Sprite();
                _stage.addChild( _displayList[i] );
            }
        }
        
        public function get topLevel():Sprite
        {
            return _displayList[4];
        }
        public function get uiLevel():Sprite
        {
            return _displayList[3];
        }
        public function get mapLevel():Sprite
        {
            return _displayList[0];
        }
        
        public function get displayList():Vector.<Sprite>
        {
            return _displayList;
        }
        
        public function dispose():void
        {
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
    }
}