package com.inoah.ro.controllers
{
    import com.inoah.ro.characters.MonsterView;
    import com.inoah.ro.events.ActSprViewEvent;
    import com.inoah.ro.infos.CharacterInfo;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.Sprite;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    public class MonsterController
    {
        private var _root:Sprite;
        private var _monsterViewList:Vector.<MonsterView>;
        private var _animationUnitList:Vector.<IAnimatable>;
        private var _newMonsterCounter:Counter;
        
        public function MonsterController( root:Sprite )
        {
            _newMonsterCounter = new Counter();
            _newMonsterCounter.initialize();
            _newMonsterCounter.reset( 3 );
            _animationUnitList = new Vector.<IAnimatable>();
            _root = root;
            var monsterInfo:CharacterInfo;
            _monsterViewList = new Vector.<MonsterView>();
            for( var i:int = 0;i<50 ;i++)
            {
                monsterInfo = new CharacterInfo();
                if( int(Math.random() * 2) > 0 )
                {
                    monsterInfo.init( "波利" , "" , "data/sprite/阁胶磐/poring.act" , "" ,100 );
                }
                else
                {
                    monsterInfo.init( "波波利" , "" , "data/sprite/阁胶磐/poporing.act", "" , 200 );
                }
                _monsterViewList[i] = new MonsterView( monsterInfo );
                _monsterViewList[i].x = 700 * Math.random() + 50;
                _monsterViewList[i].y = 500 * Math.random() + 50;
                root.addChild( _monsterViewList[i] );
                _monsterViewList[i].addEventListener( ActSprViewEvent.ACTION_DEAD_START , onDeadStartHandler );
            }
        }
        
        private function onDeadStartHandler( e:ActSprViewEvent ):void
        {
            var monsterView:MonsterView = e.currentTarget as MonsterView;
            monsterView.removeEventListener( ActSprViewEvent.ACTION_DEAD_START, onDeadStartHandler );
            var tween:Tween = new Tween( monsterView, 2 );
            tween.fadeTo( 0 );
            tween.onComplete = onDeadEndHandler;
            tween.onCompleteArgs = [tween, monsterView];
            appendAnimateUnit( tween );
        }
        
        private function onDeadEndHandler( tween:Tween, monsterView:MonsterView ):void
        {
            monsterView.parent.removeChild( monsterView );
            _monsterViewList.splice( _monsterViewList.indexOf( monsterView ) , 1 );
        }
        
        protected function killTweensOf(target:Object):void
        {
            var tween:Tween;
            var len:int = _animationUnitList.length;
            for(var i:int = 0; i<len; i++)
            {
                tween = _animationUnitList[i] as Tween;
                if(tween!=null && tween.target == target)
                {
                    _animationUnitList.splice(i,1);
                    return;
                }
            }
        }
        
        public function get monsterViewList():Vector.<MonsterView>
        {
            return _monsterViewList;
        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _monsterViewList.length;
            for( var i:int = 0;i<len;i++)
            {
                _monsterViewList[i].tick( delta ); 
            }
            
            _newMonsterCounter.tick( delta );
            if( _newMonsterCounter.expired )
            {
                if( _monsterViewList.length < 100 )
                {
                    var monsterView:MonsterView;
                    var monsterInfo:CharacterInfo;
                    monsterInfo = new CharacterInfo();
                    if( int(Math.random() * 2) > 0 )
                    {
                        monsterInfo.init( "波利" , "" , "data/sprite/阁胶磐/poring.act" , "" , 100 );
                    }
                    else
                    {
                        monsterInfo.init( "波波利" , "" , "data/sprite/阁胶磐/poporing.act" , "" , 200 );
                    }
                    monsterView = new MonsterView( monsterInfo );
                    monsterView.x = 700 * Math.random() + 50;
                    monsterView.y = 500 * Math.random() + 50;
                    _root.addChild( monsterView );
                    monsterView.addEventListener( ActSprViewEvent.ACTION_DEAD_START , onDeadStartHandler );
                    monsterView.alpha = 0;
                    _monsterViewList.push( monsterView );
                    var tween:Tween = new Tween( monsterView, 1 );
                    tween.fadeTo( 1 );
                    appendAnimateUnit( tween );
                }
                _newMonsterCounter.reset( 3 );
            }
            
            len = _animationUnitList.length;
            var animateUnit:IAnimatable;
            
            for( i = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime( delta );
                
                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
                    animateUnit["isComplete"] == true )
                {
                    _animationUnitList.splice(i,1);
                    len--;
                    i--;
                    continue;
                }
            }
        }
    }
}