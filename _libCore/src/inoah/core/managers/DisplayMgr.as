package inoah.core.managers
{
    import flash.display.Sprite;
    import flash.display.Stage;
    
    import inoah.core.interfaces.IMgr;
    
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
        
        public function DisplayMgr( stage:Stage )
        {
            _stage = stage;
            _displayList = new Vector.<flash.display.Sprite>();
            for( var i:int = 0;i< 2; i++)
            {
                _displayList[i] = new flash.display.Sprite();
                _stage.addChild( _displayList[i] );
            }
        }
        
        public function initStarling( starlingRoot:DisplayObject ):void
        {
            _starlingRoot = starlingRoot as DisplayObjectContainer;
            _displayStarlingList = new Vector.<starling.display.Sprite>();
            for( var i:int = 0;i< 4; i++)
            {
                _displayStarlingList[i] = new starling.display.Sprite();
                if( i < 3 )
                {
                    _displayStarlingList[i].touchable = false;
                }
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
        public function get joyStickLevel():starling.display.Sprite
        {
            return _displayStarlingList[3];
        }
        public function get unitLevel():starling.display.Sprite
        {
            return _displayStarlingList[2];
        }
        public function get mapLevel():starling.display.Sprite
        {
            return _displayStarlingList[1];
        }
        public function get bgLevel():starling.display.Sprite
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