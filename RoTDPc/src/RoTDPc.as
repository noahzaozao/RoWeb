package
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.core.Global;
    import inoah.game.td.TDConfig;
    import inoah.game.td.TDGameMediator;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.assetMgrExtension.AssetMgrExtension;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.displayMgrExtension.DisplayerMgrExtension;
    import robotlegs.bender.extensions.keyMgrExtension.KeyMgrExtension;
    import robotlegs.bender.extensions.sprMgrExtension.SprMgrExtension;
    import robotlegs.bender.extensions.tdMapMgrExtension.TDMapMgrExtension;
    import robotlegs.bender.extensions.textureMgrExtension.TextureMgrExtension;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.LogLevel;
    import robotlegs.bender.framework.impl.Context;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class RoTDPc extends VersionSprite
    {
        private var _lastTimeStamp:Number;
        
        private var _context:IContext;
        
        private var _roGameMediator:TDGameMediator;
        
        public function RoTDPc()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            
            stage.frameRate = 60;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            tabChildren = false;
            tabEnabled = false;
            
            Global.IS_MOBILE = false;
            Global.ENABLE_LUA = false;
            Global.SCREEN_W = stage.stageWidth;
            Global.SCREEN_H = stage.stageHeight;
            
            Global.MAP_W = 1920;
            Global.MAP_H = 960;
            Global.TILE_W = 128;
            Global.TILE_H = 64;
            Global.redrawW = 8;
            Global.redrawH = 8;
            
            _context = new Context()
                .install( MVCSBundle );
            _context.logLevel = LogLevel.DEBUG;
            _context.install(
                AssetMgrExtension,
                TextureMgrExtension,
                SprMgrExtension,
                DisplayerMgrExtension,
                KeyMgrExtension,
                TDMapMgrExtension
            );
            
            _context.configure( TDConfig )
                .configure( new ContextView( this ) )
                .initialize( onInitialize );
        }
        
        private function onInitialize():void
        {
            _roGameMediator = _context.injector.getInstance(TDGameMediator) as TDGameMediator;
            _roGameMediator.initialize();
            
            _lastTimeStamp = new Date().time;
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _roGameMediator )
            {
                _roGameMediator.tick( delta );
            }
        }
    }
}