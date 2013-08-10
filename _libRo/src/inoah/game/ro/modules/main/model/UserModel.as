package inoah.game.ro.modules.main.model
{
    import inoah.interfaces.IUserInfo;
    import inoah.interfaces.IUserModel;
    import inoah.modules.core.model.BaseModel;
    
    public class UserModel extends BaseModel implements IUserModel
    {
        protected var _info:IUserInfo;
        
        public var signedIn:Boolean;
        
        public function UserModel()
        {
            super();
        }
        
        public function set info( value:IUserInfo ):void
        {
            _info = value;
        }
        public function get info():IUserInfo
        {
            return _info;
        }
    }
}