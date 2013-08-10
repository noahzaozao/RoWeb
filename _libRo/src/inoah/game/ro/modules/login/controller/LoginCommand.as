package inoah.game.ro.modules.login.controller
{
    import inoah.game.ro.modules.login.service.ILoginService;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import inoah.interfaces.IUserModel;
    
    import robotlegs.bender.bundles.mvcs.Command;
    
    public class LoginCommand extends Command
    {
        [Inject]
        public var event:LoginEvent;
        
        [Inject]
        public var model:IUserModel;
        
        [Inject]
        public var service:ILoginService;
        
        override public function execute():void
        {
            service.login( event.username , event.password );
        }
    }
}