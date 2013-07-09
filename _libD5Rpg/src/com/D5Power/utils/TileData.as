package com.D5Power.utils
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 地图拼接数据
     * @auther D5Power
     */ 
    public class TileData
    {
        private var _res:Vector.<BitmapData>;
        private var _map:Array;
        private var _tileWidth:uint;
        private var _tileHeight:uint;
        
        private var _maxTileX:uint;
        private var _maxTileY:uint;
        
        public function TileData(w:uint,h:uint)
        {
            _tileWidth = w;
            _tileHeight = h;
        }
        
        public function dispose():void
        {
            while(_res.length) _res.shift().dispose();
            _map.splice(0,_map.length);
        }
        
        public function get tileWidth():uint
        {
            return _tileWidth;
        }
        
        public function get tileHeight():uint
        {
            return _tileHeight;
        }
        
        public function setupMap(w:uint,h:uint):void
        {
            _maxTileX = w;
            _maxTileY = h;
            _map = new Array();
            var py:uint;
            var px:uint;
            for(py=0;py<h;py++)
            {
                var data:Array = new Array();
                for(px=0;px<w;px++)
                {
                    data.push([0,0,0,0]);
                }
                _map.push(data);
            }
        }
        
        /**
         * 打开某点
         */ 
        public function openPoint(px:int,py:int):void
        {
            if(px<0 || py<0 || px>=_maxTileX || py>=_maxTileY) return;
            
            if(_map[py][px] && _map[py][px][3]!=4) _map[py][px][3]+=4;
            if(_map[py][px+1] && _map[py][px+1][1]!=8) _map[py][px+1][1]+=8;
            
            
            if(_map[py+1][px] && _map[py+1][px][2]!=1) _map[py+1][px][2]+=1;
            if(_map[py+1][px+1] && _map[py+1][px+1][0]!=2) _map[py+1][px+1][0]+=2;
        }
        
        /**
         * 向某个区域进加运算
         */ 
        public function addArea(startx:int,starty:int,data:Array):void
        {
            if(data.length==0 || !data[0].length)
            {
                trace("[TileData] 无效的开启数据");
                return;
            }
            
            
            var ymax:uint = data.length+starty;
            var xmax:uint = data[0].length+startx;
            
            var l:uint;
            var c:uint;
            
            for(starty;starty<ymax;starty++)
            {
                if(starty<0 || _map[starty]==null) continue;
                for(startx;startx<xmax;startx++)
                {
                    if(startx<0 || _map[startx]==null) continue;
                    if(data[l][c].length!=4)
                    {
                        trace("[TileData] 无效的区块数据");
                    }
                    if(_map[starty][startx][0]!=data[l][c][0] && _map[starty][startx][0]<15) _map[starty][startx][0]+=data[l][c][0];
                    if(_map[starty][startx][1]!=data[l][c][1] && _map[starty][startx][1]<15) _map[starty][startx][1]+=data[l][c][1];
                    if(_map[starty][startx][2]!=data[l][c][2] && _map[starty][startx][2]<15) _map[starty][startx][2]+=data[l][c][2];
                    if(_map[starty][startx][3]!=data[l][c][3] && _map[starty][startx][3]<15) _map[starty][startx][3]+=data[l][c][3];
                    c++;
                }
                l++;
            }
        }
        
        /**
         * 以Bitmap的形式进行更新
         */ 
        public function updateBitmap(resBD:BitmapData,startx:uint,starty:uint):void
        {		
            resBD.fillRect(resBD.rect,0);
            
            var py:uint;
            var px:uint;
            var l:uint;
            var c:uint;
            
            var maxx:uint = Math.ceil(resBD.width/_tileWidth);
            var maxy:uint = Math.ceil(resBD.height/_tileHeight);
            
            var rect:Rectangle = new Rectangle(0,0,_tileWidth,_tileHeight);
            var p:Point = new Point();
            
            for(l=0;l<maxy;l++)
            {
                py = starty+l;
                if(_map[py]==null) continue;
                for(c=0;c<maxx;c++)
                {
                    px = startx+c;
                    if(_map[py][px]==null) continue;
                    var b:uint=_map[py][px][0]+_map[py][px][1]+_map[py][px][2]+_map[py][px][3];
                    rect.x = px*_tileWidth;
                    rect.y = py*_tileHeight;
                    
                    p.x = c*_tileWidth;
                    p.y = l*_tileHeight;
                    
                    if(b==0) resBD.copyPixels(_res[0],_res[0].rect,p,null,null,true);
                    if(b>15) b=15;
                    resBD.copyPixels(_res[b],_res[b].rect,p,null,null,true);
                }
            }
        }
        
        /**
         * 以Shape的方式进行更新
         */ 
        public function updateShape(displayer:Shape,startx:uint,starty:uint):void
        {
            
        }
        
        public function setupRes(res:BitmapData):void
        {
            var py:uint;
            var px:uint;
            var xMax:uint = 4;
            var yMax:uint = 4;
            var bitmap:BitmapData;
            var p:Point = new Point();
            var rect:Rectangle = new Rectangle(0,0,_tileWidth,_tileHeight);
            
            _res = new Vector.<BitmapData>(xMax*yMax);
            for(px = 0;px<xMax;px++)
            {
                for(py = 0;py < yMax;py++)
                {
                    bitmap = new BitmapData(_tileWidth,_tileHeight,true,0);
                    rect.x = px*_tileWidth;
                    rect.y = py*_tileHeight;
                    bitmap.copyPixels(res,rect,p,null,null,true);
                    _res[px*xMax+py] = bitmap;
                }
            }
        }
        
        
    }
}