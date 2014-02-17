package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    [SWF(width="1280",height="768",frameRate="60",backgroundColor="#000000")]
    public class MapTest extends Sprite
    {
        public var mapContainer:Sprite;
        public var mapBg:Bitmap;
        public var mapBgSp:Shape;
        public var lightBlockSp:Shape;
        public var keyMap:Dictionary;
        public var mapViewRect:Shape;
        
        public var mapWidth:int = 3200;
        public var mapHeight:int = 1600;
        public var blockW:int = 64;
        public var blockH:int = 32;
        
        private var m_mapWid:int = 0;
        private var m_mapHei:int = 0;
        
        private var m_orgX:Number = 0;
        private var m_orgY:Number = 0;
        
        private var m_xincX:Number = 0;
        private var m_xincY:Number = 0;
        private var m_yincX:Number = 0;
        private var m_yincY:Number = 0;
        
        public function MapTest()
        {
            var count:Number = 50 + 50;
            var mapRange:Rectangle = new Rectangle( 0 , 0 , 3200 , 1600 );
            m_orgX = mapRange.left + mapRange.width / count;
            m_orgY = mapRange.top + 50 * mapRange.height / count;
            
            m_xincX = mapRange.width / count;
            m_xincY = - mapRange.height / count;
            m_yincX = mapRange.width / count;
            m_yincY = mapRange.height / count;
            
            mapContainer = new Sprite();
            addChild( mapContainer );
            
            mapBgSp = new Shape();
            for( var xx:int = 0; xx < 50 ; xx ++ )
            {
                for( var yy:int = 0; yy< 50; yy++)
                {
                    drawTile( mapBgSp ,  GridToView( xx , yy ).x , GridToView( xx,  yy).y );
                }
            }
            mapBg = new Bitmap( new BitmapData( 3200 , 1600 , true , 0x0 ) );
            mapContainer.addChild( mapBg );
            mapBg.bitmapData.draw( mapBgSp );
            
            mapViewRect = new Shape();
            mapViewRect.graphics.beginFill( 0x0 , 0 );
            mapViewRect.graphics.lineStyle( 1 , 0x00ff00 );
            mapViewRect.graphics.drawRect( 0 , 0 , 960 , 640 );
            mapViewRect.graphics.endFill();
            addChild( mapViewRect );
            
            keyMap = new Dictionary();
            stage.addEventListener( KeyboardEvent.KEY_DOWN , onKeyHandler );
            stage.addEventListener( KeyboardEvent.KEY_UP , onKeyHandler );
            stage.addEventListener( Event.ENTER_FRAME , onEnterFrame );
        }
        
        protected function onEnterFrame( e:Event):void
        {
            var speed:int = 5;
            if( keyMap[Keyboard.A] )
            {
                mapContainer.x+=speed;
                if(mapContainer.x > 0)
                {
                    mapContainer.x = 0;
                }
            }
            else if( keyMap[Keyboard.D] )
            {
                mapContainer.x-=speed;
                if(mapContainer.x < 960 - mapWidth)
                {
                    mapContainer.x = 960 - mapWidth;
                }
            }
            if( keyMap[Keyboard.W] )
            {
                mapContainer.y+=speed;
                if(mapContainer.y > 0)
                {
                    mapContainer.y = 0;
                }
            }
            else if( keyMap[Keyboard.S] )
            {
                mapContainer.y-=speed;
                if(mapContainer.y < 640 - mapHeight )
                {
                    mapContainer.y = 640 - mapHeight;
                }
            }
            
            //屏幕中心点sPos
            var centerPos:Point = new Point( -mapContainer.x + 960 / 2 , -mapContainer.y + 640 / 2 );
            //屏幕中心点bPos
            var lightBlock:Point = ViewToGrid( centerPos.x, centerPos.y );
            if( !lightBlockSp )
            {
                lightBlockSp = new Shape();
                mapContainer.addChild(lightBlockSp);
            }
            else
            {
                lightBlockSp.graphics.clear();
                
                var cp:Point = ViewToGrid( centerPos.x , centerPos.y );
                trace( cp );
                var redrawW:Number = 7;
                var redrawH:Number = 10;
                var area:int = redrawH + redrawW;;
                for(var _XX :int = cp.x - area; _XX  <= cp.x + area ; _XX ++)
                {
                    for(var _YY :int = cp.y - area ; _YY  <= cp.y + area ; _YY ++)
                    {
                        if(_XX  >= 0 && _XX  < 50 && _YY  >= 0 && _YY  < 50 )
                        {
                            if(Math.abs((_YY  - cp.y - _XX  + cp.x) / 2) <= redrawH && Math.abs((_XX  - cp.x + _YY  - cp.y) / 2) <= redrawW)
                            {
                                var pos:Point = GridToView( _XX, _YY);
                                drawTile( lightBlockSp , pos.x , pos.y , 0x999999 );
                            }
                        }
                    }
                }
                
                var drawBlockPos:Point = GridToView( lightBlock.x , lightBlock.y );
                drawTile( lightBlockSp , drawBlockPos.x , drawBlockPos.y , 0x00ff00 );
            }            
        }
        
        protected function onKeyHandler( e:KeyboardEvent):void
        {
            if( e.type == KeyboardEvent.KEY_DOWN )
            {
                keyMap[e.keyCode] = true;
            }
            else if( e.type == KeyboardEvent.KEY_UP )
            {
                keyMap[e.keyCode] = false;
            }
        }
        
        private function drawTile( shape:Shape, x:int , y:int , color:int = -1 ):void
        {
            if(color!= -1)
            {
                shape.graphics.beginFill( color , 1 );
            }
            else
            {
                shape.graphics.beginFill( 0x0 , 0 );
            }
            shape.graphics.lineStyle( 1 , 0xffffff );
            shape.graphics.moveTo( x , y - blockH/2 );
            shape.graphics.lineTo( x + blockW/2 , y );
            shape.graphics.lineTo( x , y + blockH/2 );
            shape.graphics.lineTo( x - blockW/2, y );
            shape.graphics.lineTo( x , y - blockH/2 );
            shape.graphics.endFill();
        }
        
        //重设地图原点位置的偏移（用于地图滑动）
        public function SetOrgin( xpos:Number, ypos:Number ):void
        {
            m_orgX = xpos;
            m_orgY = ypos;
        }
        
        //地图网格坐标转换到屏幕显示坐标（用于提供给描画用）
        public function GridToView( xpos:int, ypos:int ):Point
        {
            var pos:Point = new Point();
            
            pos.x = m_orgX + m_xincX * xpos + m_yincX * ypos;
            pos.y = m_orgY + m_xincY * xpos + m_yincY * ypos;
            
            return pos;
        }
        
        //屏幕坐标转换到地图网格坐标（比如在即时战略中用于确定鼠标点击的是哪一块）
        public function ViewToGrid( xpos:Number, ypos:Number ):Point
        {
            var pos:Point = new Point();
            
            var coordX:Number = xpos - m_orgX;
            var coordY:Number = ypos - m_orgY;
            
            pos.x = ( coordX * m_yincY - coordY * m_yincX ) / ( m_xincX * m_yincY - m_xincY * m_yincX );
            pos.y = ( coordX - m_xincX * pos.x ) / m_yincX;
            
            pos.x = Math.round( pos.x );
            pos.y = Math.round( pos.y );
            
            return pos;
        }
        
        //判断网格坐标是否在地图范围内
        public function LegalGridCoord( xpos:int, ypos:int ):Boolean
        {
            if ( xpos < 0 || ypos < 0 || xpos >= m_mapWid || ypos >= m_mapHei )
            {
                return false;
            }
            
            return true;
        }
        
        //判断屏幕坐标是否在地图范围内
        public function LegalViewCoord( xpos:Number, ypos:Number ):Boolean
        {
            var pos:Point = ViewToGrid( xpos, ypos );
            
            return LegalGridCoord( pos.x, pos.y );
        }
        
        //格式化屏幕坐标，即返回最接近该坐标的一个格子的标准屏幕坐标（通常用于在地图中拖动建筑物对齐网格用）
        public function FormatViewPos( xpos:Number, ypos:Number ):Point
        {
            var pos:Point = ViewToGrid( xpos, ypos );
            
            if ( LegalGridCoord( pos.x, pos.y ) )
            {
                pos = GridToView( pos.x, pos.y );
            }else
            {
                pos.x = xpos;
                pos.y = ypos;
            }
            
            return pos;
        }
    }
}