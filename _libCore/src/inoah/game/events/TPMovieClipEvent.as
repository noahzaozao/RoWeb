package inoah.game.events
{
    import starling.events.Event;

    public class TPMovieClipEvent extends Event
    {
        
        public static const MOTION_FINISHED:String = "tp_motionFinish";
        public static const MOTION_NEXT_FRAME:String = "tp_nextFrame";
        public static const EMPTY_FRAME:String = "tp_emtypFrame";
        public function TPMovieClipEvent(type:String, bubbles:Boolean=false, data:Object=null)
        {
            super(type, bubbles, data);
        }
    }
}