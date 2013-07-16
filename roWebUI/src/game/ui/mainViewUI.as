/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class mainViewUI extends View {
		public var btnStatus:Button;
		public var btnItem:Button;
		public var btnMap:Button;
		public var btnOption:Button;
		public var btnTask:Button;
		public var btnSkill:Button;
		public var labChat:Label;
		public var txtChat:TextInput;
		public var imgLeft:Image;
		public var imgBar:Image;
		public var imgRIght:Image;
		public var labVal:Label;
		public var labName:Label;
		public var labJob:Label;
		public var labHp:Label;
		public var labSp:Label;
		public var labLv:Label;
		public var labJobLv:Label;
		public var labWeightZeny:Label;
		private var uiXML:XML =
			<View height="100">
			  <Image url="png.basic_interface.dialog_bg" x="0" y="535"/>
			  <Button skin="png.basic_interface.btn_info" x="0" y="135" var="btnStatus" name="btnStatus"/>
			  <Button skin="png.basic_interface.btn_item" x="108" y="135" var="btnItem" name="btnItem"/>
			  <Button skin="png.basic_interface.btn_map" x="162" y="135" var="btnMap" name="btnMap"/>
			  <Button skin="png.basic_interface.btn_option" x="54" y="153" var="btnOption" name="btnOption"/>
			  <Button skin="png.basic_interface.btn_quest" x="0" y="153" var="btnTask" name="btnTask"/>
			  <Button skin="png.basic_interface.btn_skill" x="54" y="135" var="btnSkill" name="btnSkill"/>
			  <Image url="png.comp.blank" x="1" y="433" width="600" height="100"/>
			  <Image url="png.basic_interface.basewin_bg2" x="0" y="0"/>
			  <Label text="label" x="1" y="433" width="600" height="100" multiline="true" align="left" mouseChildren="true" mouseEnabled="true" isHtml="true" wordWrap="false" var="labChat" name="labChat"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="108" y="538" width="464" height="18" var="txtChat" name="txtChat"/>
			  <Box x="35" y="50">
			    <Image url="png.basic_interface.gzeblue_left" var="imgLeft" name="imgLeft" y="3"/>
			    <Image url="png.basic_interface.gzeblue_mid" x="4" y="4" width="128" var="imgBar" name="imgBar"/>
			    <Image url="png.basic_interface.gzeblue_right" x="130" y="3" var="imgRIght" name="imgRIght"/>
			    <Label text="100 / 100" x="4" size="9" align="center" height="14" width="128" var="labVal" name="labVal" y="0"/>
			  </Box>
			  <Label text="name" x="10" y="18" size="12" var="labName" name="labName"/>
			  <Label text="Novice" x="9" y="32" size="12" var="labJob" name="labJob"/>
			  <Label text="HP" x="14" y="48" size="11"/>
			  <Label text="base info window" x="13" y="-2" size="12"/>
			  <Label text="SP" x="13" y="64" size="11"/>
			  <Label text="100%" x="175" y="48" size="11" var="labHp" name="labHp"/>
			  <Label text="100%" x="175" y="64" size="11" var="labSp" name="labSp"/>
			  <Label text="Base Lv.1" x="11" y="84" size="9" var="labLv" name="labLv"/>
			  <Label text="Job Lv.1" x="12" y="96" size="9" var="labJobLv" name="labJobLv"/>
			  <Label text="Weight: 0 / 1000 Zeny: 10,000" x="54" y="116" size="11" align="right" var="labWeightZeny" name="labWeightZeny"/>
			  <Image url="png.basic_interface.shortitem_bg" x="679" y="525"/>
			  <Tab labels="chat,battle" skin="png.comp.tab" x="0" y="406"/>
			  <Button skin="png.basic_interface.btn_sys_base" x="3" y="3"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}