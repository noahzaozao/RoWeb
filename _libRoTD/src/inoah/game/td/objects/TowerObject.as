package inoah.game.td.objects
{
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.interfaces.tower.ITowerObject;
    
    public class TowerObject extends BattleCharacterObject implements ITowerObject
    {
        public function TowerObject()
        {
            super();
            _atkCd = 3;
            _moveCd = 3;
            atkRange = 400;
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
        }
    }
}