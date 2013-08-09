package inoah.game.ro.modules.login.view.mediator
{
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class LoginViewMediator extends Mediator
    {
        [Inject]
        public var view:LoginView;
        
        override public function initialize():void
        {
            addViewListener( LoginEvent.LOGIN , onLoginHandler , LoginEvent );
        }
        
        private function onLoginHandler( e:LoginEvent ):void
        {
            dispatch( e );
        }
    }
}