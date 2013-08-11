package robotlegs.bender.extensions.sprMgrExtension
{
    import flash.utils.ByteArray;
    
    import inoah.core.viewModels.actSpr.structs.CSPR;
    import inoah.interfaces.managers.ISprMgr;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    /**
     * roSpr文件位图管理器
     * @author inoah
     */    
    public class SprMgr extends Mediator implements ISprMgr
    {
        private var _sprListIndex:Vector.<ByteArray>;
        private var _textureList:Vector.<CSPR>;
        private var _usedCountList:Vector.<int>;
        private var _resIdList:Vector.<String>;
        
        private var _isDisposed:Boolean;
        
        public function SprMgr()
        {
            _sprListIndex= new Vector.<ByteArray>();
            _textureList = new Vector.<CSPR>();
            _usedCountList = new Vector.<int>();
            _resIdList = new Vector.<String>();
        }
        
        public function getCSPR( resId:String , sprByte:ByteArray, loadAsync:Function=null):CSPR
        {
            var index:int = _sprListIndex.indexOf( sprByte );
            if( index == -1 )
            {
                _sprListIndex.push( sprByte );
                _textureList.push( new CSPR( sprByte , sprByte.length ) );
                index = _sprListIndex.indexOf( sprByte );
                _usedCountList[index] = 0;
                _resIdList[index] = resId;
            }
            if( loadAsync != null )
            {
                loadAsync( _textureList[index] );
            }
            _usedCountList[index]++;
            return _textureList[index];
        }
        
        public function disposeTexture( texture:CSPR ):void
        {
            var index:int = _textureList.indexOf( texture );
            if(index != -1 )
            {
                _usedCountList[index]--;
                var usedCount:int = _usedCountList[index];
                if(usedCount == 0)
                {
                    _textureList[index].dispose();
                    _textureList.splice( index ,1 );
                    _sprListIndex.splice( index , 1 );
                    _usedCountList.splice( index ,  1 );
                    _resIdList.splice( index ,  1 );
                }
            }
        }
        
        public function dispose():void 
        {
            if (_isDisposed == false)
            {
                _isDisposed = true;
                distruct ();
            }
        }
        
        protected function distruct():void 
        {
        }
        
        public function get isDisposed():Boolean 
        {
            return _isDisposed;
        }
    }
}