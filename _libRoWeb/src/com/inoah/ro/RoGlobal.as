package com.inoah.ro 
{
    import com.inoah.ro.infos.UserInfo;

    public class RoGlobal
    {
        public static var isIPhone:Boolean;
        public static var W:uint;
        public static var H:uint;
        public static const MAP_W:uint = 2048;
        public static const MAP_H:uint = 2048;
        public static const isStarling:Boolean = false;
        public static var username:String = 'player';
        
        public static var userInfo:UserInfo;
        public static const TILE_W:int = 300;
        public static const TILE_H:int = 300;
        public static const ORDER_TIME:Number = 0.15;
        public static const MAX_MONSTER_NUM:uint = 1000;
        
        
        public function RoGlobal()
        {
        }
    }
}