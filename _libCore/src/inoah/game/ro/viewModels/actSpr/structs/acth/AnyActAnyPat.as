package inoah.game.ro.viewModels.actSpr.structs.acth
{
    
    public class AnyActAnyPat
    {
        public var ph:PatHeader;
        public var numOfSpr:uint; //DWORD
        public var apsList:Vector.<AnyPatSprV0101>;
        public var xxx:uint; //DWORD       //音效id，无声时为FFFF FFFF，设定之后，动画进行到这个frame会播放对应音效
        public var numxxx:uint; //DWORD    //An int boolean to tell if there's extra info attached to this frame
        public var Ext1:uint; //DWORD      //don't know
        public var ExtXoffs:int;    //extraX
        public var ExtYoffs:int;    //extraY
        public var terminate:uint; //DWORD  //some useful info, but haven't use it yet.
        
        public function AnyActAnyPat()
        {
        }
    }
}