package com.inoah.ro.displays
{
    import com.inoah.ro.events.ActSprViewEvent;

    /**
     * body view 
     * @author inoah
     * 
     */    
    public class ActSprBodyView extends ActSprView
    {
        public function ActSprBodyView()
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
            dispatchEvent( new ActSprViewEvent( ActSprViewEvent.NEXT_FRAME ) );
        }
    }
}