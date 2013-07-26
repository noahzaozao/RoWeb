package com.inoah.ro.ui.mainViewChildren
{
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.loaders.ILoader;
    import inoah.game.loaders.JpgLoader;
    import inoah.game.managers.AssetMgr;
    import inoah.game.managers.MainMgr;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    
    import game.ui.mainViewChildren.mapViewUI;

    public class MapView
    {
        private var _mapView:mapViewUI;
        private var _mapBg:Shape;
        
        public function MapView( mapView:mapViewUI )
        {
            _mapView = mapView;
            _mapBg = new Shape();
            _mapView.addChild( _mapBg );
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "map/1s.jpg" , onUpdateHandler );
        }
        
        private function onUpdateHandler( loader:ILoader ):void
        {
            var bitmapData:BitmapData = new BitmapData( 200, 150 , true, 0x0 );
            bitmapData = ((loader as JpgLoader).content as Bitmap).bitmapData;
            _mapBg.graphics.beginBitmapFill( bitmapData );
            _mapBg.graphics.drawRect( 0 , 0 , 190 ,190 );
            _mapBg.graphics.endFill();
            _mapBg.alpha = 0.8;
        }
        
        public function update():void
        {
            
        }
    }
}