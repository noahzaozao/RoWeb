package inoah.game.ro.modules.main.model
{
    import inoah.core.infos.UserInfo;
    import inoah.modules.core.model.BaseModel;
    
    public class UserModel extends BaseModel
    {
        public var info:UserInfo;
        public var signedIn:Boolean;
        
        public function UserModel()
        {
            super();
        }
    }
}