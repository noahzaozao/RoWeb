package inoah.game.ro.modules.login.service
{
    import inoah.game.ro.modules.main.model.UserModel;

    public class LoginService implements ILoginService
    {
        [Inject]
        public var userModel:UserModel;
        
        public function LoginService()
        {
            
        }
        
        public function login( username:String , password:String ):void
        {
            trace( "LoginService: " + username , password );
        }
    }
}