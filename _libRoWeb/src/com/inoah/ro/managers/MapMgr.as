package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.mediators.map.MapMediator;
    
    /**
     *  地图管理器
     * @author inoah
     */    
    public class MapMgr extends MapMediator implements IMgr
    {
        public function MapMgr(viewComponent:Object=null)
        {
            super(viewComponent);
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