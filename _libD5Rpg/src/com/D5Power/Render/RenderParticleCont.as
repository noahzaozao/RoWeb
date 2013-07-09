package com.D5Power.Render
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    public class RenderParticleCont extends Render
    {
        public function RenderParticleCont()
        {
            super();
        }
        
        override public function render(o:GameObject):void
        {
            var target:Point = WorldMap.me.getScreenPostion(o.PosX,o.PosY);
            o.x = target.x;
            o.y = target.y;
        }
    }
}