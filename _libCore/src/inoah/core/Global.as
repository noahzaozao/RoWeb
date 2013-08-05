package inoah.core 
{
    import flash.text.TextField;
    
    import inoah.core.infos.UserInfo;

    public class Global
    {
        public static var IS_MOBILE:Boolean;
        public static var SCREEN_W:uint;
        public static var SCREEN_H:uint;

        public static const MAP_W:uint = 3200;
        public static const MAP_H:uint = 1600;

        public static const TILE_W:int = 64;
        public static const TILE_H:int = 32;

        public static var userInfo:UserInfo;

        public static var debugTxt:TextField;
        
        public static const ORDER_TIME:Number = 0.15;
        public static const MAX_MONSTER_NUM:uint = 1000;
        
        public function Global()
        {
        }
    }
}