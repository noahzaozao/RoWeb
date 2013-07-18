package com.inoah.ro.objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Stuff.HSpbar;
    import com.inoah.ro.infos.BattleCharacterInfo;

    public class MonsterObject extends PlayerObject
    {
        public function MonsterObject(ctrl:BaseControler=null)
        {
            super(ctrl);
        }
        
        override public function set info( value:BattleCharacterInfo ):void
        {
            _info = value;
            setName( _info.name , (camp==2 ? 0xff0000 : 0xffff00), 0, -80 );
            hp = _info.hpCurrent;
            hpMax = _info.hpMax;
            hpBar = new HSpbar( this,'hp','hpMax',10 , 0x33ff33 );
            sp = _info.spCurrent;
            spMax = _info.spMax;
            spBar = new HSpbar( this,'sp','spMax',14 , 0x2868FF);
        }
            
    }
}