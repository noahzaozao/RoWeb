/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.Render
{
    import com.D5Power.Objects.GameObject;
    import com.D5Power.Objects.IFrameRender;
    import com.D5Power.ns.NSGraphics;
    import com.D5Power.ns.NSRender;
    
    use namespace NSRender;
    use namespace NSGraphics;
    /**
     * 游戏渲染器
     */ 
    public class Render
    {
        private var renderTarget:IFrameRender;
        
        public function Render()
        {
        }
        
        public function render(o:GameObject):void
        {
            
        }
        
        /**
         * 填充素材
         * @param		source	素材源
         * @param		rect	渲染范围
         * @param		p		坐标点
         */ 
        protected function draw(c:GameObject,line:uint,frame:uint):void
        {
            try
            {
                renderTarget = c as IFrameRender;
                if(renderTarget!=null && renderTarget.needChangeFrame)
                {
                    //c.graphicsRes.render(c.renderBuffer,line,frame);
                    renderTarget.needChangeFrame = true;
                }else{
                    //c.graphicsRes.render(c.renderBuffer,line,frame);
                }
                
                //d_buffer.lock();
                //d_buffer.copyPixels(source[line][frame],d_buffer.rect,new Point(0,0),null,null,true);
                //d_buffer.unlock();
            }catch(e:Error){}
        }
        
        /**
         * 填充素材
         * @param		source	素材源
         * @param		rect	渲染范围
         * @param		p		坐标点
         */ 
        protected function drawMirror(c:GameObject,line:uint,frame:uint):void
        {
            try
            {
                //c.graphicsRes.renderMirror(c.renderBuffer,line,frame);
                //d_buffer.lock();
                //d_buffer.copyPixels(source[line][frame],d_buffer.rect,new Point(0,0),null,null,true);
                //d_buffer.unlock();
            }catch(e:Error){}
        }
    }
}