/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */
package com.D5Power.Render
{
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Objects.GameObject;
    
    /**
     * 角色渲染器
     */ 
    public class RenderCharacter extends RenderAllCharacter
    {
        /**
         * 是否镜像
         */ 
        private var ismirror:Boolean = false;
        
        public function RenderCharacter()
        {
            super();
        }
        
        override public function render(o:GameObject):void
        {
            var c:CharacterObject = o as CharacterObject;
            //if(c.action==Actions.Stop && c.RenderUpdated) return;
            
            var targetx:Number=0;
            var targety:Number=0;
            var maxX:uint = Global.MAPSIZE.x;
            var maxY:uint = Global.MAPSIZE.y;
            
            //			if(o.beFocus)
            //			{
            //				targetx = c.PosX<Global.W/2 ? c.PosX : Global.W/2;
            //				targety = c.PosY<Global.H/2 ? c.PosY : Global.H/2;
            //				
            //				targetx = c.PosX>maxX-Global.W/2 ? c.PosX-(maxX-Global.W) : targetx;
            //				targety = c.PosY>maxY-Global.H/2 ? c.PosY-(maxY-Global.H) : targety;
            //				// 摄像机跟随目标，除非超出地图范围，否则一直位于地图中心
            //			}else{
            //				
            //				var target:Point = c.controler.perception.Scene.Map.getScreenPostion(c.PosX,c.PosY);
            //				targetx = target.x;
            //				targety = target.y;
            //			}
            
            c.x = targetx;
            c.y = targety;
            c.RenderUpdated = true;
            
            super.render(o);
            
            if(c.directionNum>=0)
            {
                draw(c,c.renderLine,c.renderFrame);
            }else{
                drawMirror(c,c.renderLine,c.renderFrame);
            }
            
            if(!c.visible) c.visible=true;
        }
    }
}