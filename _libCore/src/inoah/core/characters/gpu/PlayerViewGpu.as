package inoah.core.characters.gpu
{
    public class PlayerViewGpu extends CharacterViewGpu
    {
        public function PlayerViewGpu()
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