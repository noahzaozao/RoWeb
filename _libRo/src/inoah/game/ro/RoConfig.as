package inoah.game.ro
{
    import inoah.game.ro.modules.login.controller.LoginCommand;
    import inoah.game.ro.modules.login.service.ILoginService;
    import inoah.game.ro.modules.login.service.LoginService;
    import inoah.game.ro.modules.login.view.LoginView;
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    import inoah.game.ro.modules.login.view.mediator.LoginViewMediator;
    import inoah.game.ro.modules.main.controller.GameCommand;
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.AlertView;
    import inoah.game.ro.modules.main.view.ItemView;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.modules.main.view.StatusBarView;
    import inoah.game.ro.modules.main.view.StatusView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.ro.modules.main.view.mediator.AlertViewMediator;
    import inoah.game.ro.modules.main.view.mediator.ItemViewMediator;
    import inoah.game.ro.modules.main.view.mediator.MainViewMediator;
    import inoah.game.ro.modules.main.view.mediator.StatusBarViewMediator;
    import inoah.game.ro.modules.main.view.mediator.StatusViewMediator;
    import inoah.game.ro.modules.map.RoMapFactory;
    import inoah.game.ro.modules.player.RoPlayerFactory;
    import inoah.interfaces.IMapFactory;
    import inoah.interfaces.IPlayerFactory;
    import inoah.interfaces.IUserModel;
    
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
            injector.map(IUserModel).toSingleton(UserModel);
            injector.map(ILoginService).toSingleton(LoginService);
            //command
            commandMap.map(LoginEvent.LOGIN , LoginEvent).toCommand(LoginCommand);
            commandMap.map(GameEvent.SHOW_ALERT , GameEvent).toCommand(GameCommand);
            //mdeiator ui
            mediatorMap.map(LoginView).toMediator(LoginViewMediator);
            mediatorMap.map(StatusBarView).toMediator(StatusBarViewMediator);
            mediatorMap.map(MainView).toMediator(MainViewMediator);
            mediatorMap.map(AlertView).toMediator(AlertViewMediator);
            mediatorMap.map(ItemView).toMediator(ItemViewMediator);
            mediatorMap.map(StatusView).toMediator(StatusViewMediator);
            //mediator map
            //            mediatorMap.map(IScene).toMediator(ISceneMediator);
            //
            injector.map(RoGameMediator).asSingleton();
            injector.map(IMapFactory).toSingleton(RoMapFactory);
            injector.map(IPlayerFactory).toSingleton(RoPlayerFactory);
            //
            logger.info("configure RoConfig");
        }
    }
}