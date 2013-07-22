package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.mediators.map.MapMediator;
    
    import starling.display.Sprite;
    
    /**
     *  地图管理器
     * @author inoah
     */    
    public class MapMgr extends MapMediator implements IMgr
    {
        public function MapMgr( unitLevel:starling.display.Sprite , mapLevel:starling.display.Sprite )
        {
            super( unitLevel , mapLevel );
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