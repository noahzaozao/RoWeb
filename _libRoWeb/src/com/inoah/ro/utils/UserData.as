package com.inoah.ro.utils
{
    import com.D5Power.utils.CharacterData;
    import com.inoah.ro.infos.UserInfo;
    
    public class UserData extends CharacterData
    {
        private var _userInfo:UserInfo;
        
        public function UserData(ispc:Boolean=true)
        {
            super(ispc);
            _userInfo = new UserInfo();
        }
        
        public function get userInfo():UserInfo
        {
            return _userInfo;
        }
    }
}