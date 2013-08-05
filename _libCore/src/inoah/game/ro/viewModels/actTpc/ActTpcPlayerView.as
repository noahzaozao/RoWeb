package inoah.game.ro.viewModels.actTpc
{
    public class ActTpcPlayerView extends ActTpcBodyView
    {
        public function ActTpcPlayerView()
        {
            super();
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
            //only stand
            if( _actionIndex < 8 || (_actionIndex >=16) && (_actionIndex < 24)  )
            {
                currentFrame = 2;
            }
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
        }
    }
}