<?php
// for get URL ffrom App
$url = $_GET['URL'];
if($url){
$rand = 'q1w2e3r4t5y6u7i7o8p9asdf7g5h7j8k7l5z4x6cv8b8n9m';
$rand2= substr(str_shuffle($rand),1,5);

$plist = "
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<!-- array of downloads. -->
<key>items</key>
<array>
<dict>
<!-- an array of assets to download -->
<key>assets</key>
<array>
<dict>
<!-- required. the asset kind. -->
<key>kind</key>
<string>software-package</string>
<key>url</key>
<string>$url</string>
</dict>
<dict>
<key>kind</key>
<string>display-image</string>
<key>needs-shine</key>
<true/>
<key>url</key>
<string>https://pbs.twimg.com/profile_images/1289750114622410759/TAGmdLBC_400x400.jpg</string>
</dict>
<dict>
<key>kind</key>
<string>full-size-image</string>
<key>needs-shine</key>
<true/>
<key>url</key>
<string>https://pbs.twimg.com/profile_images/1289750114622410759/TAGmdLBC_400x400.jpg</string>
</dict>
</array>
<key>metadata</key>
<dict>
<key>bundle-identifier</key>
<string>co.azozzalfiras.$rand2</string>
<key>bundle-version</key>
<string>5.4</string>
<key>kind</key>
<string>software</string>
<key>title</key>
<string>
install Application
by Azozz ALFiras
twitter   : @AzozzALFiras
snapchat  : @n.uf
by AZinstaller
</string>
</dict>
</dict>
</array>
</dict>
</plist>

";

file_put_contents(__DIR__.'/plist/'.$rand2.".plist",$plist);


// chanage location to your site
$pathinstall = "location"."/plist/$rand2".".plist";



$action ="itms-services://?action=download-manifest&url=";

$goplist= "$action$pathinstall";
// if chanage Status to NO or other will stopped 
$classOutput = array(
'Status' => "Yes",
'Version' => "1.0",
'azfURL'=> $goplist
);
echo json_encode($classOutput, JSON_PRETTY_PRINT);



die();

}

?>
