/**Created by Morn,Do not modify.*/
package game.ui.sysViews {
	import morn.core.components.*;
	public class itemViewUI extends Dialog {
		public var btnClose:Button;
		protected var uiXML:XML =
			<Dialog dragArea="0,0,900,500">
			  <Image url="png.basic_interface.itemwin_left" x="0" y="17"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="25"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="33"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="41"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="49"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="57"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="65"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="73"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="81"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="89"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="97"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="105"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="113"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="121"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="129"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="137"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="145"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="153"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="161"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="169"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="177"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="185"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="193"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="201"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="209"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="217"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="225"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="233"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="241"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="249"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="257"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="265"/>
			  <Image url="png.basic_interface.itemwin_left" x="0" y="273"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="17"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="25"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="33"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="41"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="49"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="57"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="65"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="73"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="81"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="89"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="97"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="105"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="113"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="121"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="129"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="137"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="145"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="153"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="161"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="169"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="177"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="185"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="193"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="201"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="209"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="217"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="225"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="233"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="241"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="249"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="257"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="265"/>
			  <Image url="png.basic_interface.itemwin_right" x="260" y="273"/>
			  <Image url="png.basic_interface.btnbar_left" x="0" y="273"/>
			  <Image url="png.basic_interface.btnbar_mid" x="21" y="273" width="240" height="21"/>
			  <Image url="png.basic_interface.btnbar_right" x="259" y="273"/>
			  <Image url="png.basic_interface.titlebar_fix" x="0" y="0"/>
			  <Button skin="png.basic_interface.btn_sys_close" x="267" y="2" var="btnClose" name="btnClose"/>
			  <Container x="20" y="17">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="49">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="81">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="113">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="145">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="177">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="209">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Container x="20" y="241">
			    <Image url="png.basic_interface.itemwin_mid"/>
			    <Image url="png.basic_interface.itemwin_mid" x="32"/>
			    <Image url="png.basic_interface.itemwin_mid" x="64"/>
			    <Image url="png.basic_interface.itemwin_mid" x="128"/>
			    <Image url="png.basic_interface.itemwin_mid" x="96"/>
			    <Image url="png.basic_interface.itemwin_mid" x="160"/>
			    <Image url="png.basic_interface.itemwin_mid" x="192"/>
			    <Image url="png.basic_interface.itemwin_mid" x="224"/>
			  </Container>
			  <Label text="item" x="18" y="-1" size="12"/>
			  <Button skin="png.basic_interface.btn_sys_base" x="3" y="3"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}