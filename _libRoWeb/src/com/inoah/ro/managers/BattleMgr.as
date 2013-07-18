package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    
    public class BattleMgr implements IMgr
    {
        public function BattleMgr()
        {
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