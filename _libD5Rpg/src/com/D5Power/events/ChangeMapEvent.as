package com.D5Power.events
{
    import flash.events.Event;
    
    /**
     * 更换地图事件
     */ 
    public class ChangeMapEvent extends Event
    {
        /**
         * 是否自配置地图，如果为true,则不进行地图配置文件的加载
         */ 
        private var _autoSetup:Boolean;
        /**
         * 想切换到的地图ID
         */ 
        private var _toMap:uint;
        /**
         * 切换地图后的坐标
         */ 
        private var _toX:uint;
        /**
         * 切换地图后的坐标
         */
        private var _toY:uint;
        /**
         * 同地图不切换
         */ 
        private var _sameMapNotChange:Boolean;
        
        public static const CHANGE:String = 'changeMap';
        
        /**
         * @param	mapid	切换到的地图ID
         * @param	x		切换到的地图X坐标
         * @param	y		切换到的地图Y坐标
         * @param	autoSetup	是否启用自配置地图。如果启用，则不进行地图配置文件的加载
         */ 
        public function ChangeMapEvent(mapid:uint,x:uint,y:uint,autoSetup:Boolean=false,sameMap:Boolean=true)
        {
            _toMap = mapid;
            _toX = x;
            _toY = y;
            _autoSetup = autoSetup;
            _sameMapNotChange = sameMap;
            super(CHANGE, bubbles, cancelable);
        }
        
        public function get toMap():uint
        {
            return _toMap;
        }
        
        public function get toX():uint
        {
            return _toX;
        }
        
        public function get toY():uint
        {
            return _toY;
        }
        
        public function get isAutoSetup():Boolean
        {
            return _autoSetup;
        }
        
        public function get sameMapNotChange():Boolean
        {
            return _sameMapNotChange;
        }
    }
}