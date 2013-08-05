package inoah.game.ro.viewModels.actSpr.structs
{
    import inoah.game.ro.viewModels.actSpr.structs.sprh.AnySprite;
    
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class CSPR
    {
        public var numOfImg:int;
        public var numPalImg:uint;
        public var numFlatImg:int;
        public var imgs:Vector.<AnySprite>;
        public var pal:Vector.<uint>;
        
        public function CSPR( data:ByteArray, len:int )
        {
            numOfImg = numPalImg= numFlatImg = 0;
            imgs = new Vector.<AnySprite>();
            pal = new Vector.<uint>(256);
            if (len != 0) 
            {
                ParseSprData(data, len);
            }
        }
        
        public function destory():void
        {
            //            delete[] pal;
            //            if (imgs) {
            //                for (int i=0; i<numOfImg; i++) {
            //                    delete[] (imgs+i)->dat;
            //                    delete[] (imgs+i)->paldat;
            //                }
            //            }
            //            
            //            delete[] imgs;
            //            imgs = NULL;
        }
        
        public function ParseSprData( data:ByteArray, filelength:int ):Boolean
        {
            //magic check
            data.endian = Endian.LITTLE_ENDIAN;
            var version:uint = data.readUnsignedShort();
            if( version != 0x5053 )
            {
                return false;
            }
            
            //spr version
            var sprversion:uint = data.readUnsignedShort();
            
            //num of image
            numPalImg = data.readUnsignedShort();
            if (sprversion == 0x0101) 
            {
                numFlatImg = 0;
            }
            else
            {
                numFlatImg = data.readUnsignedShort();
            }
            numOfImg = numPalImg + numFlatImg;
            
            var tmpData:ByteArray = new ByteArray();
            pal = new Vector.<uint>();
            if (sprversion == 0x0101) 
            {
                data.position = filelength - 1024;
                while( data.bytesAvailable )
                {
                    var r:int = data.readUnsignedByte();
                    var g:int = data.readUnsignedByte();
                    var b:int = data.readUnsignedByte();
                    var a:int = data.readUnsignedByte();
                    var mycolor:int = (r<<16) + (g<<8) + (b <<0) + (255<<24);
                    pal.push( mycolor );
                }
                data.position = 6;
            }
            else
            {
                data.position = filelength - 1024;
                while( data.bytesAvailable )
                {
                    r = data.readUnsignedByte();
                    g = data.readUnsignedByte();
                    b = data.readUnsignedByte();
                    a = data.readUnsignedByte();
                    mycolor = (r<<16) + (g<<8) + (b <<0)+ (255<<24);
                    pal.push( mycolor );
                }
                data.position = 8;
            }
            
            for (var i:int=0; i<numPalImg; i++) 
            {
                if (sprversion == 0x0201) 
                {
                    Set1ImageCompressed(data, i);
                } 
                else 
                {
                    Set1ImgaePalFlat(data, i);
                }
            }
            
            var flatimgwidth:uint, flatimgheight:uint;
            for ( i=0; i<numFlatImg; i++) 
            {
                flatimgwidth = data.readUnsignedShort();
                flatimgheight = data.readUnsignedShort();
                Set1ImageFlat(data, flatimgwidth, flatimgheight, numPalImg+i);
            }
            
            return true;
        }
        public function Set1ImageCompressed( data:ByteArray, no:int ):void
        {
            var width:uint, height:uint;
            
            width = data.readUnsignedShort();
            height = data.readUnsignedShort();
            imgs[no] = new AnySprite();
            imgs[no].w = width;
            imgs[no].h = height;
            
            try 
            {
                imgs[no].dat = new Vector.<uint>( width*height );
                imgs[no].paldat = new Vector.<uint>( width*height );
            }
            catch (e:Error) 
            {
                return;
            }
            
            data.position += 2; // compressed length
            
            var zero:Boolean = false;
            var restzero:int = 0;
            var p:int;
            for (var y:int=0; y<height; y++) 
            {
                for (var x:int=0; x<width; x++) 
                {
                    p = y*width+x;
                    if (zero) 
                    {
                        imgs[no].dat[p] = 0;
                        imgs[no].paldat[p] = 0;
                        restzero--;
                        if (restzero == 0) 
                        {
                            zero = false;
                        }
                    }
                    else 
                    {
                        var val:int = data.readUnsignedByte();
                        if (val == 0) 
                        {
                            zero = true;
                            restzero = data.readUnsignedByte();
                            imgs[no].dat[p] = 0;
                            imgs[no].paldat[p] = 0;
                            restzero--;
                            if (!restzero) 
                            {
                                zero = false;
                            }
                        }
                        else 
                        {
                            imgs[no].dat[p] = pal[val] + 0xFF000000;
                            imgs[no].paldat[p] = val;
                        }
                    }
                }
            }
        }
        public function Set1ImgaePalFlat( data:ByteArray, no:int ):void
        {
            var width:uint, height:uint;
            
            width = data.readUnsignedShort();
            height = data.readUnsignedShort();
            imgs[no] = new AnySprite();
            imgs[no].w = width;
            imgs[no].h = height;
            
            try 
            {
                imgs[no].dat = new Vector.<uint>( width * height );
                imgs[no].paldat = new Vector.<uint>( width * height );
            }
            catch (e:Error) 
            {
                return;
            }
            
            for (var y:int=0; y<height; y++) 
            {
                for (var x:int=0; x<width; x++) 
                {
                    var val:int = data.readUnsignedByte();
                    if (val == 0) 
                    {
                        imgs[no].dat[ y*width + x ] = 0;
                        imgs[no].paldat[ y*width + x ] = 0;
                    }
                    else
                    {
                        imgs[no].dat[ y*width + x ] = pal[val] | 0xFF000000;
                        imgs[no].paldat[ y*width + x ] = val;
                    }
                }
            }
        }
        public function Set1ImageFlat( data:ByteArray, width:uint, height:uint, no:int ):void
        {
            imgs[no] = new AnySprite();
            imgs[no].w = width;
            imgs[no].h = height;
            
            try 
            {
                imgs[no].dat = new Vector.<uint>( width * height );
                imgs[no].paldat = null;
            }
            catch (e:Error) 
            {
                return;
            }
            
            var a:uint, r:uint, g:uint, b:uint;
            for (var y:int=0; y<height; y++) 
            {
                for (var x:int=0; x<width; x++) 
                {
                    a = data.readUnsignedByte();
                    b = data.readUnsignedByte();
                    g = data.readUnsignedByte();
                    r = data.readUnsignedByte();
                    imgs[no].dat[ (height-y-1)*width+x ] = a<< 24 | b << 16 | g << 8 | r;
                }
            }
        }
        
        public function SwapImage( idA:int,  idB:int ):void
        {
            //            /*
            //            if (idA < numPalImg && numPalImg <= idB)  return;
            //            if (idB < numPalImg && numPalImg <= idB) return;
            //            */
            //            
            //            AnySprite tmpS;
            //            tmpS.dat = NULL;
            //            tmpS.paldat = NULL;
            //            
            //            CopyImage(&tmpS, &imgs[idA]);
            //            CopyImage(&imgs[idA], &imgs[idB]);
            //            CopyImage(&imgs[idB], &tmpS);
            //            
            //            delete[] tmpS.dat;
            //            delete[] tmpS.paldat;
        }
        public function CopyImage( to:AnySprite,  from:AnySprite ):void
        {
            //            to->w = from->w;
            //            to->h = from->h;
            //            delete[] to->dat;
            //            to->dat = new DWORD[from->w * from->h];
            //            memcpy(to->dat, from->dat, from->w * from->h * sizeof(DWORD));
            //            if (from->paldat != NULL) {
            //                delete[] to->paldat;
            //                to->paldat = new BYTE[from->w * from->h];
            //                memcpy(to->paldat, from->paldat, from->w * from->h);
            //            }
        }
        
        public function GetNumPalImage():int
        {
            return numPalImg;
        }
        public function GetNumFlatImage():int
        {
            return numFlatImg;
        }
        public function GetNumImage():int
        {
            return numOfImg;
        }
        public function GetImageWidth( id:int ):int
        {
            return imgs[id].w;
        }
        public function GetImageHeight( id:int ):int
        {
            return imgs[id].h;
        }
        public function GetImage( id:int ):Vector.<uint>
        {
            return imgs[id].dat;
        }
        public function GetMaxWidthHeight( w:int, h:int):void
        {
            //            if (numOfImg == 0) {
            //                *w = *h = 0;
            //                return;
            //            }
            //            
            //            int maxw, maxh;
            //            maxw = maxh = 0;
            //            for (int i=0; i<numPalImg; i++) {
            //                if (maxw < (imgs+i)->w)  maxw = (imgs+i)->w;
            //                if (maxh < (imgs+i)->h)  maxh = (imgs+i)->h;
            //            }
            //            for (int i=numPalImg; i < numPalImg+numFlatImg; i++) {
            //                if (maxw < (imgs+i)->w)  maxw = (imgs+i)->w;
            //                if (maxh < (imgs+i)->h)  maxh = (imgs+i)->h;
            //            }
            //            *w = maxw;
            //            *h = maxh;
        }
    }
}