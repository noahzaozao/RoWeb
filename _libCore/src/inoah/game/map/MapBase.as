package inoah.game.map
{
    import flash.display.Bitmap;
    import flash.geom.Point;
    
    import inoah.data.map.MapInfo;
    import inoah.data.map.MapTileSetInfo;
    import inoah.game.Global;
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.interfaces.IMapLevel;
    import inoah.game.loaders.ILoader;
    import inoah.game.loaders.JpgLoader;
    import inoah.game.managers.AssetMgr;
    import inoah.game.managers.MainMgr;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    /**
     *  
     * @author inoah
     */    
    public class MapBase
    {
        protected var _mapInfo:MapInfo;
        protected var _container:DisplayObjectContainer;
        
        protected var _currentResIndexList:Vector.<String>;
        protected var _currentResList:Vector.<Bitmap>;
        protected var _currentTextureAtlasIndexList:Vector.<int>;
        protected var _currentTextureAtlasList:Vector.<TextureAtlas>;
        
        protected var _levelList:Vector.<IMapLevel>;
        
        protected var _mapImageList:Vector.<Image>;
        
        public function MapBase(  container:DisplayObjectContainer )
        {
            _container = container;
            _container.x = - Global.TILE_W * 4;
            _levelList = new Vector.<IMapLevel>();
            _currentResIndexList = new Vector.<String>();
            _currentResList = new Vector.<Bitmap>();
            _currentTextureAtlasIndexList = new Vector.<int>();
            _currentTextureAtlasList = new Vector.<TextureAtlas>();
            _mapImageList = new Vector.<Image>();
        }
        
        public function init( mapInfo:MapInfo ):void
        {
            _mapInfo = mapInfo;
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var resList:Vector.<String> = new Vector.<String>();
            var len:int = _mapInfo.tilesets.length;
            for( var i:int =0;i<len;i++)
            {
                resList.push( "map/" + _mapInfo.tilesets[i].image );
                _currentResIndexList.push( "map/" + _mapInfo.tilesets[i].image );
            }
            assetMgr.getResList( resList , onLoadMapRes );
        }
        
        private function onLoadMapRes( loader:ILoader ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var tileSetList:Vector.<MapTileSetInfo> = _mapInfo.tilesets;
            var tileSet:MapTileSetInfo;
            var len:int = tileSetList.length;
            var iCount:int = 1;
            _currentTextureAtlasIndexList.push( int.MAX_VALUE );
            for( var i:int =0;i<len;i++)
            {
                tileSet = tileSetList[i];
                //get bitmap
                _currentResList.push( (assetMgr.getRes( "map/" + tileSet.image ,null ) as JpgLoader).content as Bitmap );
                //get textureAtlas
                var texture:Texture = Texture.fromBitmap( _currentResList[i], false );
                var atlasXml:XML = XML('<texture id="'+tileSet.name+'" width="'+2048+'" height="'+2048+'"></texture>');
                var sequenceCount:int = tileSet.imagewidth / tileSet.tilewidth * tileSet.imageheight / tileSet.tileheight;
                var subTexture:XML;
                var sx:int = 0;
                var sy:int = 0;
                var soffx:int = 0;
                var soffy:int = 0;
                for(var j:int = 0; j<sequenceCount; j++)
                {
                    subTexture = XML(<SubTexture />);
                    _currentTextureAtlasIndexList[iCount] = i;
                    subTexture.@name =  iCount.toString();
                    iCount ++;
                    subTexture.@width = tileSet.tilewidth;
                    subTexture.@height = tileSet.tileheight;
                    subTexture.@x = sx;
                    subTexture.@y = sy;
                    subTexture.@frameX = 0;
                    subTexture.@frameY = 0;
                    subTexture.@frameWidth = tileSet.tilewidth;
                    subTexture.@frameHeight = tileSet.tileheight;
                    atlasXml.appendChild(subTexture);
                    sx += tileSet.tilewidth;
                    if( sx >= tileSet.imagewidth )
                    {
                        sx = 0
                        sy += tileSet.tileheight;
                    }
                }
                _currentTextureAtlasList.push( new TextureAtlas( texture, atlasXml ) );
            }
            
            len = _mapInfo.layers.length;
            for( i=0;i<len;i++)
            {
                if( _mapInfo.layers[i].type == "tilelayer" )
                {
                    drawTile( i );
                }
                else if( _mapInfo.layers[i].type == "objectgroup" )
                {
//                    drawObject( i );
                }
            }
        }
        
        private function drawObject( index:int ):void
        {
            var bx:Number;
            var by:Number;
            var bw:Number;
            var bh:Number;
            //mapblocks
            var mbw:Number = _mapInfo.layers[index].width;
            var mbh:Number = _mapInfo.layers[index].height;
            //mapheight
            var w:int = mbw * Global.TILE_W;
            var h:int = mbh * Global.TILE_H / 2;
            
            var textureIndex:int;
            var len:int = _mapInfo.layers[ index ].objects.length;
            var image:Image;
            for( var i:int=0;i< len;i++)
            {
                if( _mapInfo.layers[index].objects[i].visible == false )
                {
                    continue;
                }
                //tileblockxy
                bx = _mapInfo.layers[ index ].objects[ i ].x / ( Global.TILE_W / 2 );
                by = _mapInfo.layers[ index ].objects[ i ].y / ( Global.TILE_H / 2 );
                //tileblocks
                bw = _mapInfo.layers[ index ].objects[ i ].width;
                bh = _mapInfo.layers[ index ].objects[ i ].height;
                
                textureIndex = _currentTextureAtlasIndexList[ _mapInfo.layers[ index ].objects[ i ].gid ];
                image = new Image( _currentTextureAtlasList[textureIndex].getTexture( _mapInfo.layers[ index ].objects[ i ].gid.toString() ) );
                image.touchable = false;
                
                if( bx > by )
                {
                    image.x = w / 2 * ( 1 + bx / mbw - by / mbh ) - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh  + Global.TILE_H / 2;
                }
                else if( bx < by )
                {
                    image.x = w / 2 * ( 1 + bx / mbw - by / mbh ) - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh + Global.TILE_H / 2;
                }
                else
                {
                    image.x = w / 2 - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh + Global.TILE_H / 2;
                }
                _container.addChild( image );
            }
        }
        
        private function drawTile( index:int ):void
        {
            var textureIndex:int;
            
            var mapDataArr:Vector.<uint> = _mapInfo.layers[index].data;
            var bw:int = _mapInfo.layers[index].width;
            var bh:int = _mapInfo.layers[index].height;
            var w:int = _mapInfo.layers[index].width * Global.TILE_W;
            var h:int = _mapInfo.layers[index].height * Global.TILE_H;
            
            var pointList:Vector.<Point> = new Vector.<Point>();
            pointList.push( new Point() );
            pointList.push( new Point() );
            pointList.push( new Point() );
            pointList.push( new Point() );
            
            var tmpRenderTexture:Vector.<RenderTexture> = new Vector.<RenderTexture>();
            tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            
            var image:Image;
            //0-25 , 25-50
            for( var i:int = 0 ;i< bh ;i++)
            {
                for( var j:int = 0;j< bw ;j++)
                {
                    textureIndex = _currentTextureAtlasIndexList[ mapDataArr[ j + i * bw ]];
                    image = new Image( _currentTextureAtlasList[textureIndex].getTexture( mapDataArr[ j + i * bw ].toString() ) );
                    //                    image.x =w / 2 - ( i + 1 ) * Global.TILE_W / 2 + j * Global.TILE_W / 2;
                    //                    image.y = i * Global.TILE_H / 2 + j * Global.TILE_H / 2;
                    if( j < 25 && i < 25 )
                    {
                        image.x =w / 4 - ( i + 1 ) * Global.TILE_W / 2 + j * Global.TILE_W / 2;
                        image.y = i * Global.TILE_H / 2 + j * Global.TILE_H / 2;
                        tmpRenderTexture[0].draw( image );
                    }
                    else if( j >= 25 && i < 25 )
                    {
                        image.x =w / 4 - ( i + 1 ) * Global.TILE_W / 2 + ( j - 25 ) * Global.TILE_W / 2;
                        image.y = i * Global.TILE_H / 2 + ( j - 25 ) * Global.TILE_H / 2;
                        tmpRenderTexture[1].draw( image );
                    }
                    else if( j < 25 && i >= 25 )
                    {
                        image.x =w / 4 - ( i + 1 - 25 ) * Global.TILE_W / 2 +  j * Global.TILE_W / 2;
                        image.y = ( i - 25 ) * Global.TILE_H / 2 + j * Global.TILE_H / 2;
                        tmpRenderTexture[2].draw( image );
                    }
                    else if( j>= 25 && i >= 25 )
                    {
                        image.x =w / 4 - ( i + 1 - 25 ) * Global.TILE_W / 2 + ( j - 25 ) * Global.TILE_W / 2;
                        image.y = ( i - 25 ) * Global.TILE_H / 2 + ( j - 25 ) * Global.TILE_H / 2;
                        tmpRenderTexture[3].draw( image );
                    }
                }
            }
            _mapImageList[ 0 ] = new Image( tmpRenderTexture[0] );
            _mapImageList[ 0 ].touchable = false;
            _mapImageList[ 0 ].x = 800;
            _mapImageList[ 0 ].y = 0;
            _container.addChild( _mapImageList[ 0 ] );
            _mapImageList[ 1 ] = new Image( tmpRenderTexture[1] );
            _mapImageList[ 1 ].touchable = false;
            _mapImageList[ 1 ].x = 1600;
            _mapImageList[ 1 ].y = 400;
            _container.addChild( _mapImageList[ 1 ] );
            _mapImageList[ 2 ] = new Image( tmpRenderTexture[2] );
            _mapImageList[ 2 ].touchable = false;
            _mapImageList[ 2 ].x = 0;
            _mapImageList[ 2 ].y = 400;
            _container.addChild( _mapImageList[ 2 ] );
            _mapImageList[ 3 ] = new Image( tmpRenderTexture[3] );
            _mapImageList[ 3 ].touchable = false;
            _mapImageList[ 3 ].x = 800;
            _mapImageList[ 3 ].y = 800;
            _container.addChild( _mapImageList[ 3 ] );
        }
    }
}