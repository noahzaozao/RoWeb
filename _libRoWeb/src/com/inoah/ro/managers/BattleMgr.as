package com.inoah.ro.managers
{
    import inoah.game.interfaces.IMgr;
    import inoah.game.maps.BattleMap;
    import com.inoah.ro.mediators.battle.BattleMediator;
    
    /**
     * 战斗管理器 （ 主要的战斗逻辑 ）
     * @author inoah
     */    
    public class BattleMgr extends BattleMediator implements IMgr
    {
        public function BattleMgr( scene:BattleMap )
        {
            super( scene );
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