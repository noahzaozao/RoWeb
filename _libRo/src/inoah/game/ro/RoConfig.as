package inoah.game.ro
{
    import inoah.game.ro.mediators.views.RoGameMediator;
    import inoah.game.ro.modules.login.controller.LoginCommand;
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import inoah.game.ro.modules.login.view.mediator.LoginViewMediator;
    import inoah.game.ro.modules.main.controller.GameCommand;
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.ro.modules.main.view.mediator.MainViewMediator;
    
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    public class RoConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var mediatorMap:IMediatorMap;

        [Inject]
        public var commandMap:IEventCommandMap;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var contextView:ContextView;
        
        public function configure():void
        {
            //model
            injector.map(UserModel).asSingleton();
            //command
            commandMap.map(LoginEvent.LOGIN , LoginEvent).toCommand(LoginCommand);
            commandMap.map(GameEvent.SHOW_ALERT , GameEvent).toCommand(GameCommand);
            //mdeiator
            mediatorMap.map(LoginView).toMediator(LoginViewMediator);
            mediatorMap.map(MainView).toMediator(MainViewMediator);
            //
            injector.map(RoGameMediator).asSingleton();
            //
            logger.info("configure RoConfig");
        }
    }
}