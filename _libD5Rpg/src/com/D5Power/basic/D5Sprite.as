package com.D5Power.basic
{
    import flash.display.Sprite;
    
    /**
     * 带删除内部全部子元素功能的Sprite
     * @author Howard.Ren [ D5Power Studio ]
     */
    public class D5Sprite extends Sprite
    {
        /**
         * 可以在使用过程中传递数据
         */
        public var data:*;
        
        public function D5Sprite() 
        {
            super();
        }		
        /**
         * 清除内存，并把自己从父级列表中删除
         */
        public function destroy():void
        {
            clear();
        }
        /**
         *清除当前sp 上所有的东西 
         * 
         */		
        public function clear():void
        {
            while(numChildren)
                this.removeChildAt(0);
            graphics.clear();				
        }
        
    }
    
}