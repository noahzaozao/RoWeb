package inoah.game.ro.objects
{
    import inoah.core.consts.ConstsActions;
    import inoah.interfaces.character.IMonsterObject;

    public class MonsterObject extends BattleCharacterObject implements IMonsterObject
    {
        public function MonsterObject()
        {
            super();
            _atkCd = 3;
            _moveCd = 3;
        }
        
        override public function tick(delta:Number):void
        {
            var isMovingX:Boolean;
            var speed:Number = 50;
            if( _endTarget && !isDead )
            {
                if( posX - _endTarget.x > 0 )
                {
                    posX -= speed * delta;
                    if(posX - _endTarget.x <= 0 )
                    {
                        posX = _endTarget.x;
                    }
                }
                else if( posX - _endTarget.x < 0 )
                {
                    posX += speed * delta;
                    if(posX - _endTarget.x >= 0 )
                    {
                        posX = _endTarget.x;
                    }
                }
                else
                {
                    isMovingX = true;
                }
                if( posY - _endTarget.y > 0 )
                {
                    posY -= speed * delta * 0.5;
                    if(posY - _endTarget.y <= 0 )
                    {
                        posY = _endTarget.y;
                    }
                }
                else if( posY - _endTarget.y < 0 )
                {
                    posY += speed * delta * 0.5;
                    if(posY - _endTarget.y >= 0 )
                    {
                        posY = _endTarget.y;
                    }
                }
                else
                {
                    if( isMovingX )
                    {
                        action = ConstsActions.Wait;
                    }
                }
            }
            super.tick( delta );
        }
        
        override public function dispose():void
        {
            super.dispose();
        }
        
        //        override public function set info( value:BattleCharacterInfo ):void
        //        {
        //            _info = value;
        //            setName( _info.name , (camp==2 ? 0xff0000 : 0xffff00), 0, -80 );
        //            hp = _info.hpCurrent;
        //            hpMax = _info.hpMax;
        //            hpBar = new HSpbar( this,'hp','hpMax',10 , 0x33ff33 );
        //            sp = _info.spCurrent;
        //            spMax = _info.spMax;
        //            spBar = new HSpbar( this,'sp','spMax',14 , 0x2868FF);
        //        }
    }
}