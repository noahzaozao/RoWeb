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
        
        override public function updateFrame():void
        {
            super.updateFrame();
            dispatchEvent( new ActSprViewEvent( ActSprViewEvent.NEXT_FRAME ) );
        }
    }
}