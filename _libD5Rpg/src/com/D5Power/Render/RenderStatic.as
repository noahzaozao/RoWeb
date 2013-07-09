package com.D5Power.Render
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.IRender;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    /**
     * 用于处理只有一帧的物体
     */ 
    public class RenderStatic extends Render
    {
        public function RenderStatic()
        {
            super();
        }
        
        override public function render(o:GameObject):void
        {
            var m:IRender = o as IRender;
            var target:Point = WorldMap.me.getScreenPostion(o.PosX,o.PosY);
            o.x = target.x;
            o.y = target.y;
            
            if(o.RenderUpdated) return;
            //if(o.graphicsRes==null) return;
            
            
            o.RenderUpdated = true;
            
            var p:Point = m.isOver ? new Point(o.PosX,o.PosY) : target;
            
            if(m.rendFly!=null)
            {
                p.x+=m.rendFly.x;
                p.y+=m.rendFly.y;
            }
            
            if(m.colorPan!=null)
            {
                //o.graphicsRes.bitmap.colorTransform(o.graphicsRes.bitmap.rect,m.colorPan);
            }
            
            
            super.render(o);
            draw(o,0,0);
        }
    }
}