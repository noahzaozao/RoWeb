package com.inoah.ro.displays.starling
{
    import com.inoah.ro.events.TPMovieClipEvent;

    public class TpcBodyView extends TpcView
    {
        public function TpcBodyView()
        {
            super();
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
            dispatchEvent( new TPMovieClipEvent( TPMovieClipEvent.MOTION_NEXT_FRAME ) );
        }
    }
}