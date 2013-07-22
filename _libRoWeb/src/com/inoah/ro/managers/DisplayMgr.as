package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    /**
     * 显示管理器 （层管理 )
     * @author inoah
     */    
    public class DisplayMgr implements IMgr
    {
        private var _stage:Stage;
        private var _displayList:Vector.<flash.display.Sprite>;
        private var _displayStarlingList:Vector.<starling.display.Sprite>;
        private var _starlingRoot:DisplayObjectContainer;
        
        public function DisplayMgr( stage:Stage , starlingRoot:DisplayObject )
        {
            _stage = stage;
            _starlingRoot = starlingRoot as DisplayObjectContainer;
            _displayList = new Vector.<flash.display.Sprite>();
            for( var i:int = 0;i< 2; i++)
            {
                _displayList[i] = new flash.display.Sprite();
                _stage.addChild( _displayList[i] );
            }
            _displayStarlingList = new Vector.<starling.display.Sprite>();
            for( i = 0;i< 2; i++)
            {
                _displayStarlingList[i] = new starling.display.Sprite();
                _starlingRoot.addChild( _displayStarlingList[i] );
            }
        }
        
        public function get topLevel():flash.display.Sprite
        {
            return _displayList[1];
        }
        public function get uiLevel():flash.display.Sprite
        {
            return _displayList[0];
        }
        public function get unitLevel():starling.display.Sprite
        {
            return _displayStarlingList[1];
        }
        public function get mapLevel():starling.display.Sprite
        {
            return _displayStarlingList[0];
        }
        
        public function get displayList():Vector.<flash.display.Sprite>
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