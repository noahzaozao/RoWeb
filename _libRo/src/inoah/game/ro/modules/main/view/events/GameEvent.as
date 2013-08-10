package inoah.game.ro.modules.main.view.events
{
    import flash.events.Event;
    
    public class GameEvent extends Event
    {
        public static const LOGIN:String = "GameEvent.LOGIN";
        public static const RIGHT_CLICK:String = "GameEvent.RIGHT_CLICK";
        
        public static const SHOW_ALERT:String = "GameEvent.SHOW_ALERT";
        public static const HIDE_ALERT:String = "GameEvent.HIDE_ALERT";
        
        public static const OPEN_STATUS:String = "GameEvent.OPEN_STATUS";
        public static const CLOSE_STATUS:String = "GameEvent.CLOSE_STATUS";
        public static const OPEN_SKILL:String = "GameEvent.OPEN_SKILL";
        public static const CLOSE_SKILL:String = "GameEvent.CLOSE_SKILL";
        public static const OPEN_ITEM:String = "GameEvent.OPEN_ITEM";
        public static const CLOSE_ITEM:String = "GameEvent.CLOSE_ITEM";
        public static const OPEN_MAP:String = "GameEvent.OPEN_MAP";
        public static const CLOSE_MAP:String = "GameEvent.CLOSE_MAP";
        public static const OPEN_TASK:String = "GameEvent.OPEN_TASK";
        public static const CLOSE_TASK:String = "GameEvent.CLOSE_TASK";
        public static const OPEN_OPTION:String = "GameEvent.OPEN_OPTION";
        public static const CLOSE_OPTION:String = "GameEvent.CLOSE_OPTION";
        
        public static const SEND_CHAT:String = "GameEvent.SEND_CHAT";
        public static const RECV_CHAT:String = "GameEvent.RECV_CHAT";
        
        public static const UPDATE_HP:String = "GameEvent.UPDATE_HP";
        public static const UPDATE_SP:String = "GameEvent.UPDATE_SP";
        public static const UPDATE_EXP:String = "GameEvent.UPDATE_EXP";
        public static const UPDATE_LV:String = "GameEvent.UPDATE_LV";
        public static const UPDATE_STATUS_POINT:String = "GameEvent.UPDATE_STATUS_POINT";
        
        public var msg:String;
        
        public function GameEvent( type:String, msg:String = "" )
        {
            super(type);
            this.msg = msg;
        }
    }
}