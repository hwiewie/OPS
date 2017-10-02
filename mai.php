<head>
<script language="javascript">
function check_alla(obj)
{
	var checkboxs0 = document.getElementsByName("Product_1");
	for(var i=0;i<checkboxs0.length;i++){checkboxs0[i].checked = obj.checked;}
    var checkboxs1 = document.getElementsByName("FE_1");
    for(var i=0;i<checkboxs1.length;i++){checkboxs1[i].checked = obj.checked;}
	var checkboxs2 = document.getElementsByName("APP_1");
	for(var i=0;i<checkboxs2.length;i++){checkboxs2[i].checked = obj.checked;}
} 
function check_allb(obj)
{
	var checkboxs0 = document.getElementsByName("Product_2");
	for(var i=0;i<checkboxs0.length;i++){checkboxs0[i].checked = obj.checked;}
    var checkboxs1 = document.getElementsByName("FE_2");
    for(var i=0;i<checkboxs1.length;i++){checkboxs1[i].checked = obj.checked;}
	var checkboxs2 = document.getElementsByName("APP_2");
	for(var i=0;i<checkboxs2.length;i++){checkboxs2[i].checked = obj.checked;}
} 
function check_allp1(obj,ee)
{
	var checkboxs0 = document.getElementsByName("Product_1");
    var checkboxs1 = document.getElementsByName("FE_1");
    checkboxs1[ee].checked = obj.checked;
	var checkboxs2 = document.getElementsByName("APP_1");
	checkboxs2[ee].checked = obj.checked;
	if ( obj.checked ==false ) {
		checkboxs0[0].checked = obj.checked;
		checkboxs1[0].checked = obj.checked;
		checkboxs2[0].checked = obj.checked;
	} else {
		var tempa='t';
		for(var i=1;i<checkboxs0.length;i++){if(checkboxs0[i].checked == false){tempa ='f';}}
		if (tempa == 't') { checkboxs0[0].checked = obj.checked; checkboxs1[0].checked = obj.checked;checkboxs2[0].checked = obj.checked;}
	}
}
function check_allp2(obj,ee)
{
	var checkboxs0 = document.getElementsByName("Product_2");
    var checkboxs1 = document.getElementsByName("FE_2");
    checkboxs1[ee].checked = obj.checked;
	var checkboxs2 = document.getElementsByName("APP_2");
	checkboxs2[ee].checked = obj.checked;
	if ( obj.checked ==false ) {
		checkboxs0[0].checked = obj.checked;
		checkboxs1[0].checked = obj.checked;
		checkboxs2[0].checked = obj.checked;
	}else {
		var tempa='t';
		for(var i=1;i<checkboxs0.length;i++){if(checkboxs0[i].checked == false){tempa ='f';}}
		if (tempa == 't') { checkboxs0[0].checked = obj.checked; checkboxs1[0].checked = obj.checked;checkboxs2[0].checked = obj.checked;}
	}
} 
function check_allh1(obj,cName)
{
	var checkboxs0 = document.getElementsByName("Product_1");
    var checkboxs1 = document.getElementsByName(obj.name);
	var checkboxs2 = document.getElementsByName(cName);
	
	var tempa='t';
    for(var i=1;i<checkboxs1.length;i++){checkboxs1[i].checked = obj.checked;}
	if (obj.checked == true){
		for(var i=0;i<checkboxs2.length;i++){
			if( checkboxs2[i].checked == obj.checked){
				checkboxs0[i].checked = obj.checked;
			}
		}
	} else {
		for(var i=0;i<checkboxs0.length;i++){checkboxs0[i].checked = obj.checked;}
	}
}
function check_allh2(obj,cName)
{
	var checkboxs0 = document.getElementsByName("Product_2");
    var checkboxs1 = document.getElementsByName(obj.name);
	var checkboxs2 = document.getElementsByName(cName);
	
	var tempa='t';
    for(var i=1;i<checkboxs1.length;i++){checkboxs1[i].checked = obj.checked;}
	if (obj.checked == true){
		for(var i=0;i<checkboxs2.length;i++){
			if( checkboxs2[i].checked == true){
				checkboxs0[i].checked = obj.checked;
			}
		}
	} else {
		for(var i=0;i<checkboxs0.length;i++){checkboxs0[i].checked = obj.checked;}
	}
}
function check_cancel(obj,ee)
{
	if ( obj.name == 'FE_1') {
		var product = 'Product_1';
		var another = 'APP_1';
	}else if (obj.name == 'FE_2'){
		var product = 'Product_2';
		var another = 'APP_2';
	}else if (obj.name == 'APP_1'){
		var product = 'Product_1';
		var another = 'FE_1';
	}else if (obj.name == 'APP_2'){
		var product = 'Product_2';
		var another = 'FE_2';
	}
	var checkboxs1 = document.getElementsByName(obj.name);
	if ( obj.checked == false ){
        checkboxs1[0].checked = obj.checked;
	    var checkboxs0 = document.getElementsByName(product);
		checkboxs0[0].checked = obj.checked;
		checkboxs0[ee].checked = obj.checked;
	}else{
		var tempa='t';
		var checkboxs2 = document.getElementsByName(another);
	    if ( checkboxs2[ee].checked == true ) {
			checkboxs0[ee].checked = obj.checked;
	    }
		for(var i=1;i<checkboxs0.length;i++){if(checkboxs0[i].checked == false){tempa ='f';}}
		if (tempa == 't') { checkboxs0[ee].checked = obj.checked; }
	}
} 
function execsalt() {
	var checkboxs0 = document.getElementsByName("product_1")
	for(var i=1;i<checkboxs0.length;i++){
		if (checkboxs0[i].checked){
			var spawn = require('child_process').spawn;
			var ls  = spawn('sudo salt "'+checkboxs0[i].value+'" test.ping');
			ls.stdout.on('data', function (data) {
				console.log(data);
			});
			
		}
	}
	document.getElementsByName('result').innerHTML = data;
}
</script>
</head>
<h2 style="text-align: center;"><span style="text-decoration: underline;"><strong><em>反帶維護設定</em></strong></span></h2>
<p>說明：</p>
<p>1.請依照需求勾選要維護的品牌與服務</p>
<p>2.若要維護某個品牌的所有服務，可以直接勾選品牌代碼(001~025)的核取方塊</p>
<p>3.若要維護所有品牌的某個服務，可以直接勾選該服務的核取方塊</p>
<p>4.若要維護所有品牌的前台與APP，可以直接勾左上的核取方塊</p>
<p></p>
<p>salt用法</P>
<p>sudo salt "018*fe*" cmd.run "/root/ma_fe_start.sh"</P>
<p>說明：sudo 切換成root ，salt 主程式，"018*fe*" 品牌18的前台，"018*app*" 品牌18的app，cmd.run 執行外部程式，"/root/ma_fe_start.sh" 開前台維設的bash，同理"/root/ma_app_stop.sh"是app關維護的bash</p>
<table style="height: 247px; width: 819px;">
  <tbody>
    <tr>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_alla(this)" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,1)" value="001" />001</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,2)" value="002" />002</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,3)" value="003" />003</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,4)" value="004" />004</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,5)" value="005" />005</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,6)" value="006" />006</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,7)" value="007" />007</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,8)" value="008" />008</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,9)" value="009" />009</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,10)" value="010" />010</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,11)" value="011" />011</td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" onclick="check_allp1(this,12)" value="012" />012</td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onclick="check_allh1(this,'APP_1')" value="*fe*" />前台</td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,1)" value="001-500vip-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,2)" value="002-cai33-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,3)" value="003-cai99-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,4)" value="004-hck-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,5)" value="005-hcp-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,6)" value="006-cai77-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,7)" value="007-cai8-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,8)" value="008-sscp-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,9)" value="009-bale-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,10)" value="010-lck-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,11)" value="011-cp58-fe*" /></td>
      <td style="width: 56px;"><input name="FE_1" type="checkbox" onchange="check_cancel(this,12)" value="012-fhcp-fe*" /></td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" onclick="check_allh1(this,'FE_1')" value="1" />APP</td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="001-500vip-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="002-cai33-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="003-cai99-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="004-hck-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="005-hcp-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="006-cai77-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="007-cai8-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="008-sscp-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="009-bale-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="010-lck-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="011-cp58-app*" /></td>
      <td style="width: 56px;"><input name="APP_1" type="checkbox" value="012-fhcp-app*" /></td>
    </tr>
    <!--<tr>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
    </tr>-->
    <tr>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allb(this)" value="" /></td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,1)" value="014" />014</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,2)" value="015" />015</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,3)" value="016" />016</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,4)" value="017" />017</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,5)" value="018" />測試</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,6)" value="019" />019</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,7)" value="020" />020</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,8)" value="021" />021</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,9)" value="022" />022</td>
      <td style="width: 56px;"></td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,10)" value="024" />024</td>
      <td style="width: 56px;"><input name="Product_2" type="checkbox" onclick="check_allp2(this,11)" value="025" />025</td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" onclick="check_allh2(this,'APP_2')" value="*fe*" />前台</td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="014-cp35-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="015-CBCP-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="016-cp256-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="017-tjcp-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="018-cp1-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="019-cp66-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="020-w9-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="021-dyj-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="022-cp699-fe*" /></td>
      <td style="width: 56px;"></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="024-cp728-fe*" /></td>
      <td style="width: 56px;"><input name="FE_2" type="checkbox" value="025-wcp-fe*" /></td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" onclick="check_allh2(this,'FE_2')" value="1" />APP</td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="014-cp35-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="015-CBCP-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="016-cp256-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="017-tjcp-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="018-cp1-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="019-cp66-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="020-w9-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="021-dyj-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="022-cp699-app*" /></td>
      <td style="width: 56px;"></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="024-cp728-app*" /></td>
      <td style="width: 56px;"><input name="APP_2" type="checkbox" value="025-wcp-app*" /></td>
    </tr>
    <!--<tr>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
    </tr>
    <tr>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
      <td style="width: 56px;"><input name="Product_1" type="checkbox" value="1" /></td>
    </tr>-->
  </tbody>
</table>
<input type="button" value="開始" style="width:120px;height:40px;border:2px #9999FF dashed;" onclick="execsalt()" />
<input type="button" value="結束" style="width:120px;height:40px;border:3px orange double;" />
<p><textarea cols="300" name="resulta" rows="20"></textarea></p>
<?php
$last_line = system('sudo salt "018*fe*" test.ping', $retval);
echo 'Last line of the output: ' . $last_line;
echo '<hr />Return value: ' . $retval;
?>
