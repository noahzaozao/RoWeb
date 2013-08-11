package
{
    import com.bit101.components.Style;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import inoah.core.CoreBundle;
    import inoah.core.Global;
    import inoah.gameEditor.EditorMenu;
    import inoah.gameEditor.editorMain;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    [SWF(width="960",height="660",frameRate="60",backgroundColor="#000000")]
    public class GameEditor extends Sprite
    {
        private var _lastTimeStamp:Number;
        
        private var _context:IContext;
        
        private var _editorMain:editorMain;
        
        public function GameEditor()
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
            
            //            Global.IS_MOBILE = true;
            Global.ENABLE_LUA = true;
            Global.SCREEN_W = stage.stageWidth;
            Global.SCREEN_H = stage.stageHeight;
            
            _context = new Context()
                .install( MVCSBundle )
                .install( CoreBundle )
//                .configure( RoConfig )
                .configure(EditorConfig)
                .configure( new ContextView( this ) );
            _context.initialize( onInitialize );
            
            Style.embedFonts = false;
            Style.fontSize =  14;
            Style.setStyle( Style.DARK );
        }
        
        private function onInitialize():void
        {
            stage.nativeWindow.menu = _context.injector.getInstance(EditorMenu);
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            var starling:Starling = new Starling( editorMain, stage , null , null , "auto", "baseline" );
            starling.enableErrorChecking = false;
            starling.showStats = true;
            starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            starling.start();
            
            _lastTimeStamp = new Date().time;
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
            stage.addEventListener( Event.RESIZE , onResize );
        }
        
        protected function onResize( e:Event ):void
        {
            if( _editorMain )
            {
                _editorMain.onResize( stage.stageWidth, stage.stageHeight );
            }
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _editorMain )
            {
                _editorMain.tick( delta );
            }
            else if( Starling.current && Starling.current.root )
            {
                _editorMain = Starling.current.root as editorMain;
                onStarlingInited();
            }
        }
        
        private function onStarlingInited():void
        {
            _context.injector.injectInto(_editorMain);
            _editorMain.initialize();
        }
    }
}