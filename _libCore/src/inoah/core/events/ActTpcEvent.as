package inoah.core.events
{
    import starling.events.Event;

    public class ActTpcEvent extends Event
    {
        
        public static const MOTION_FINISHED:String = "tp_motionFinish";
        public static const MOTION_NEXT_FRAME:String = "tp_nextFrame";
        public static const EMPTY_FRAME:String = "tp_emtypFrame";
        public function ActTpcEvent(type:String, bubbles:Boolean=false, data:Object=null)
        {
            super(type, bubbles, data);
        }
    }
}