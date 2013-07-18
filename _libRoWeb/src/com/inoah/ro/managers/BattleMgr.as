package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.mediators.battle.BattleMediator;
    
    public class BattleMgr extends BattleMediator implements IMgr
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
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
    }
}