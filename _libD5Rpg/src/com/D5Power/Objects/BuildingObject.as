/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.Objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.scene.BaseScene;
    
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    
    /**
     * 建筑物
     * 
     */ 
    public class BuildingObject extends GameObject
    {
        /**
         * 建筑物左边界,以当前对象坐标原点为0，0点的坐标
         */ 
        protected var _disappearL:Point;
        
        /**
         * 建筑物右边界,以当前对象坐标原点为0，0点的坐标
         */ 
        protected var _disappearR:Point;
        
        /**
         * 建筑物的原点边界。一般为素材最低点在整个素材中的坐标
         * 
         */ 
        protected var _zero:Point;
        
        /**
         * 对主场景的引用
         */ 
        protected var _scene:BaseScene;
        
        /**
         * @param	s	引用场景
         */ 
        public function BuildingObject(s:BaseScene,ctrl:BaseControler=null)
        {
            super(ctrl);
            _scene=s;
            canBeAtk=true;
            _zero = new Point(0,0);
            objectName = 'BuildingObject';
        }
        
        public function get isOver():Boolean
        {
            return false;
        }
        
        override public function get renderLine():uint
        {
            return 0;
        }
        
        
        //		/**
        //		 * 计算建筑与某对象是否存在遮盖
        //		 * @param	b	游戏对象
        //		 * @return 	Boolean	如果返回true，则b遮盖本对象，若为false则本对象遮盖b
        //		 */ 
        //		public function Over(b:GameObject):Boolean
        //		{
        //			var lx:Number = b.Pos.x-pos.x;
        //			var ly:Number = pos.y-b.Pos.y;
        //			
        //			var l:Number = getJJ(_disappearL.x,_disappearL.y);
        //			var r:Number = getJJ(_disappearR.x,_disappearR.y);
        //			var m:Number = getJJ(lx,ly);
        //			
        //			return (m<=r || m>=l);
        //		}
        
        /**
         * 针对消隐点zero返回深度排序
         */ 
        override public function get zOrder():int
        {
            // Y坐标减去底端到消隐点的距离，即是Y轴遮盖隐藏点
            return pos.y-(_displayer ? _displayer.monitor.height-zero.y : 0)+_zOrderF;
        }
        
        protected function flyPos(px:Number=NaN, py:Number=NaN):void
        {
            if(_zero!=null)
            {
                _displayer.monitor.x = -zero.x;
                _displayer.monitor.y = -zero.y;
            }
        }
        
        override public function get graphicsFlyX():uint
        {
            if(_zero) return _zero.x;
            return 0;
        }
        
        override public function get graphicsFlyY():uint
        {
            if(_zero) return _zero.y;
            return 0;
        }
        
        //		/**
        //		 * 建筑物的左消失边界
        //		 */ 
        //		public function set disappearL(p:Point):void
        //		{
        //			_disappearL=p;
        //		}
        //		
        //		/**
        //		 * 建筑物的右消失边界
        //		 */ 
        //		public function set disappearR(p:Point):void
        //		{
        //			_disappearR=p;
        //		}
        //		
        //		/**
        //		 * 建筑物的左消失边界
        //		 */
        //		public function get disappearL():Point
        //		{
        //			return _disappearL;
        //		}
        //		/**
        //		 * 建筑物的右消失边界
        //		 */
        //		public function get disappearR():Point
        //		{
        //			return _disappearR;
        //		}
        
        override public function setPos(px:Number, py:Number):void
        {
            super.setPos(px,py);
            RenderUpdated = false;
        }
        
        /**
         * 0点坐标
         * 
         */ 
        public function set zero(p:Point):void
        {
            _zero = p;
        }
        
        /**
         * 0点坐标
         */ 
        public function get zero():Point
        {
            return _zero;
        }
        
        /**
         * 引用场景
         */ 
        public function get Scene():BaseScene
        {
            return _scene;
        }
        
        public function get rendFly():Point
        {
            return null;	
        }
        
        public function get colorPan():ColorTransform
        {
            return null;
        }
        
        //		/**
        //		 * 获取某点与X轴的夹角
        //		 * @param	px	X坐标
        //		 * @param	py	Y坐标
        //		 */ 
        //		public static function getJJ(px:Number,py:Number):Number
        //		{
        //			var j:Number = Math.atan2(py,px)/Math.PI*180;
        //			
        //			return j;
        //		}
        
    }
}