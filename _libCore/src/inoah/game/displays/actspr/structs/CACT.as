package inoah.game.displays.actspr.structs
{
    import inoah.game.displays.actspr.structs.acth.ActAll;
    import inoah.game.displays.actspr.structs.acth.ActHeader;
    import inoah.game.displays.actspr.structs.acth.AnyActAnyPat;
    import inoah.game.displays.actspr.structs.acth.AnyAction;
    import inoah.game.displays.actspr.structs.acth.AnyPatSprV0101;
    import inoah.game.displays.actspr.structs.acth.AnyPatSprV0201;
    import inoah.game.displays.actspr.structs.acth.AnyPatSprV0204;
    import inoah.game.displays.actspr.structs.acth.AnyPatSprV0205;
    import inoah.game.displays.actspr.structs.acth.IAnyPatSprV0205;
    import inoah.game.displays.actspr.structs.acth.PatHeader;
    
    import flash.geom.Point;
    import flash.utils.ByteArray;
    
    public class CACT
    {
        public var aall:ActAll;
        public var modified:Boolean;
        
        public function CACT( dat:ByteArray )
        {
            aall = new ActAll();
            aall.aa = null;
            aall.xxx = null;
            aall.numOfSound = 0;
            aall.buf = null;
            modified = false;
            
            ParseActData(dat);
        }
        
        public function destory():void
        {
            //            for (var i:int=0; i<aall.ah.numOfAct; i++) {
            //                for (var j:int=0; j<aall.aa[i].numOfPat; j++) {
            //                    if (aall.aa[i].aaap[j].apsList != null)
            //                    {
            //                        aall.aa[i].aaap[j].apsList = null;
            //                    }
            //                }
            //                aall.aa[i].aaap = null;
            //            }
            //            aall.aa = null;
            //            
            //            for ( i=0; i<aall.numOfSound; i++) {
            //                if (aall.buf[i] != null)
            //                    aall.buf[i] = null;
            //                aall.buf[i] = null;
            //            }
            //            aall.buf = null;
            //            aall.xxx = null;
        }
        
        private function ParseActData( data:ByteArray ):Boolean
        {
            if ( !ParseActData_Header(data) )
            {
                return false;
            }
            aall.aa = new Vector.<AnyAction>( aall.ah.numOfAct );
            for (var i:int=0; i<aall.ah.numOfAct; i++) 
            {
                ParseActData_AnyAct( data, i);
            }
            
            ParseActData_Sound(data);
            aall.xxx = new Vector.<Number>( aall.ah.numOfAct );
            ParseActData_xxx(data);
            
            return true;
        }
        private function ParseActData_Header( data:ByteArray ):Boolean
        {
            aall.ah = new ActHeader();
            aall.ah.init( data );
            if (aall.ah.magic != 0x4341)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        
        private function ParseActData_AnyAct( data:ByteArray, no:int):void
        {
            var numpat:uint;
            var version:int;
            
            numpat =data.readUnsignedInt();
            aall.aa[no] = new AnyAction();
            aall.aa[no].numOfPat = numpat;
            aall.aa[no].aaap = new Vector.<AnyActAnyPat>( numpat );
            version = aall.ah.version & 0xFFFF;
            for (var i:int=0; i<numpat; i++) 
            {
                aall.aa[no].aaap[i] = new AnyActAnyPat();
                aall.aa[no].aaap[i].ph = new PatHeader();
                aall.aa[no].aaap[i].ph.init( data );
                aall.aa[no].aaap[i].numOfSpr = data.readUnsignedInt();
                MemAllocAnyPatAnySpr(no, i, version);
                for (var j:int=0; j<aall.aa[no].aaap[i].numOfSpr; j++) 
                {
                    ParseActData_AnyPatAnySpr(data, no, i, j, version);
                }
                
                if (version == 0x0101) 
                {
                    aall.aa[no].aaap[i].xxx = 0;
                    aall.aa[no].aaap[i].numxxx = 0;
                    aall.aa[no].aaap[i].Ext1 = 0;
                    aall.aa[no].aaap[i].ExtXoffs = 0;
                    aall.aa[no].aaap[i].ExtYoffs = 0;
                    aall.aa[no].aaap[i].terminate = 0;
                    continue;
                }
                
                aall.aa[no].aaap[i].xxx = data.readUnsignedInt();
                
                if (version == 0x0201) 
                {
                    aall.aa[no].aaap[i].numxxx = 0;
                } 
                else
                {
                    aall.aa[no].aaap[i].numxxx = data.readUnsignedInt()
                    if (aall.aa[no].aaap[i].numxxx == 1) 
                    {
                        aall.aa[no].aaap[i].Ext1 = data.readUnsignedInt()
                        aall.aa[no].aaap[i].ExtXoffs = data.readInt();
                        aall.aa[no].aaap[i].ExtYoffs = data.readInt();
                        aall.aa[no].aaap[i].terminate = data.readUnsignedInt();
                    }
                    else
                    {
                        aall.aa[no].aaap[i].Ext1 = 0;
                        aall.aa[no].aaap[i].ExtXoffs = 0;
                        aall.aa[no].aaap[i].ExtYoffs = 0;
                        aall.aa[no].aaap[i].terminate = 0;
                    }
                }
            }
        }
        
        private function ParseActData_AnyPatAnySpr( data:ByteArray, actNo:int, patNo:int, sprNo:int, version:int):void
        {
            switch (version) 
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprNo] = new AnyPatSprV0101();
                    aall.aa[actNo].aaap[patNo].apsList[sprNo].init( data );
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprNo] = new AnyPatSprV0201();
                    aall.aa[actNo].aaap[patNo].apsList[sprNo].init( data );
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprNo] = new AnyPatSprV0204();
                    aall.aa[actNo].aaap[patNo].apsList[sprNo].init( data );
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprNo] = new AnyPatSprV0205();
                    aall.aa[actNo].aaap[patNo].apsList[sprNo].init( data );
                    break;
            }
        }
        private function MemAllocAnyPatAnySpr( no:int, spr:int, version:int):void
        {
            aall.aa[no].aaap[spr].apsList = new Vector.<AnyPatSprV0101>( aall.aa[no].aaap[spr].numOfSpr );
        }
        private function ParseActData_Sound( data:ByteArray ):void
        {
            if ((aall.ah.version & 0xFFFF) < 0x0200)
            {
                aall.numOfSound = 0;
                aall.buf = null;
                return;
            }
            aall.numOfSound = data.readUnsignedInt();
            if (aall.numOfSound > 0) 
            {
                try 
                {
                    aall.buf = new Vector.<String>( aall.numOfSound );
                } 
                catch ( e:Error ) 
                {
                    return;
                }
                for (var i:int=0; i<aall.numOfSound; i++) 
                {
                    try 
                    {
                        aall.buf[i] = "";
                    }
                    catch ( e:Error)
                    {
                        return;
                    }
                    aall.buf[i] = data.readUTFBytes( 40 );
                }
            }
            else
            {
                aall.buf = null;
            }
        }
        private function ParseActData_xxx( data:ByteArray ):void
        {
            if ((aall.ah.version&0xFFFF) < 0x0202) 
            {
                return;
            }
            aall.xxx = new Vector.<Number>();
            for( var i:int = 0;i<aall.ah.numOfAct ;i++)
            {
                aall.xxx.push( data.readFloat() );
            }
        }
        
        private function Swap( a:Number, b:Number):void
        {
            var tmp:Number;
            tmp = a;
            a = b;
            b = tmp;
        }
        private function SwapSpriteOrderV0101( actNo:int, patNo:int, spA:int, spB:int):void
        {
            var ap0:Vector.<AnyPatSprV0101>;
            
            ap0 = aall.aa[actNo].aaap[patNo].apsList;
            Swap( ap0[spA].xOffs, ap0[spB].xOffs );
            Swap( ap0[spA].yOffs, ap0[spB].yOffs );
            Swap( ap0[spA].sprNo, ap0[spB].sprNo );
            Swap( ap0[spA].mirrorOn, ap0[spB].mirrorOn );
        }
        private function SwapSpriteOrderV0201( actNo:int, patNo:int, spA:int, spB:int):void
        {
            var ap1:Vector.<AnyPatSprV0101>;
            
            ap1 = aall.aa[actNo].aaap[patNo].apsList;
            Swap( ap1[spA].xOffs, ap1[spB].xOffs );
            Swap( ap1[spA].yOffs, ap1[spB].yOffs );
            Swap( ap1[spA].sprNo, ap1[spB].sprNo );
            Swap( ap1[spA].mirrorOn, ap1[spB].mirrorOn );
            Swap( ap1[spA].color, ap1[spB].color );
            Swap( ap1[spA].xyMag, ap1[spB].xyMag );
            Swap( ap1[spA].rot, ap1[spB].rot );
            Swap( ap1[spA].spType, ap1[spB].spType );
        }
        private function SwapSpriteOrderV0204( actNo:int, patNo:int, spA:int, spB:int):void
        {
            var ap4:Vector.<AnyPatSprV0101>;
            
            ap4 = aall.aa[actNo].aaap[patNo].apsList;
            Swap( ap4[spA].xOffs, ap4[spB].xOffs );
            Swap( ap4[spA].yOffs, ap4[spB].yOffs );
            Swap( ap4[spA].sprNo, ap4[spB].sprNo );
            Swap( ap4[spA].mirrorOn, ap4[spB].mirrorOn );
            Swap( ap4[spA].color, ap4[spB].color );
            Swap( ap4[spA].xMag, ap4[spB].xMag );
            Swap( ap4[spA].yMag, ap4[spB].yMag );
            Swap( ap4[spA].rot, ap4[spB].rot );
            Swap( ap4[spA].spType, ap4[spB].spType );
        }
        private function SwapSpriteOrderV0205( actNo:int, patNo:int, spA:int, spB:int):void
        {
            var ap5:Vector.<AnyPatSprV0101>;
            
            ap5 = aall.aa[actNo].aaap[patNo].apsList;
            Swap( ap5[spA].xOffs, ap5[spB].xOffs );
            Swap( ap5[spA].yOffs, ap5[spB].yOffs );
            Swap( ap5[spA].sprNo, ap5[spB].sprNo );
            Swap( ap5[spA].mirrorOn, ap5[spB].mirrorOn );
            Swap( ap5[spA].color, ap5[spB].color );
            Swap( ap5[spA].xMag, ap5[spB].xMag );
            Swap( ap5[spA].yMag, ap5[spB].yMag );
            Swap( ap5[spA].rot, ap5[spB].rot );
            Swap( ap5[spA].spType, ap5[spB].spType );
            Swap( ap5[spA].sprW, ap5[spB].sprW );
            Swap( ap5[spA].sprH, ap5[spB].sprH );
        }
        
        private function NormalizeRot( rot:uint ):int
        {
            var r:int = rot;
            r %= 360;
            if (r < 0)  r += 360;
            return r;
        }
        
        private function AddSprV0101( aaap1:AnyActAnyPat, sprNo:int, spType:int):void
        {
            var aps:IAnyPatSprV0205;
            
            aaap1.numOfSpr++;
            aaap1.apsList = new Vector.<AnyPatSprV0101>( aaap1.numOfSpr );
            aps = aaap1.apsList[aaap1.numOfSpr-1];
            aps.xOffs = 0;
            aps.yOffs = 0;
            aps.sprNo = sprNo;
            aps.mirrorOn = 0;
        }
        private function AddSprV0201( aaap1:AnyActAnyPat, sprNo:int, spType:int):void
        {
            var aps:IAnyPatSprV0205;
            
            aaap1.numOfSpr++;
            aaap1.apsList = new Vector.<AnyPatSprV0101>( aaap1.numOfSpr);
            aps = aaap1.apsList[aaap1.numOfSpr-1];
            aps.xOffs = 0;
            aps.yOffs = 0;
            aps.sprNo = sprNo;
            aps.mirrorOn = 0;
            aps.color = 0xFFFFFFFF;
            aps.xyMag = 1.0;
            aps.rot = 0;
            aps.spType = spType;
        }
        private function AddSprV0204( aaap1:AnyActAnyPat, sprNo:int, spType:int):void
        {
            var aps:IAnyPatSprV0205;
            
            aaap1.numOfSpr++;
            aaap1.apsList = new Vector.<AnyPatSprV0101>( aaap1.numOfSpr);
            aps = aaap1.apsList[aaap1.numOfSpr-1];
            aps.xOffs = 0;
            aps.yOffs = 0;
            aps.sprNo = sprNo;
            aps.mirrorOn = 0;
            aps.color = 0xFFFFFFFF;
            aps.xMag = 1.0;
            aps.yMag = 1.0;
            aps.rot = 0;
            aps.spType = spType;
        }
        private function AddSprV0205( aaap1:AnyActAnyPat, sprNo:int, spType:int, spWidth:int, spHeight:int):void
        {
            var aps:IAnyPatSprV0205;
            
            aaap1.numOfSpr++;
            aaap1.apsList = new Vector.<AnyPatSprV0101>( aaap1.numOfSpr);
            aps = aaap1.apsList[aaap1.numOfSpr-1];
            aps.xOffs = 0;
            aps.yOffs = 0;
            aps.sprNo = sprNo;
            aps.mirrorOn = 0;
            aps.color = 0xFFFFFFFF;
            aps.xMag = 1.0;
            aps.yMag = 1.0;
            aps.rot = 0;
            aps.spType = spType;
            aps.sprW = spWidth;
            aps.sprH = spHeight;
        }
        
        private function CopyAnyActAnyPat( to:AnyActAnyPat, from:AnyActAnyPat):void
        {
            to.ph = from.ph
            to.numOfSpr = from.numOfSpr;
            to.apsList = null;
            switch (aall.ah.version & 0xFFFF) {
                case 0x0101:
                case 0x0201:
                case 0x0202:
                case 0x0203:
                case 0x0204:
                case 0x0205:
                    to.apsList = new Vector.<AnyPatSprV0101>(from.numOfSpr);
                    to.apsList = from.apsList;
                    break;
            }
            to.xxx = from.xxx;
            to.numxxx = from.numxxx;
            to.Ext1 = from.Ext1;
            to.ExtXoffs = from.ExtXoffs;
            to.ExtYoffs = from.ExtYoffs;
            to.terminate = from.terminate;
        }
        
        public function GetModified():Boolean
        {
            return modified;
        }
        public function SetModified():void
        {
            modified = true;
        }
        public function GetVersion():uint //WORD
        {
            return aall.ah.version & 0xFFFF;
        }
        public function GetNumAction():int
        {
            return aall.ah.numOfAct;
        }
        public function GetNumPattern( actNo:int ):int
        {
            return aall.aa[actNo].numOfPat;
        }
        public function GetNumSprites( actNo:int, patNo:int ):int
        {
            return aall.aa[actNo].aaap[patNo].numOfSpr;
        }
        
        public function GetSound( actNo:int, patNo:int , buf:String ):Boolean
        {
            var id:int = aall.aa[actNo].aaap[patNo].xxx;
            if (id <= 0 || id > aall.numOfSound - 1)
            {
                return false;
            }
            buf = aall.buf[id];
            return true;
        }
        public function GetAniSpeed( actNo:int, speed:Number ):Boolean
        {
            speed = aall.xxx[actNo];
            return true;
        }
        
        public function WriteAct( fname:String ):void
        {
            
        }
        public function WriteActText( fname:String ):void
        {
            
        }
        
        public function GetOffsPoint( point:Point, actNo:int, patNo:int, sprid:int ):void
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0101:
                    point.x = aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs;
                    point.y = aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    point.x = aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs;
                    point.y = aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs;
                    break;
                case 0x0204:
                    point.x = aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs;
                    point.y = aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs;
                    break;
                case 0x0205:
                    point.x = aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs;
                    point.y = aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs;
                    break;
            }
        }
        public function GetSprNoValue( actNo:int, patNo:int, sprId:int ):int
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0101:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo;
                    break;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo;
                    break;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo;
                    break;
            }
            return 0;
        }
        public function GetXMagValue( actNo:int, patNo:int, sprId:int):Number
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].xyMag;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].xMag;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].xMag;
            }
            return 1.0;
        }
        public function GetYMagValue( actNo:int, patNo:int, sprId:int):Number
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].xyMag;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].yMag;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].yMag;
            }
            return 1.0;
        }
        public function GetRotValue( actNo:int, patNo:int, sprId:int):uint
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].rot;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].rot;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].rot;
            }
            return 0;
        }
        public function GetMirrorValue( actNo:int, patNo:int, sprId:int):uint
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version)
            {
                case 0x0101:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn;
                    break;
            }
            return 0;
        }
        public function GetABGRValue( actNo:int, patNo:int, sprId:int):uint
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].color;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].color;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].color;
            }
            return 0xFFFFFFFF;
        }
        public function GetSpTypeValue( actNo:int, patNo:int, sprId:int ):int
        {
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0101:
                    return 0;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].spType;
                    break;
                case 0x0204:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].spType;
                    break;
                case 0x0205:
                    return aall.aa[actNo].aaap[patNo].apsList[sprId].spType;
                    break;
            }
            return 0;
        }
        public function GetExtOffsPoint( point:Point, actNo:int, patNo:int):void
        {
            point.x = aall.aa[actNo].aaap[patNo].ExtXoffs;
            point.y = aall.aa[actNo].aaap[patNo].ExtYoffs;
        }
        
        public function SetXOffsValue( actNo:int,  patNo:int,  sprId:int, val:int):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version)
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xOffs = val;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xOffs = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xOffs = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xOffs = val;
                    break;
            }
        }
        public function SetYOffsValue( actNo:int, patNo:int, sprId:int, val:int):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yOffs = val;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yOffs = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yOffs = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yOffs = val;
                    break;
            }
        }
        public function SetSprNoValue( actNo:int, patNo:int, sprId:int, val:uint, sprW:uint, sprH:uint):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo = val;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprNo = val;
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprW = sprW;
                    aall.aa[actNo].aaap[patNo].apsList[sprId].sprH = sprH;
                    break;
            }
        }
        public function SetXMagValue( actNo:int,  patNo:int,  sprId:int, val:Number):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xyMag = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xMag = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xMag = val;
                    break;
            }
        }
        public function SetYMagValue( actNo:int, patNo:int,sprId:int, val:Number):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].xyMag = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yMag = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].yMag = val;
                    break;
            }
        }
        public function SetRotValue( actNo:int, patNo:int, sprId:int, val:uint):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].rot = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].rot = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].rot = val;
                    break;
            }
        }
        public function SetMirrorValue( actNo:int, patNo:int, sprId:int, val:uint):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version)
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn = val;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].mirrorOn = val;
                    break;
            }
        }
        public function SetABGRValue( actNo:int, patNo:int, sprId:int, val:uint):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].color = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].color = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].color = val;
                    break;
            }
        }
        public function SetSpTypeValue( actNo:int, patNo:int, sprId:int, val:uint):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version)
            {
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].spType = val;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].spType = val;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprId].spType = val;
                    break;
            }
        }
        public function SetExtXValue( actNo:int, patNo:int, val:int):void
        {
            aall.aa[actNo].aaap[patNo].ExtXoffs = val;
        }
        public function SetExtYValue( actNo:int, patNo:int, val:int):void
        {
            aall.aa[actNo].aaap[patNo].ExtYoffs = val;
        }
        
        public function MoveSprite( xOffs:int, yOffs:int, actNo:int, patNo:int, sprid:int):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version)
            {
                case 0x0101:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs += xOffs;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs += yOffs;
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs += xOffs;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs += yOffs;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs += xOffs;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs += yOffs;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xOffs += xOffs;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yOffs += yOffs;
                    break;
            }
        }
        public function MoveExtSprite( xOffs:int,  yOffs:int,  actNo:int,  patNo:int):void
        {
            modified = true;
            aall.aa[actNo].aaap[patNo].ExtXoffs += xOffs;
            aall.aa[actNo].aaap[patNo].ExtYoffs += yOffs;
        }
        public function ChangeMagSprite( xMagRatio:Number, yMagRatio:Number, actNo:int,  patNo:int, sprid:int):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            if (xMagRatio == 0 || yMagRatio == 0) return;
            switch (version) 
            {
                /*
                case 0x0101:
                break;
                */
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xyMag *= xMagRatio;
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xMag *= xMagRatio;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yMag *= yMagRatio;
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].xMag *= xMagRatio;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].yMag *= yMagRatio;
                    break;
            }
        }
        public function ChangeRotSprite( diffRot:int, actNo:int, patNo:int, sprid:int):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            
            switch (version) 
            {
                /*
                case 0x0101:
                break;
                */
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot += diffRot;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot = NormalizeRot( aall.aa[actNo].aaap[patNo].apsList[sprid].rot );
                    break;
                case 0x0204:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot += diffRot;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot = NormalizeRot( aall.aa[actNo].aaap[patNo].apsList[sprid].rot );
                    break;
                case 0x0205:
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot += diffRot;
                    aall.aa[actNo].aaap[patNo].apsList[sprid].rot = NormalizeRot( aall.aa[actNo].aaap[patNo].apsList[sprid].rot );
                    break;
            }
        }
        
        public function AddSpr( actNo:int, patNo:int, sprNo:int,  spType:int, spWidth:int, spHeight:int):void
        {
            modified = true;
            var aaap1:AnyActAnyPat;
            aaap1 = aall.aa[actNo].aaap[patNo];
            
            var version:int = aall.ah.version & 0xFFFF;
            switch (version) 
            {
                case 0x0101:
                    AddSprV0101(aaap1, sprNo, spType);
                    break;
                case 0x0201:
                case 0x0202:
                case 0x0203:
                    AddSprV0201(aaap1, sprNo, spType);
                    break;
                case 0x0204:
                    AddSprV0204(aaap1, sprNo, spType);
                    break;
                case 0x0205:
                    AddSprV0205(aaap1, sprNo, spType, spWidth, spHeight);
                    break;
            }
        }
        public function SwapSpriteOrder( actNo:int, patNo:int, spA:int, spB:int):void
        {
            
        }
        public function DelSpr( actNo:int, patNo:int, sprId:int):void
        {
            
        }
        
        public function AddPat( actNo:int, basePatNo:int):void
        {
            
        }
        public function SwapPat( actNo:int, patA:int, patB:int):void
        {
            modified = true;
            
            var tmpaaap:AnyActAnyPat = new AnyActAnyPat();
            tmpaaap.apsList = null;
            
            CopyAnyActAnyPat( tmpaaap, aall.aa[actNo].aaap[patA] );
            CopyAnyActAnyPat( aall.aa[actNo].aaap[patA], aall.aa[actNo].aaap[patB]);
            CopyAnyActAnyPat( aall.aa[actNo].aaap[patB], tmpaaap);
            
            tmpaaap.apsList = null
        }
        public function DelPat( actNo:int, patNo:int):void
        {
            modified = true;
            var num:int;
            num = aall.aa[actNo].numOfPat;
            
            // Pat is deleted move to last
            for (var i:int=patNo; i<(num-1); i++) 
            {
                SwapPat(actNo, i, i+1);
            }
            num--;
            // delete last
            aall.aa[actNo].aaap[num].apsList = null
            aall.aa[actNo].aaap = new Vector.<AnyActAnyPat>(num);
        }
        public function SlideSprNo( aftThis:int,  plus:Boolean):void
        {
            modified = true;
            var version:int = aall.ah.version & 0xFFFF;
            var offs:int;
            if (plus)
            {
                offs = 1;
            }
            else
            {
                offs = -1;
            }
            for (var i:int=0; i<aall.ah.numOfAct; i++) 
            {
                for (var j:int=0; j<aall.aa[i].numOfPat; j++) {
                    switch (version) 
                    {
                        case 0x0101:
                            for (var k:int=aftThis; k<aall.aa[i].aaap[j].numOfSpr; k++) 
                            {
                                aall.aa[i].aaap[j].apsList[k].sprNo += offs;
                            }
                            break;
                        case 0x0201:
                        case 0x0202:
                        case 0x0203:
                            for ( k=aftThis; k<aall.aa[i].aaap[j].numOfSpr; k++) 
                            {
                                aall.aa[i].aaap[j].apsList[k].sprNo += offs;
                            }
                            break;
                        case 0x0204:
                            for ( k=aftThis; k<aall.aa[i].aaap[j].numOfSpr; k++) 
                            {
                                aall.aa[i].aaap[j].apsList[k].sprNo += offs;
                            }
                            break;
                        case 0x0205:
                            for ( k=aftThis; k<aall.aa[i].aaap[j].numOfSpr; k++) 
                            {
                                aall.aa[i].aaap[j].apsList[k].sprNo += offs;
                            }
                            break;
                    }
                }
            }
        }
        
        public function CopyAction( destActNo:int, srcActNo:int):void
        {
            var numPat:int = aall.aa[destActNo].numOfPat;
            // free destAct
            for (var i:int=0; i<numPat; i++) 
            {
                aall.aa[destActNo].aaap[i].apsList = null;
            }
            
            numPat = aall.aa[srcActNo].numOfPat;
            aall.aa[destActNo].numOfPat = numPat;
            aall.aa[destActNo].aaap = new AnyActAnyPat[ numPat ];
            var numSpr:int;
            for ( i=0; i<numPat; i++) 
            {
                aall.aa[destActNo].aaap[i].ph = aall.aa[srcActNo].aaap[i].ph;
                numSpr = aall.aa[destActNo].aaap[i].numOfSpr = aall.aa[srcActNo].aaap[i].numOfSpr;
                MemAllocAnyPatAnySpr(destActNo, i, aall.ah.version & 0xFFFF);
                for (var j:int=0; j<numSpr; j++) 
                {
                    switch (aall.ah.version & 0xFFFF) 
                    {
                        case 0x0101:
                            aall.aa[destActNo].aaap[i].apsList[j] = aall.aa[srcActNo].aaap[i].apsList[j];
                            break;
                        case 0x0201:
                        case 0x0202:
                        case 0x0203:
                            aall.aa[destActNo].aaap[i].apsList[j] = aall.aa[srcActNo].aaap[i].apsList[j];
                            break;
                        case 0x0204:
                            aall.aa[destActNo].aaap[i].apsList[j] = aall.aa[srcActNo].aaap[i].apsList[j];
                            break;
                        case 0x0205:
                            aall.aa[destActNo].aaap[i].apsList[j] = aall.aa[srcActNo].aaap[i].apsList[j];
                            break;
                    }
                }
                aall.aa[destActNo].aaap[i].xxx = aall.aa[srcActNo].aaap[i].xxx;
                aall.aa[destActNo].aaap[i].numxxx = aall.aa[srcActNo].aaap[i].numxxx;
                aall.aa[destActNo].aaap[i].Ext1 = aall.aa[srcActNo].aaap[i].Ext1;
                aall.aa[destActNo].aaap[i].ExtXoffs = aall.aa[srcActNo].aaap[i].ExtXoffs;
                aall.aa[destActNo].aaap[i].ExtYoffs = aall.aa[srcActNo].aaap[i].ExtYoffs;
                aall.aa[destActNo].aaap[i].terminate = aall.aa[srcActNo].aaap[i].terminate;
            }
        }
    }
}