package com.D5Power.Objects.Effects
{
    import com.D5Power.GMath.GMath;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.scene.BaseScene;
    
    import flash.display.BlendMode;
    import flash.geom.Point;
    
    /**
     * 子弹类
     */ 
    public class BulletObject extends ActionEffect
    {
        public var checkHit:Boolean=true;
        /**
         * 攻击目标
         */ 
        protected var _target:GameObject;
        
        /**
         * 落地点
         */
        protected var _targetPoint:Point;
        
        /**
         * 发射人
         */ 
        protected var _shooter:GameObject;
        /**
         * 发射角度
         */ 
        protected var _angle:Number=0;
        
        /**
         * 原点角度
         */ 
        protected var _PosAngle:Number
        
        /**
         * 射程
         */ 
        protected var _distance:Number=300;
        /**
         * 标准出发点
         */ 
        protected var _starter:Point;
        
        /**
         * 子弹出发点
         */ 
        protected var _posStarter:Point;
        
        /**
         * 发生碰撞时的处理函数
         */ 
        protected var _atkFunction:Function;
        
        /**
         * 给敌人造成的伤害
         */ 
        protected var _hurt:int;
        
        protected var zero:Point;
        
        
        
        /**
         * @param		scene			游戏场景
         * @param		shooter			发射人
         * @param		atkFunction		反馈函数
         */ 
        public function BulletObject(scene:BaseScene,shooter:GameObject,atkFunction:Function=null)
        {
            super(scene);
            _zOrderF = 20;
            _atkFunction = atkFunction;
            _shooter = shooter;
            zero = new Point(shooter.PosX,shooter.PosY);
            _starter = new Point(shooter.PosX,shooter.PosY);
            
            // 不启用alpha通道
            _allowAlpha = false;
            blendMode = BlendMode.ADD;
        }
        
        public function get realPos():Point
        {
            return zero;	
        }
        
        /**
         * 子弹初始位置
         */ 
        public function set starter(p:Point):void
        {
            pos = new Point(p.x,p.y);
            _posStarter = new Point(p.x,p.y);
            _renderPos = CENTER;
        }
        
        /**
         * 给敌人造成的伤害
         */ 
        public function set hurt(val:int):void
        {
            _hurt=val;
        }
        
        /**
         * 攻击距离
         */ 
        public function set distance(val:Number):void
        {
            _distance = val;
        }
        
        /**
         * 发射角度
         * 发射角度与攻击目标只能选择一种
         */ 
        public function set radian(val:Number):void
        {
            if(_target!=null)
            {
                return;
            }
            _angle=val;
        }
        /**
         * 攻击目标
         */ 
        public function set target(obj:GameObject):void
        {
            if(!isNaN(_angle))
            {
                return;
            }
            _target = obj;
        }
        
        /**
         * 攻击落地点
         * @param	p	落地点
         */ 
        public function set targetPoint(p:Point):void
        {
            _targetPoint = p;
            
            _angle = GMath.getPointAngle(_targetPoint.x-_starter.x,_targetPoint.y-_starter.y);
            _PosAngle = GMath.getPointAngle(_targetPoint.x-_posStarter.x,_targetPoint.y-_posStarter.y);
            
            // 若当前落地点的与攻击者的坐标的距离超过射程，则重新计算在射程之内的落地点
            if(Point.distance(_targetPoint,_shooter._POS)>_distance)
            {
                _targetPoint.x = zero.x+_distance*Math.cos(_angle);
                _targetPoint.y = zero.y+_distance*Math.sin(_angle);
                _angle = GMath.getPointAngle(_targetPoint.x-_starter.x,_targetPoint.y-_starter.y);
                _PosAngle = GMath.getPointAngle(_targetPoint.x-_posStarter.x,_targetPoint.y-_posStarter.y);
            }
        }
        
        protected function fly():void
        {
            pos.x+=speed*Math.cos(_PosAngle);
            pos.y+=speed*Math.sin(_PosAngle);
            zero.x+=speed*Math.cos(_angle);
            zero.y+=speed*Math.sin(_angle);
        }
        
        /**
         * 渲染自己
         */ 
        override protected function enterFrame():Boolean
        {
            if(!super.enterFrame()) return false;
            if(_target==null)
            {
                if(_targetPoint==null)
                {
                    _targetPoint = new Point();
                    _targetPoint.x = zero.x+_distance*Math.cos(_angle);
                    _targetPoint.y = zero.y+_distance*Math.sin(_angle);
                    _PosAngle = GMath.getPointAngle(_targetPoint.x-_posStarter.x,_targetPoint.y-_posStarter.y);
                }
                
                // 有目标点，向目标点飞行
                fly();
                
                // 检测子弹碰撞
                if(checkHit && _scene.hasOwnProperty('perc'))
                {
                    var clicker:GameObject = _scene.perc.getObjectByPos(zero,true);
                    if(clicker!=null && clicker!=_shooter)
                    {
                        if(_atkFunction!=null)
                        {
                            _atkFunction(clicker,_hurt);
                            _atkFunction=null;
                        }
                        _scene.removeObject(this);
                        return true;
                    }
                }
                
                // 飞到目标点
                if(Point.distance(pos,_targetPoint)<=speed)
                {
                    if(_atkFunction!=null)
                    {
                        _atkFunction(null,_hurt);
                        _atkFunction=null;
                    }
                    
                    hiddenEffect();
                    _scene.removeObject(this);
                    return true;
                }
            }else{
                if(_target.graphics==null)
                {
                    _target = null;
                    _scene.removeObject(this);
                    return true;
                }
                _PosAngle = GMath.getPointAngle(_target.PosX-pos.x,_target.PosY-(_target.displayer.monitor.height>>1)-pos.y);
                _angle = GMath.getPointAngle(_target.PosX-zero.x,_target.PosY-zero.y);
                // 重新计算角度
                fly();
                
                if(Point.distance(zero,_target._POS)<=speed)
                {
                    if(_atkFunction!=null)
                    {
                        _atkFunction(_target,_hurt);
                        _atkFunction=null
                    }
                    hitEffect();
                    _scene.removeObject(this);
                }
            }
            
            return true;
        }
        
        /**
         * 超出移动距离的消隐效果
         */ 
        protected function hiddenEffect():void
        {
            
        }
        
        /**
         * 击中目标的攻击效果
         */ 
        protected function hitEffect():void
        {
            
        }
    }
}