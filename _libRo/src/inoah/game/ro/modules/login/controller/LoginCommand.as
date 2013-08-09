package inoah.game.ro.modules.login.controller
{
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class LoginCommand extends Command
    {
        [Inject]
        public var event:LoginEvent;
        
        [Inject]
        public var model:UserModel;
        
        override public function execute():void
        {
            model.signedIn = true;
        }
    }
}