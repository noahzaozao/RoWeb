package com.inoah.ro.managers
{
    public class MainMgr extends BaseMgr
    {
        protected static var _instance:MainMgr;
        
        public static function get instance() : MainMgr
        {
            if (_instance == null)
            {
                _instance = new MainMgr();
            }
            return _instance;
        }
        
        //        private var _userData:UserData;
        //        
        //        public function MainMgr()
        //        {
        //            super();
        //            _userData = new UserData();
        //        }
        //        
        //        public function get appData():UserData
        //        {
        //            return _userData;
        //        }
        
        //        public static function get textureMgr():TextureMgr
        //        {
        //            return instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
        //        }
    }
}