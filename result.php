<?php
error_reporting(0);
$appservlang = $_GET['appservlang'];
switch ($appservlang) {
	case "es" :
		$appservlang = "es";
	break;
	default :
		$appservlang = "en";
	break;
}

print "<html>
<head>
<title>IKKI</title>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<style>
<!-- Hide style for old browsers 
BODY {font-family: Tahoma;font-size=\"10\"}
.headd { font-family: Tahoma ; font-size: 13pt; text-decoration:  none; }
.app { font-family: Tahoma ; font-size: 13pt; text-decoration:  none; }
.supp { font-family: Tahoma ; font-size: 20pt; text-decoration:  none; }
A:link    {font-family: Tahoma ; text-decoration: none; color: #0000FF}
A:visited {font-family: Tahoma ; text-decoration: none; color: #0000FF}
A:hover   {font-family: Tahoma ; text-decoration: none; color: #FF0000}
A:active  {font-family: Tahoma ; text-decoration: none; color: #FF0000}
-->
</style>
</head>
<body bgcolor=\"#FFFFFF\">
";
?>
  
<?php
// Conectando, seleccionando la base de datos
$link = mysql_connect('localhost:3306', 'root', '12345678')
    or die('No se pudo conectar: ' . mysql_error());
echo 'Connected successfully';
mysql_select_db('ikki') or die('No se pudo seleccionar la base de datos');

// Realizar una consulta MySQL
$query = 'SELECT * FROM v_resultado';
$result = mysql_query($query) or die('Consulta fallida: ' . mysql_error());

// Imprimir los resultados en HTML
echo "<table border='2' width='100%' style='text-align:center'>\n";

while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
	
	if(empty($head)) 
    { 
      $keys = array_keys($line); 
      $head = '<tr><th>' . implode('</th><th>', $keys). '</th></tr>'; 
	  echo $head;
    }
	
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Liberar resultados
mysql_free_result($result);

// Cerrar la conexión
mysql_close($link);

print "</body>
</html>
";
?>