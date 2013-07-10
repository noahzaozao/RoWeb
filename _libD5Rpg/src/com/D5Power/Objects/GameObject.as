/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.Objects
{
    import com.D5Power.D5Camera;
    import com.D5Power.D5Game;
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.GMath.data.qTree.QTree;
    import com.D5Power.graphics.ISwfDisplayer;
    import com.D5Power.map.WorldMap;
    import com.D5Power.ns.NSCamera;
    import com.D5Power.ns.NSEditor;
    import com.D5Power.utils.NoEventSprite;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    use namespace NSCamera;
    use namespace NSEditor;
    
    /**
     * 游戏对象基类
     * 游戏中全部对象的根类
     */ 
    public class GameObject extends NoEventSprite
    {
        
        /**
         * 默认方向配置
         */ 
        public static var DEFAULT_DIRECTION:Direction=new Direction();
        
        /**
         * 渲染是否更新,若为true则无需渲染,若为false则需要重新渲染
         */ 
        public var RenderUpdated:Boolean=false;
        
        
        public var ID:uint=0;
        
        /**
         * 移动速度
         */ 
        public var speed:Number;
        
        /**
         * 是否可被攻击
         */ 
        public var canBeAtk:Boolean=false;
        /**
         * 渲染器
         */ 
        //public var render:Render;
        /**
         * 角色阵营
         */ 
        public var camp:uint=0;
        
        /**
         * 类型名，用于点击区分
         */ 
        public var objectName:String;
        
        protected var _displayer:ISwfDisplayer;
        
        /**
         * 深度排序
         */ 
        protected var zorder:int = 0;
        
        /**
         * 控制器,每个对象都可以拥有控制器。控制器是进行屏幕裁剪后对不在屏幕内
         * 的对象进行处理的接口。
         */ 
        protected var _controler:BaseControler;
        /**
         * 对象定位
         */ 
        protected var pos:Point;
        
        /**
         * 排序调整
         */ 
        protected var _zOrderF:int;
        
        
        
        /**
         * 记录当前对象所在的象限
         */ 
        protected var _qTree:QTree;
        
        /**
         * 最后一次渲染时间
         */ 
        protected var _lastRender:uint;
        
        /**
         * 是否正在移出场景
         */ 
        protected var _isOuting:Boolean;
        /**
         * 是否正在移进场景
         */ 
        protected var _isIning:Boolean;
        
        protected var _action:int;
        
        protected var _direction:int;
        
        private var _resname:String;
        
        /**
         * 是否在场景内
         */ 
        NSCamera var $inScene:Boolean;
        
        /**
         * @param	ctrl	控制器
         */ 
        public function GameObject(ctrl:BaseControler = null)
        {
            pos = new Point(0,0);
            speed = 1.4;
            changeController(ctrl);
        }
        
        /**
         * 设置动作
         */ 
        public function set action(u:int):void
        {
            _action = u;
        }
        
        public function get action():int
        {
            return _action;
        }
        
        /**
         * 设置方向
         */ 
        public function set direction(u:int):void
        {
            _direction = u;
        }
        
        public function get graphicsFlyX():uint
        {
            if(_displayer) return int(_displayer.monitor.width>>1)
            return 0;
        }
        
        public function get graphicsFlyY():uint
        {
            if(_displayer) return int(_displayer.monitor.height)
            return 0;
        }
        
        public function get inScene():Boolean
        {
            return $inScene;
        }
        
        /**
         * 更换控制器
         */ 
        public function changeController(ctrl:BaseControler):void
        {
            if(_controler!=null)
            {
                _controler.unsetupListener();
            }
            
            if(ctrl!=null)
            {
                _controler = ctrl;
                _controler.me=this;
                _controler.setupListener();
            }
            
        }
        /**
         * 渲染定位
         */ 
        public function get renderPos():uint
        {
            return 0;
        }
        
        /**
         * 设置对象的坐标定位
         * @param	p
         */ 
        public function setPos(px:Number,py:Number):void
        {
            pos.x = px;
            pos.y = py;
            zorder = pos.y;
            
            if(!D5Camera.needReCut && D5Camera.cameraView && D5Camera.cameraView.contains(pos.x,pos.y)) D5Camera.$needReCut = true;
        }
        
        /**
         * 将对象移动到某一点，并清除当前正在进行的路径
         */ 
        public function reSetPos(px:Number,py:Number):void
        {
            setPos(px,py);
            if(controler!=null) controler.clearPath();
        }
        
        /**
         * 当前对象所在的象限
         */ 
        public function set qTree(q:QTree):void
        {
            _qTree = q;
        }
        
        /**
         * 获取对象的坐标定位
         */ 
        public function get PosX():Number
        {
            return pos.x;
        }
        
        /**
         * 获取对象的坐标定位
         */ 
        public function get PosY():Number
        {
            return pos.y;
        }
        
        /**
         * 本坐标仅可用来获取！！！
         */ 
        public function get _POS():Point
        {
            return pos;
        }
        /**
         * 深度排序浮动
         */ 
        public function set zOrderF(val:int):void
        {
            _zOrderF = val;
        }
        /**
         * 深度排序浮动
         */
        public function get zOrderF():int
        {
            return _zOrderF;
        }
        
        /**
         * 获取坐标的深度排序
         */ 
        public function get zOrder():int
        {
            //return zorder;
            return pos.y+_zOrderF;
        }
        
        public function get controler():BaseControler
        {
            return _controler;
        }
        
        
        /**
         * 渲染自己在屏幕上输出
         */
        NSCamera function renderMe():void
        {			
            // 控制总体刷新率
            if(!$inScene || Global.Timer-_lastRender<Global.TPF) return;
            _lastRender = Global.Timer;
            
            renderAction();
        }
        
        public function runPos():void
        {
            if(_controler) _controler.calcAction();
            
            var targetx:Number;
            var targety:Number;
            var maxX:uint = Global.MAPSIZE.x;
            var maxY:uint = Global.MAPSIZE.y;
            
            if(D5Game.me.camera.focusObject==this)
            {
                targetx = pos.x<(Global.W>>1) ? pos.x : (Global.W>>1);
                targety = pos.y<(Global.H>>1) ? pos.y : (Global.H>>1);
                
                targetx = pos.x>maxX-(Global.W>>1) ? pos.x-(maxX-Global.W) : targetx;
                targety = pos.y>maxY-(Global.H>>1) ? pos.y-(maxY-Global.H) : targety;
            }else{
                var target:Point = WorldMap.me.getScreenPostion(pos.x,pos.y);
                targetx = target.x;
                targety = target.y;
            }
            x = Number(targetx.toFixed(1));
            y = Number(targety.toFixed(1));
        }
        
        public function get renderLine():uint
        {
            return 0;
        }
        
        public function get renderFrame():uint
        {
            return 0;
        }
        
        public function get displayer():ISwfDisplayer
        {
            return _displayer;
        }
        
        public function set displayer(v:ISwfDisplayer):void
        {
            if(numChildren>0) removeChildren(0,numChildren-1);
            
            _displayer = v;
            
            if( _displayer.shadow )
            {
                addChild(_displayer.shadow);
            }
            if( _displayer.monitor )
            {
                addChild(_displayer.monitor);
            }
        }
        
        public function get directionNum():int
        {
            return _direction;
        }
        
        public function setDirectionNum(v:int):void
        {
            _direction = v;
        }
        
        public function get directions():Direction
        {
            return DEFAULT_DIRECTION;
        }
        
        public function get Angle():uint
        {
            return 0;
        }
        
        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME,goOut);
            removeEventListener(Event.ENTER_FRAME,goIn);
            if(_controler) _controler.dispose();
            Global.GC();
        }
        
        NSCamera function isOuting():void
        {
            _isOuting = true;
            _isIning = false;
            
            if(hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME,goIn);
            if(!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME,goOut);
        }
        
        NSCamera function isIning():void
        {
            _isIning = true;
            _isOuting = false;
            
            if(hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME,goOut);
            if(!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME,goIn);
        }
        
        NSEditor function get resName():String
        {
            return _resname;
        }
        
        NSEditor function set resName(s:String):void
        {
            _resname = s;
        }
        
        /**
         * 当对象超出渲染范围后后逐渐消失的效果实现
         */ 
        protected function goOut(e:Event):void
        {
            if(alpha>0)
            {
                alpha-=.01;
            }else{
                _controler.perception.Scene.pullRenderList(this);
                removeEventListener(Event.ENTER_FRAME,goOut);
            }
        }
        
        /**
         * 当对象进入渲染范围后后逐渐出现的效果实现
         */ 
        protected function goIn(e:Event):void
        {
            if(alpha<1)
            {
                alpha+=.01;
            }else{
                removeEventListener(Event.ENTER_FRAME,goIn);
            }
        }
        
        /**
         * 渲染动作
         */ 
        protected function renderAction():void
        {
            
        }
        
        /**
         * 当素材准备好后调用的初始化函数
         */ 
        protected function build():void
        {
            
        }
        
        public function setChooseCircle( bool:Boolean ):void
        {
            _displayer.setChooseCircle( bool );
        }
    }
}