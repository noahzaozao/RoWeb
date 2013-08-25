package inoah.core 
{
    import flash.text.TextField;

    public class Global
    {
        public static var ENABLE_LUA:Boolean;
        public static var IS_MOBILE:Boolean;
        public static var SCREEN_W:uint;
        public static var SCREEN_H:uint;

        public static var MAP_W:uint = 6400;
        public static var MAP_H:uint = 3200;

        public static var TILE_W:int = 128;
        public static var TILE_H:int = 64;
        
        public static var redrawW : int = 5;  //重绘区域
        public static var redrawH : int = 6;
        public static var redrawHOffset : int = 0;
        
        public static var PLAYER_POSX:int = 1120;
        public static var PLAYER_POSY:int = 560;

        public static var debugTxt:TextField;
        
        public static const ORDER_TIME:Number = 0.15;
        public static const MAX_MONSTER_NUM:uint = 1000;
        
        public function Global()
        {
        }
    }
}