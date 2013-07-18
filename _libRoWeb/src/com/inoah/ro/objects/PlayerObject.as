package com.inoah.ro.objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Objects.CharacterObject;
    import com.D5Power.Stuff.HSpbar;
    import com.inoah.ro.infos.BattleCharacterInfo;
    
    public class PlayerObject extends CharacterObject
    {
        protected var _info:BattleCharacterInfo;
        
        public function PlayerObject(ctrl:BaseControler=null)
        {
            super(ctrl);
        }
        
        override public function set hp(val:int):void
        {
            _info.hpCurrent = val>0 ? val : 0;
            _hp = _info.hpCurrent;
            hpMax = _info.hpMax;
            if(_hpBar!=null)
            {
                _hpBar.update();
            }
        }
        
        override public function get hp():int
        {
            return _info.hpCurrent;
        }
        
        override public function set sp(val:int):void
        {
            _info.spCurrent = val>0 ? val : 0;
            _sp = _info.spCurrent;
            spMax = _info.spMax;
            if(_spBar!=null)
            {
                _spBar.update();
            }
        }
        
        override public function get sp():int
        {
            return _info.spCurrent;
        }
        
        public function set info( value:BattleCharacterInfo ):void
        {
            _info = value;
            setName( _info.name ,-1,0,-110);
            hp = _info.hpCurrent;
            hpMax = _info.hpMax;
            hpBar = new HSpbar( this,'hp','hpMax',10 , 0x33ff33 );
            sp = _info.spCurrent;
            spMax = _info.spMax;
            spBar = new HSpbar( this,'sp','spMax',14 , 0x2868FF);
        }
        
        public function get info():BattleCharacterInfo
        {
            return _info;
        }
        
        override public function set action(u:int):void
        {
            _action = u;
            _displayer.action = u;
        }
        
        override public function setDirectionNum(v:int):void
        {
            if( _direction != v )
            {
                _direction = v;
                _displayer.direction = v;
            }
        }
    }
}