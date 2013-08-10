package inoah.game.ro.modules.login.service
{
    import inoah.interfaces.IUserModel;

    public class LoginService implements ILoginService
    {
        [Inject]
        public var userModel:IUserModel;
        
        public function LoginService()
        {
            
        }
        
        public function login( username:String , password:String ):void
        {
            trace( "LoginService: " + username , password );
        }
    }
}