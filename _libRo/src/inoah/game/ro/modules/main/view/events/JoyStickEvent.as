package inoah.game.ro.modules.main.view.events
{
    import flash.events.Event;
    
    public class JoyStickEvent extends Event
    {
        public static const JOY_STICK_UP:String = "GameCommands.JOY_STICK_UP";
        public static const JOY_STICK_DOWN:String = "GameCommands.JOY_STICK_DOWN";
        public static const JOY_STICK_LEFT:String = "GameCommands.JOY_STICK_LEFT";
        public static const JOY_STICK_RIGHT:String = "GameCommands.JOY_STICK_RIGHT";
        public static const JOY_STICK_UP_LEFT:String = "GameCommands.JOY_STICK_UP_LEFT";
        public static const JOY_STICK_UP_RIGHT:String = "GameCommands.JOY_STICK_UP_RIGHT";
        public static const JOY_STICK_DOWN_LEFT:String = "GameCommands.JOY_STICK_DOWN_LEFT";
        public static const JOY_STICK_DOWN_RIGHT:String = "GameCommands.JOY_STICK_DOWN_RIGHT";
        public static const JOY_STICK_ATTACK:String = "GameCommands.JOY_STICK_ATTACK";
        
        public var isDown:Boolean
        
        public function JoyStickEvent(type:String, isDown:Boolean )
        {
            super(type);
            this.isDown = isDown;
        }
    }
}