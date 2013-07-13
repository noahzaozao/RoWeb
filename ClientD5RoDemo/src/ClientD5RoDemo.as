package
{
    import com.inoah.ro.RoGame;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.ActSprLoader;
    import com.inoah.ro.managers.SprMgr;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.uis.TopText;
    import com.inoah.ro.utils.UserData;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    
    import starling.core.Starling;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends Sprite
    {
        private var _topTxt:TopText;
        private static var _me:ClientD5RoDemo;
        private var _game:RoGame;
        //        private var npcDialogBox:NPCDialog;
        private var lastTimeStamp:int;
        private var _starling:Starling;
        
        public static function get me():ClientD5RoDemo
        {
            return _me;
        }
        
        public function ClientD5RoDemo()
        {
            addEventListener( Event.ADDED_TO_STAGE , init );
        }
        
        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE , init );
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            lastTimeStamp = getTimer();
            
            MainMgr.instance;
            var assetMgr:AssetMgr = new AssetMgr();
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, assetMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            //pretends to be an iPhone Retina screen
            //            DeviceCapabilities.dpi = 326;
            //            DeviceCapabilities.screenPixelWidth = 960;
            //            DeviceCapabilities.screenPixelHeight = 640;
            
            //            Starling.handleLostContext = true;
            //            Starling.multitouchEnabled = true;
            //            _starling = new Starling(Main, stage);
            //            _starling.enableErrorChecking = false;
            //            _starling.showStats = true;
            //            _starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
            //            _starling.start();
            
            stage.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
            
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_1207.act" );
            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            resPathList.push( "data/sprite/阁胶磐/poporing.act" );
            resPathList.push( "data/sprite/阁胶磐/ghostring.act" );
            resPathList.push( "data/sprite/酒捞袍/lk_aurablade.act" );
            resPathList.push( "data/sprite/酒捞袍/lk_spiralpierce.act" );
            assetMgr.getResList( resPathList , onInitLoadComplete );
            
            TopText.init();
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
            
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
        }
        
        protected function onRightClick( e:MouseEvent):void
        {
            
        }
        
        private function onInitLoadComplete( loader:ActSprLoader = null ):void
        {
            Global.userdata = new UserData();
            Global.userdata.getCanSeeMission(1);
            _me = this;
            _game = new RoGame('map1',stage , 0 );
            addChild(_game);
            addChild( TopText.textField );
            addChild( TopText.tipTextField );
            
            RoGame.inited = true;
        }
        
        protected function onEnterFrameHandler( e:Event):void
        {
            var timeNow:uint = getTimer();
            var delta:Number = (timeNow - lastTimeStamp) / 1000;
            lastTimeStamp = timeNow;
            TopText.tick( delta );
            if( _game )
            {
                _game.tick( delta );
            }
            //            var root:Main = Starling.current.root as Main;
            //            if( root )
            //            {
            //                root.tick( delta );
            //            }
        }
    }
}