package com.D5Power.Render
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.Effects.EffectObject;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    
    /**
     * 效果渲染器
     */ 
    public class RenderEffect extends Render
    {
        public function RenderEffect()
        {
            super();
        }
        
        override public function render(o:GameObject):void
        {
            var m:EffectObject = o as EffectObject;
            if(m.graphicsRes.frameWidth==0) return;
            var target:Point = WorldMap.me.getScreenPostion(o.PosX,o.PosY);
            
            if(m.colorPan!=null)
            {
                //m.graphicsRes.bitmap.colorTransform(m.graphicsRes.bitmap.rect,m.colorPan);
            }
            m.x = target.x;
            m.y = target.y;
            
            super.render(m);
            
            draw(m,m.renderLine,m.renderFrame);
        }
    }
}