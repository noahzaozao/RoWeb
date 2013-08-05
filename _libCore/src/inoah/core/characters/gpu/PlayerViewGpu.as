package inoah.core.characters.gpu
{
    import inoah.core.infos.CharacterInfo;
    
    public class PlayerViewGpu extends CharacterViewGpu
    {
        public function PlayerViewGpu(charInfo:CharacterInfo=null)
        {
            super(charInfo);
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