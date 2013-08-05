package inoah.core.viewModels.valueBar
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    
    import inoah.core.objects.BaseObject;
    
    /**
     * 角色血量、称号、图标等物品的基类
     */ 
    public class CharacterStuff extends Shape
    {
        /**
         * 控制目标
         */ 
        protected var _target:BaseObject;
        /**
         * 控制属性的变量名
         */ 
        protected var _attName:String;
        /**
         * 控制属性的最大值的变量名
         */ 
        protected var _attMaxName:String;
        
        /**
         * @param	target		所属游戏对象
         * @param	resource	渲染素材
         * @param	attName		挂接的游戏对象属性
         * @param	attMaxName	如果挂接属性有最大值，进行挂接
         */ 
        public function CharacterStuff(target:BaseObject,attName:String='',attMaxName:String='')
        {
            _target = target;
            
            if(attName!='' && _target.info.hasOwnProperty(attName)) _attName = attName;
            if(attMaxName!= '' && _target.info.hasOwnProperty(attMaxName)) _attMaxName = attMaxName;
        }
        /**
         * 渲染
         */ 
        public function render(buffer:BitmapData):void{}
        
        /**
         * 清空
         */ 
        public function clear():void
        {
            
        }
    }
}