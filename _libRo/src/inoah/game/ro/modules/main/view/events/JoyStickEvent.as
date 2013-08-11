package inoah.game.ro.modules.main.view.events
{
    import flash.events.Event;

    public class JoyStickEvent extends Event
    {
        public static const JOY_STICK_UP:String = "JoyStickEvent.JOY_STICK_UP";
        public static const JOY_STICK_DOWN:String = "JoyStickEvent.JOY_STICK_DOWN";
        public static const JOY_STICK_LEFT:String = "JoyStickEvent.JOY_STICK_LEFT";
        public static const JOY_STICK_RIGHT:String = "JoyStickEvent.JOY_STICK_RIGHT";
        public static const JOY_STICK_UP_LEFT:String = "JoyStickEvent.JOY_STICK_UP_LEFT";
        public static const JOY_STICK_UP_RIGHT:String = "JoyStickEvent.JOY_STICK_UP_RIGHT";
        public static const JOY_STICK_DOWN_LEFT:String = "JoyStickEvent.JOY_STICK_DOWN_LEFT";
        public static const JOY_STICK_DOWN_RIGHT:String = "JoyStickEvent.JOY_STICK_DOWN_RIGHT";
        public static const JOY_STICK_ATTACK:String = "JoyStickEvent.JOY_STICK_ATTACK";
        
        public var isDown:Boolean
        
        public function JoyStickEvent(type:String, isDown:Boolean )
        {
            super(type);
            this.isDown = isDown;
        }
    }
}