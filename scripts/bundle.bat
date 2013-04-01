set PATH=%PATH%;c:\wix
heat dir "code" -srd -cg PacificaBuilddeps -gg -sfrag -dr BUILDDEPSDIR -var var.PacificaBuilddeps -out pacificabuilddeps.wxs || goto :error
candle pacificabuilddepssdk.wxs pacificabuilddeps.wxs -dPacificaBuilddeps=code || goto :error
light -out pacificabuilddeps pacificabuilddeps.wixobj pacificabuilddepssdk.wixobj || goto :error
exit /b 0

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%

