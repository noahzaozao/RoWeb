/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class statusViewUI extends Dialog {
		public var btnClose:Button;
		private var uiXML:XML =
			<Dialog>
			  <Image url="png.basic_interface.statwin_bg" x="0" y="146"/>
			  <Image url="png.basic_interface.titlebar_fix" x="0" y="0"/>
			  <Image url="png.basic_interface.equipwin_bg" x="0" y="17"/>
			  <Button skin="png.basic_interface.btn_sys_base" x="3" y="3"/>
			  <Button skin="png.basic_interface.btn_sys_close" x="266" y="3" var="btnClose" name="btnClose"/>
			  <Label text="equip" x="17" y="-2" size="12"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="153"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="169"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="185"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="201" width="11" height="11"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="217"/>
			  <Button skin="png.basic_interface.btn_arw_right" x="79" y="233"/>
			  <Label text="99" x="38" y="150" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="38" y="166" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="38" y="182" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="38" y="198" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="38" y="214" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="38" y="230" size="11" width="40" height="18" align="center"/>
			  <Label text="99" x="86" y="150" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="86" y="166" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="86" y="182" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="86" y="198" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="86" y="214" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="86" y="230" size="11" width="20" height="18" align="center"/>
			  <Label text="99" x="144" y="148" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="144" y="164" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="144" y="180" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="144" y="196" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="225" y="212" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="226" y="148" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="226" y="164" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="226" y="181" size="11" width="50" height="18" align="right"/>
			  <Label text="99" x="226" y="196" size="11" width="50" height="18" align="right"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}