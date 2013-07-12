package 
{
    import com.inoah.ro.displays.actspr.structs.CSPR;
    import com.inoah.ro.displays.actspr.structs.sprh.AnySprite;
    
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    
    import format.Sequence;

    public class SprTextureAtlas
    {
        private var _sequenceList:Vector.<Sequence>;
        
        public function SprTextureAtlas()
        {
            _sequenceList = new Vector.<Sequence>();
        }
        
        public function init( spr:CSPR ):void
        {
            var len:int = spr.imgs.length;
            var sequence:Sequence;
            var img:AnySprite;
            for( var i:int = 0;i<len;i++)
            {
                img = spr.imgs[i];
                sequence = new Sequence( img.drawbitmap() , new Rectangle( 0, 0, img.w, img.h ) , new Rectangle( 0, 0, img.w, img.h ) , i.toString() );
                _sequenceList.push( sequence );
            }
        }
        
        public function get sequenceList():Vector.<Sequence>
        {
            return _sequenceList;
        }
        
        public function getBitmapTexture():Vector.<Bitmap>
        {
            //拼图，给出大图
            return null;
        }
    }
}