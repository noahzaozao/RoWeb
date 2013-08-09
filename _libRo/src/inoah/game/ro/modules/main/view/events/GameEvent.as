package inoah.game.ro.modules.main.view.events
{
    import flash.events.Event;
    
    public class GameEvent extends Event
    {
        public static const LOGIN:String = "GameCommands.LOGIN";
        public static const RIGHT_CLICK:String = "GameCommands.RIGHT_CLICK";
        
        public static const JOY_STICK_UP:String = "GameCommands.JOY_STICK_UP";
        public static const JOY_STICK_DOWN:String = "GameCommands.JOY_STICK_DOWN";
        public static const JOY_STICK_LEFT:String = "GameCommands.JOY_STICK_LEFT";
        public static const JOY_STICK_RIGHT:String = "GameCommands.JOY_STICK_RIGHT";
        public static const JOY_STICK_UP_LEFT:String = "GameCommands.JOY_STICK_UP_LEFT";
        public static const JOY_STICK_UP_RIGHT:String = "GameCommands.JOY_STICK_UP_RIGHT";
        public static const JOY_STICK_DOWN_LEFT:String = "GameCommands.JOY_STICK_DOWN_LEFT";
        public static const JOY_STICK_DOWN_RIGHT:String = "GameCommands.JOY_STICK_DOWN_RIGHT";
        public static const JOY_STICK_ATTACK:String = "GameCommands.JOY_STICK_ATTACK";
        
        public static const SHOW_ALERT:String = "GameCommands.SHOW_ALERT";
        public static const HIDE_ALERT:String = "GameCommands.HIDE_ALERT";
        
        public static const OPEN_STATUS:String = "GameCommands.OPEN_STATUS";
        public static const CLOSE_STATUS:String = "GameCommands.CLOSE_STATUS";
        public static const OPEN_SKILL:String = "GameCommands.OPEN_SKILL";
        public static const CLOSE_SKILL:String = "GameCommands.CLOSE_SKILL";
        public static const OPEN_ITEM:String = "GameCommands.OPEN_ITEM";
        public static const CLOSE_ITEM:String = "GameCommands.CLOSE_ITEM";
        public static const OPEN_MAP:String = "GameCommands.OPEN_MAP";
        public static const CLOSE_MAP:String = "GameCommands.CLOSE_MAP";
        public static const OPEN_TASK:String = "GameCommands.OPEN_TASK";
        public static const CLOSE_TASK:String = "GameCommands.CLOSE_TASK";
        public static const OPEN_OPTION:String = "GameCommands.OPEN_OPTION";
        public static const CLOSE_OPTION:String = "GameCommands.CLOSE_OPTION";
        
        public static const SEND_CHAT:String = "GameCommands.SEND_CHAT";
        public static const RECV_CHAT:String = "GameCommands.RECV_CHAT";
        
        public static const UPDATE_HP:String = "GameCommands.UPDATE_HP";
        public static const UPDATE_SP:String = "GameCommands.UPDATE_SP";
        public static const UPDATE_EXP:String = "GameCommands.UPDATE_EXP";
        public static const UPDATE_LV:String = "GameCommands.UPDATE_LV";
        public static const UPDATE_STATUS_POINT:String = "GameCommands.UPDATE_STATUS_POINT";
        
        //map
        public static const CHANGE_MAP:String = "GameCommands.CHANGE_MAP";
        
        public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}