package com.inoah.ro
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.loaders.TPCLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.displays.starling.TpcView;
    
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class Main extends Sprite
    {
        private var _tpc:TpcView;
        public function Main()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private function addedToStageHandler(event:Event):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "asset/1.tpc" , onLoaded );
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