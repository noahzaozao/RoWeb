package com.inoah.ro
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.starling.TpcView;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.loaders.TPCLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.managers.SprMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.ui.LoginView;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class Main extends Sprite
    {
        private var _loginView:LoginView;
        private var _tpc:TpcView;
        
        public function Main()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private function addedToStageHandler(event:Event):void
        {
            MainMgr.instance;
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            var displayMgr:DisplayMgr = new DisplayMgr( Starling.current.nativeStage ,  Starling.current.root );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( Starling.current.nativeStage ) );
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        
        private function loadComplete():void
        {
            _loginView = new LoginView();
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.uiLevel.addChild( _loginView );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            onInitRes( assetMgr );
        }
        
        /**
         * 初始加载，不必等待 作为预缓冲
         * @param assetMgr
         */        
        private function onInitRes( assetMgr:AssetMgr ):void
        {
            var resPathList:Vector.<String> = new Vector.<String>();
            resPathList.push( "data/1.tpc" );
            //            resPathList.push( "data/sprite/牢埃练/赣府烹/巢/2_巢.act" );
            //            resPathList.push( "data/sprite/牢埃练/个烹/巢/檬焊磊_巢.act" );
            //            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八.act" );
            //            resPathList.push( "data/sprite/牢埃练/檬焊磊/檬焊磊_巢_窜八_八堡.act" );
            //            resPathList.push( "data/sprite/阁胶磐/poring.act" );
            //            resPathList.push( "data/sprite/阁胶磐/poporing.act" );
            //            resPathList.push( "data/sprite/阁胶磐/ghostring.act" );
            assetMgr.getResList( resPathList , function():void{} );
            
//            assetMgr.getRes( "asset/1.tpc" , onLoaded );
        }
        
        private function onLoaded( loader:ILoader ):void
        {
//            var quad:Quad = new Quad( 960 , 1 , 0xff0000 );
//            quad.x = 0;
//            quad.y = 400;
//            addChild(quad);
//            quad = new Quad( 1 , 560 , 0xff0000 );
//            quad.x = 400;
//            quad.y = 0;
//            addChild(quad);
            
            _tpc = new TpcView();
            _tpc.init(  (loader as TPCLoader).tpcData );
            addChild( _tpc );
            _tpc.play();
            _tpc.x = 400;
            _tpc.y = 400;
            _tpc.switchAction( 8 + 6 );
        }
        
        public function tick( delta:Number ):void
        {
            if( _tpc )
            {
                _tpc.tick( delta );
            }
        }
    }
}