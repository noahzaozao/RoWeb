package com.inoah.ro.ui.mainViewChildren
{
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.loaders.ILoader;
    import com.inoah.ro.loaders.JpgLoader;
    import com.inoah.ro.managers.AssetMgr;
    import com.inoah.ro.managers.MainMgr;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    
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
            assetMgr.getRes( "asset/tiles/1/s.jpg" , onUpdateHandler );
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