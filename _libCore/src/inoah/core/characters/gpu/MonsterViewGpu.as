package inoah.core.characters.gpu
{
    import inoah.core.infos.CharacterInfo;
    import inoah.utils.Counter;
    
    public class MonsterViewGpu extends CharacterViewGpu
    {
        private var _moveCounter:Counter;
        
        public function MonsterViewGpu()
        {
            super();
            _moveCounter = new Counter();
            _moveCounter.initialize();
            _moveCounter.reset( 2 );
        }
        
        override public function initInfo(charInfo:CharacterInfo=null):void
        {
            super.initInfo( charInfo );
        }
        
        override public function actionStand():void
        {
            _currentIndex = 0;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = true;
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =true;
                }
            }
        }
        
        override public function actionAttack():void
        {
            _currentIndex = 16;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0.8;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =true;
                }
            }
        }
        
        override public function actionHit():void
        {
            _currentIndex = 24;
            //            _currentIndex = 40;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =true;
                }
            }
        }
        
        override public function actionDead():void
        {
            _currentIndex = 32;
            if( _bodyView )
            {
                _bodyView.counterTargetRate = 0;
                _bodyView.actionIndex = _currentIndex + _dirIndex;
                _bodyView.loop = false;
                var len:int = _otherViews.length;
                for( var i:int = 0;i<len;i++)
                {
                    if( _otherViews[i] )
                    {
                        _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                    }
                }
                if( _otherViews[1] )
                {
                    _otherViews[1].visible =false;
                }
            }
        }
        
        override public function tick( delta:Number ):void
        {
            super.tick( delta );
        }
    }
}