package inoah.game.ro.objects
{
    import flash.geom.Point;
    import flash.utils.getTimer;
    
    import inoah.core.consts.ConstsActions;
    import inoah.core.consts.ConstsDirIndex;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.core.viewModels.valueBar.HSpbar;
    import inoah.interfaces.character.IBattleCharacterObject;
    import inoah.interfaces.info.ICharacterInfo;
    
    public class BattleCharacterObject extends CharacterObject implements IBattleCharacterObject
    {
        protected var _hpBar:HSpbar;
        protected var _spBar:HSpbar;
        
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
            
            if(angle>=-22.5 && angle<22.5)
            {
                direction = ConstsDirIndex.UP;
            }
            else if(angle>=22.5 && angle<67.5)
            {
                direction = ConstsDirIndex.UP_RIGHT;
            }
            else if(angle>=67.5 && angle<112.5)
            {
                direction = ConstsDirIndex.RIGHT;
            }
            else if(angle>=112.5 && angle<157.5)
            {
                direction = ConstsDirIndex.DOWN_RIGHT;
            }
            else if(angle>=157.5 && angle<202.5)
            {
                direction = ConstsDirIndex.DOWN;
            }
            else if(angle>=202.5 && angle<247.5)
            {
                direction = ConstsDirIndex.DOWN_LEFT;
            }
            else if(angle>=247.5 && angle<292.5)
            {
                direction = ConstsDirIndex.LEFT;
            }
            else
            {
                direction = ConstsDirIndex.UP_LIFT;
            }
        }
        
        public function stopMove():void
        {
            
        }
        
        public function moveTo(nextX:int, nextY:int):void
        {
            _endTarget = new Point( nextX, nextY );
            action = ConstsActions.Run;
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
            battleCharacterInfo.hpCurrent = val>0 ? val : 0;
            if(_hpBar!=null)
            {
                _hpBar.update();
            }
        }
        
        public function get hp():int
        {
            return battleCharacterInfo.hpCurrent;
        }
        
        public function set sp(val:int):void
        {
            battleCharacterInfo.spCurrent = val>0 ? val : 0;
            if(_spBar!=null)
            {
                _spBar.update();
            }
        }
        
        public function get sp():int
        {
            return battleCharacterInfo.spCurrent;
        }
        
        override public function set info( value:ICharacterInfo ):void
        {
            super.info
            _info = value;
//            setName( _info.name ,-1,0,-110);
            hp = battleCharacterInfo.hpCurrent;
            hpBar = new HSpbar( this,'hpCurrent','hpMax',10 , 0x33ff33 );
            sp = battleCharacterInfo.spCurrent;
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
        
        public function get battleCharacterInfo():BattleCharacterInfo
        {
            return _info as BattleCharacterInfo;;
        }
    }
}