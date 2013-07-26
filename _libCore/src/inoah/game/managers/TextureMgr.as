package inoah.game.managers
{
    import inoah.game.displays.actspr.structs.CACT;
    
    import flash.utils.ByteArray;
    
    import inoah.game.interfaces.IMgr;
    
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class TextureMgr implements IMgr
    {
        private var _atfDataListIndex:Vector.<Vector.<ByteArray>>;
        private var _resIdList:Vector.<Vector.<String>>;
        private var _usedCountList:Vector.<Vector.<int>>;
        
        private var _textureList:Vector.<Texture>;
        private var _textureAtlasList:Vector.<TextureAtlas>;
        
        private var _isDisposed:Boolean;
        private var _currentTempTexutre:Vector.<Texture>;
        private var _currentAtlasXml:Vector.<XML>;
        private var _currentLoadAsync:Vector.<Function>;
        
        public function TextureMgr()
        {
            _atfDataListIndex= new Vector.<Vector.<ByteArray>>( 2 );
            _atfDataListIndex[0] = new Vector.<ByteArray>();
            _atfDataListIndex[1] = new Vector.<ByteArray>();
            _usedCountList = new Vector.<Vector.<int>>( 2 );
            _usedCountList[0] = new Vector.<int>();
            _usedCountList[1] = new Vector.<int>();
            _resIdList = new Vector.<Vector.<String>>( 2 );
            _resIdList[0] = new Vector.<String>();
            _resIdList[1] = new Vector.<String>();
            _textureList = new Vector.<Texture>();
            _textureAtlasList = new Vector.<TextureAtlas>();
            
            _currentTempTexutre = new Vector.<Texture>();
            _currentAtlasXml = new Vector.<XML>();
            _currentLoadAsync = new Vector.<Function>();
        }
        
        public function getTextureAtlas( resId:String , atfByte:ByteArray, atlasXml:XML , loadAsync:Function = null ):TextureAtlas
        {
            var index:int = _resIdList[0].indexOf( resId );
            if( index == -1 )
            {
                index = _atfDataListIndex[0].indexOf( atfByte );
            }
            if( index == -1 )
            {
                _atfDataListIndex[0].push( atfByte );
                index = _atfDataListIndex[0].indexOf( atfByte );
                _resIdList[0][index] = resId;
                _usedCountList[0][index] = 0;
                _currentTempTexutre.push( Texture.fromAtfData( atfByte, 1, false, onGetTextureAtlas) )
                _currentAtlasXml.push( atlasXml );
                _currentLoadAsync.push( loadAsync );
            }
            else
            {
                loadAsync( _textureAtlasList[index] );
            }
            _usedCountList[0][index]++;
            if( _textureAtlasList.length > index )
            {
                return _textureAtlasList[index];
            }
            return null;
        }
        
        private function onGetTextureAtlas( texture:Texture ):void
        {
            var index:int = _currentTempTexutre.indexOf( texture );
            if( index != -1 )
            {
                _textureAtlasList.push( new TextureAtlas( texture , _currentAtlasXml[index] ));
                _currentLoadAsync[index]( _textureAtlasList[_textureAtlasList.length - 1] );
                _currentTempTexutre.splice( index , 1 );
                _currentAtlasXml.splice( index , 1 );
                _currentLoadAsync.splice( index , 1 );
            }
        }
        
        public function getTexture( resId:String , atfByte:ByteArray, loadAsync:Function=null):Texture
        {
            var index:int = _resIdList[1].indexOf( resId );
            if( index == -1 )
            {
                index = _atfDataListIndex[1].indexOf( atfByte );
            }
            if( index == -1 )
            {
                _atfDataListIndex[1].push( atfByte );
                index = _atfDataListIndex[1].indexOf( atfByte );
                _resIdList[1][index] = resId;
                _usedCountList[1][index] = 0;
                _textureList.push( Texture.fromAtfData( atfByte, 1, false, loadAsync) );
            }
            else
            {
                loadAsync( _textureList[index] );
            }
            _usedCountList[1][index]++;
            if( _textureList.length > index )
            {
                return _textureList[index];
            }
            return null;
        }
        
        public function disposeTexture( texture:Texture ):void
        {
            var index:int = _textureList.indexOf( texture );
            if(index != -1 )
            {
                _usedCountList[1][index]--;
                var usedCount:int = _usedCountList[1][index];
                if(usedCount == 0)
                {
                    _textureList[index].dispose();
                    _textureList.splice( index ,1 );
                    _atfDataListIndex[1].splice( index , 1 );
                    _usedCountList[1].splice( index ,  1 );
                    _resIdList[1].splice( index ,  1 );
                }
            }
        }
        
        public function disposeTextureAtlas( textureAtlas:TextureAtlas ):void
        {
            var index:int = _textureAtlasList.indexOf( textureAtlas );
            if(index != -1 )
            {
                _usedCountList[0][index]--;
                var usedCount:int = _usedCountList[0][index];
                if(usedCount == 0)
                {
                    _textureAtlasList[index].dispose();
                    _textureAtlasList.splice( index ,1 );
                    _atfDataListIndex[0].splice( index , 1 );
                    _usedCountList[0].splice( index ,  1 );
                    _resIdList[0].splice( index ,  1 );
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

