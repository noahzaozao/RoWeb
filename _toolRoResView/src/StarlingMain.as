package
{
    import flash.utils.ByteArray;
    
    import consts.AppConsts;
    
    import inoah.core.viewModels.actSpr.ActSprView;
    
    import panels.DisplayEvent;
    import panels.SidePanel;
    import panels.ViewPanel;
    
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    
    import texturePackage.sequenceOperator.OperateArea;
    
    public class StarlingMain extends Sprite
    {
        [Inject]
        public var injector:IInjector;
        
        public static var tpcData:ByteArray;
        public static var filePath:String;
        public static var actSprView:ActSprView;
        private var _sidePanel:SidePanel;
        private var _viewPanel:ViewPanel;
        private var _texturePkgPanel:OperateArea;
        
        public function StarlingMain()
        {
            super();
        }
        
        public function initialize():void
        {
            _sidePanel = new SidePanel( Starling.current.nativeOverlay, 0, 30 );
            _sidePanel.setSize( 200, 570 );
            _sidePanel.addEventListener( DisplayEvent.SHOW, onShowHandler );
            injector.injectInto(_sidePanel);
            
            _viewPanel = new ViewPanel( Starling.current.nativeOverlay, AppConsts.SIDE_PANEL_WIDTH, 30 );
            _viewPanel.setSize( 470, 570 );
            injector.injectInto(_viewPanel);

            _texturePkgPanel = new OperateArea( Starling.current.nativeOverlay );
            _texturePkgPanel.setSize( 960 , 560 );
            injector.injectInto(_texturePkgPanel);
        }
        
        public function tick( delta:Number ):void
        {
            if( _viewPanel )
            {
                _viewPanel.tick( delta );
            }
        }
        
        protected function onShowHandler(e:DisplayEvent):void
        {
            filePath = e.data;
            _viewPanel.showAct( e.data, e.switchType );
//            e.data e.switchType;
        }
    }
}