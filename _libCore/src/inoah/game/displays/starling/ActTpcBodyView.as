package inoah.game.displays.starling
{
    import inoah.game.events.TPMovieClipEvent;

    public class ActTpcBodyView extends ActTpcView
    {
        public function ActTpcBodyView()
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