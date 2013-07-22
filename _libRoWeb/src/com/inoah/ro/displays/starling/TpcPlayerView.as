package com.inoah.ro.displays.starling
{
    public class TpcPlayerView extends TpcBodyView
    {
        public function TpcPlayerView()
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