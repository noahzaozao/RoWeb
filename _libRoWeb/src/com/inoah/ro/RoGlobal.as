package com.inoah.ro 
{
    import com.inoah.ro.infos.UserInfo;

    public class RoGlobal
    {
        public static var isIPhone:Boolean;
        public static var W:uint;
        public static var H:uint;
        public static var MAP_W:uint = 2048;
        public static var MAP_H:uint = 2048;
        public static var isStarling:Boolean = false;
        public static var username:String = 'D5Power';
        
        public static var userInfo:UserInfo;
        public static var TILE_W:int = 10;
        public static var TILE_H:int = 10;
        
        public function RoGlobal()
        {
        }
    }
}