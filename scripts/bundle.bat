set PATH=%PATH%;c:\wix
heat dir "code" -srd -cg MyEMSLBuilddeps -gg -sfrag -dr BUILDDEPSDIR -var var.MyEMSLBuilddeps -out myemslbuilddeps.wxs || goto :error
candle myemslbuilddepssdk.wxs myemslbuilddeps.wxs -dMyEMSLBuilddeps=code || goto :error
light -out myemslbuilddeps myemslbuilddeps.wixobj myemslbuilddepssdk.wixobj || goto :error
exit /b 0

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%

