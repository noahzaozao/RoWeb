/**Created by Morn,Do not modify.*/
package game.ui.sysViews {
	import morn.core.components.*;
	public class statusViewUI extends Dialog {
		public var btnClose:Button;
		public var btnStr:Button;
		public var btnAgi:Button;
		public var btnVit:Button;
		public var btnInt:Button;
		public var btnDex:Button;
		public var btnLuk:Button;
		public var labStr:Label;
		public var labAgi:Label;
		public var labVit:Label;
		public var labInt:Label;
		public var labDex:Label;
		public var labLuk:Label;
		public var labUpStr:Label;
		public var labUpAgi:Label;
		public var labUpVit:Label;
		public var labUpInt:Label;
		public var labUpDex:Label;
		public var labUpLuk:Label;
		public var labAtk:Label;
		public var labMAtk:Label;
		public var labHit:Label;
		public var labCritical:Label;
		public var labStatusPoint:Label;
		public var labDef:Label;
		public var labMDef:Label;
		public var labFlee:Label;
		public var labAspd:Label;
		private var uiXML:XML =
			<Dialog dragArea="0,0,900,500">
			  <Image url="png.basic_interface.statwin_bg" x="0" y="146"/>
			  <Image url="png.basic_interface.titlebar_fix" x="0" y="0"/>
			  <Image url="png.basic_interface.equipwin_bg" x="0" y="17"/>
			  <Button skin="png.basic_interface.btn_sys_base" x="3" y="3"/>
			  <Button skin="png.basic_interface.btn_sys_close" x="266" y="3" var="btnClose" name="btnClose"/>
			  <Label text="equip" x="17" y="-2" size="12"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="153" var="btnStr" name="btnStr"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="169" var="btnAgi" name="btnAgi"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="185" var="btnVit" name="btnVit"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="201" width="11" height="11" var="btnInt" name="btnInt"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="217" var="btnDex" name="btnDex"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="233" var="btnLuk" name="btnLuk"/>
			  <Label text="99" x="38" y="150" size="11" width="40" height="18" align="center" var="labStr" name="labStr"/>
			  <Label text="99" x="38" y="166" size="11" width="40" height="18" align="center" var="labAgi" name="labAgi"/>
			  <Label text="99" x="38" y="182" size="11" width="40" height="18" align="center" var="labVit" name="labVit"/>
			  <Label text="99" x="38" y="198" size="11" width="40" height="18" align="center" var="labInt" name="labInt"/>
			  <Label text="99" x="38" y="214" size="11" width="40" height="18" align="center" var="labDex" name="labDex"/>
			  <Label text="99" x="38" y="230" size="11" width="40" height="18" align="center" var="labLuk" name="labLuk"/>
			  <Label text="99" x="86" y="150" size="11" width="20" height="18" align="center" var="labUpStr" name="labUpStr"/>
			  <Label text="99" x="86" y="166" size="11" width="20" height="18" align="center" var="labUpAgi" name="labUpAgi"/>
			  <Label text="99" x="86" y="182" size="11" width="20" height="18" align="center" var="labUpVit" name="labUpVit"/>
			  <Label text="99" x="86" y="198" size="11" width="20" height="18" align="center" var="labUpInt" name="labUpInt"/>
			  <Label text="99" x="86" y="214" size="11" width="20" height="18" align="center" var="labUpDex" name="labUpDex"/>
			  <Label text="99" x="86" y="230" size="11" width="20" height="18" align="center" var="labUpLuk" name="labUpLuk"/>
			  <Label text="99" x="144" y="148" size="11" width="50" height="18" align="right" var="labAtk" name="labAtk"/>
			  <Label text="99" x="144" y="164" size="11" width="50" height="18" align="right" var="labMAtk" name="labMAtk"/>
			  <Label text="99" x="144" y="180" size="11" width="50" height="18" align="right" var="labHit" name="labHit"/>
			  <Label text="99" x="144" y="196" size="11" width="50" height="18" align="right" var="labCritical" name="labCritical"/>
			  <Label text="99" x="225" y="212" size="11" width="50" height="18" align="right" var="labStatusPoint" name="labStatusPoint"/>
			  <Label text="99" x="226" y="148" size="11" width="50" height="18" align="right" var="labDef" name="labDef"/>
			  <Label text="99" x="226" y="164" size="11" width="50" height="18" align="right" var="labMDef" name="labMDef"/>
			  <Label text="99" x="226" y="181" size="11" width="50" height="18" align="right" var="labFlee" name="labFlee"/>
			  <Label text="99" x="226" y="196" size="11" width="50" height="18" align="right" var="labAspd" name="labAspd"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}