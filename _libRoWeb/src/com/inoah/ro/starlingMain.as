package com.inoah.ro
{
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.managers.AssetMgr;
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.managers.KeyMgr;
    import inoah.game.managers.MainMgr;
    import com.inoah.ro.managers.SprMgr;
    import com.inoah.ro.managers.TextureMgr;
    import com.inoah.ro.ui.LoginView;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class starlingMain extends Sprite
    {
        private var _loginView:LoginView;
        
        public function starlingMain()
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
            
            var displayMgr:DisplayMgr = new DisplayMgr( Starling.current.nativeStage , this );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( Starling.current.nativeStage ) );
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        
        private function loadComplete():void
        {
            _loginView = new LoginView();
            _loginView.y -= 200;
            
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
            resPathList.push( "data/novice_man_body.tpc" );
            resPathList.push( "data/2_head_man.tpc" );
            resPathList.push( "data/novice_main_knife.tpc" );
            resPathList.push( "data/novice_main_knife_ef.tpc" );
            resPathList.push( "data/poring.tpc" );
            resPathList.push( "data/poporing.tpc" );
            resPathList.push( "data/ghostring.tpc" );
            assetMgr.getResList( resPathList , function():void{} );
        }
        
        public function tick( delta:Number ):void
        {
            
        }
    }
}