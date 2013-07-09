package com.D5Power.Render
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.map.WorldMap;
    
    import flash.geom.Point;
    
    public class RenderNCharacter extends RenderAllCharacter
    {
        /**
         * 是否镜像
         */ 
        private var ismirror:Boolean = false;
        
        public function RenderNCharacter()
        {
            super();
        }
        
        override public function render(o:GameObject):void
        {
            var c:NCharacterObject = o as NCharacterObject;
            
            var target:Point = WorldMap.me.getScreenPostion(c.PosX,c.PosY);			
            
            o.x = target.x;
            o.y = target.y;
            
            if(c.action==Actions.Stop && c.RenderUpdated) return;
            if(c.action==Actions.Die) return;
            c.RenderUpdated = true;
            
            super.render(o);
            
            if(c.directionNum>=0)
            {
                
                draw(c,c.renderLine,c.renderFrame);
            }else{
                drawMirror(c,c.renderLine,c.renderFrame);
            }
        }
    }
}