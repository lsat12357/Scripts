$cookie = "";
$list = "listpdf.txt";
$lines = file($list);
$baseurl = "";
foreach($lines as $line){
  $line_arr = explode("\t", $line);
  $fileid = trim($line_arr[0]);
  $filename = trim($line_arr[1]);
  echo "processing " . $fileid . " " . $filename . "\n";
  $fp = fopen($filename, 'w+');
  $URL = "{$baseurl}/File.php?F=" . $fileid . "&download=1";
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $URL);
  curl_setopt($ch, CURLOPT_FILE, $fp); 
  curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: text/plain; charset=UTF-8','Cookie: '.$cookie ));
  curl_exec($ch);
  fclose($fp);
  sleep(3);
}
