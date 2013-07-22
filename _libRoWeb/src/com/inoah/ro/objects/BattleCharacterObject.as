package com.inoah.ro.objects
{
    import com.inoah.ro.displays.valueBar.HSpbar;
    import com.inoah.ro.infos.BattleCharacterInfo;
    
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    
    public class BattleCharacterObject extends CharacterObject
    {
        protected var _hpBar:HSpbar;
        protected var _spBar:HSpbar;
        protected var _info:BattleCharacterInfo;
        
        protected var _atkCd:Number;
        protected var _moveCd:Number;
        protected var _recoverCd:Number;
        
        protected var _isDead:Boolean;
        /**
         * 移动目标 
         */        
        protected var _endTarget:Point;
        /**
         * 攻击范围 
         */        
        public var atkRange:int = 100;
        
        public function BattleCharacterObject()
        {
            super();
        }
        
        public function changeDirectionByAngle(angle:int):void
        {
            if(angle<-22.5) angle+=360;
            
            //_me.Angle = angle;
            
            if(angle>=-22.5 && angle<22.5)
            {
                direction = directions.Up;
            }
            else if(angle>=22.5 && angle<67.5)
            {
                direction = directions.RightUp;
            }
            else if(angle>=67.5 && angle<112.5)
            {
                direction = directions.Right;
            }
            else if(angle>=112.5 && angle<157.5)
            {
                direction = directions.RightDown;
            }
            else if(angle>=157.5 && angle<202.5)
            {
                direction = directions.Down;
            }
            else if(angle>=202.5 && angle<247.5)
            {
                direction = directions.LeftDown;
            }
            else if(angle>=247.5 && angle<292.5)
            {
                direction = directions.Left;
            }
            else
            {
                direction = directions.LeftUp;
            }
        }
        
        public function stopMove():void
        {
            
        }
        
        public function moveTo(nextX:int, nextY:int):void
        {
            _endTarget = new Point( nextX, nextY );
        }
        
        public function get atkCd():Number
        {
            return _atkCd;
        }
        
        public function get moveCd():Number
        {
            return _moveCd;
        }
        
        public function get recoverCd():Number
        {
            return _recoverCd;
        }
        
        public function set hpBar(bar:HSpbar):void
        {
            _hpBar = bar;
//            (viewObject as DisplayObjectContainer).addChild(_hpBar);
        }
        public function set spBar(bar:HSpbar):void
        {
            _spBar = bar;
//            (viewObject as DisplayObjectContainer).addChild(_spBar);
        }
        
        public function set hp(val:int):void
        {
            _info.hpCurrent = val>0 ? val : 0;
            if(_hpBar!=null)
            {
                _hpBar.update();
            }
        }
        
        public function get hp():int
        {
            return _info.hpCurrent;
        }
        
        public function set sp(val:int):void
        {
            _info.spCurrent = val>0 ? val : 0;
            if(_spBar!=null)
            {
                _spBar.update();
            }
        }
        
        public function get sp():int
        {
            return _info.spCurrent;
        }
        
        public function set info( value:BattleCharacterInfo ):void
        {
            _info = value;
//            setName( _info.name ,-1,0,-110);
            hp = _info.hpCurrent;
            hpBar = new HSpbar( this,'hpCurrent','hpMax',10 , 0x33ff33 );
            sp = _info.spCurrent;
            spBar = new HSpbar( this,'spCurrent','spMax',14 , 0x2868FF);
        }
        
        public function set isDead( value:Boolean ):void
        {
            _isDead = value;
        }
        
        public function get isDead():Boolean
        {
            return _isDead;
        }
        
        public function get endTarget():Point
        {
            return _endTarget
        }
        
        public function set endTarget( value:Point ):void
        {
            _endTarget = value;
        }
        
        public function get info():BattleCharacterInfo
        {
            return _info;
        }
    }
}