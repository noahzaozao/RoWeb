package inoah.core.characters.nogpu
{
    public class PlayerView extends CharacterView
    {
        public function PlayerView()
        {
            super();
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
        
        override public function set dirIndex( v:uint):void
        {
            super.dirIndex = v;
        }
    }
}