#!/bin/bash

JQUERY=1.9.1
JQUERYUI=1.10.1
JQUERYFORMWIZARD=3.0.7
QUNIT=1.10.0

VERSION=021

if git tag -l | grep -q $VERSION
then
	echo "You should update the version string and rerun the update script"
	exit -1
fi

mkdir -p code
pushd code
#http://www.splitbrain.org/projects/file_iconsA
wget -O fileicons.zip 'http://www.splitbrain.org/lib/exe/fetch.php?hash=92529a&media=http%3A%2F%2Fwww.splitbrain.org%2F_static%2Ffileicons.zip'
wget -O jquery.min.js http://code.jquery.com/jquery-$JQUERY.min.js
wget -O jquery.js http://code.jquery.com/jquery-$JQUERY.js
wget -O jquery-jtemplates.js http://jtemplates.tpython.com/jTemplates/jquery-jtemplates.js
#../form-download.py -f jquery-ui-$JQUERYUI.custom.zip
wget -O jquery-ui.zip http://jqueryui.com/resources/download/jquery-ui-$JQUERYUI.custom.zip
wget -O jquery-ui-themes.zip http://jqueryui.com/resources/download/jquery-ui-themes-$JQUERYUI.zip
wget -O qunit.js http://code.jquery.com/qunit/qunit-$QUNIT.js
wget -O qunit.css http://code.jquery.com/qunit/qunit-$QUNIT.css
rm -rf r.js
git clone https://github.com/jrburke/r.js.git
rm -rf qTip2
git clone https://github.com/Craga89/qTip2.git
rm -rf jQuery-Timepicker-Addon
git clone https://github.com/trentrichardson/jQuery-Timepicker-Addon.git
wget -O jquery.formwizard-$JQUERYFORMWIZARD.zip https://github.com/thecodemine/formwizard/zipball/v3.0.7
wget -O modernizr.js http://modernizr.com/downloads/modernizr.js
wget -O almond.js https://raw.github.com/jrburke/almond/master/almond.js
rm -rf JSON-js
git clone https://github.com/douglascrockford/JSON-js
wget -O jquery.timeago.js http://timeago.yarp.com/jquery.timeago.js
wget https://github.com/aFarkas/html5shiv/zipball/master -O html5shiv.zip
wget -O jquery.ui.selectmenu.css http://view.jqueryui.com/selectmenu/themes/base/jquery.ui.selectmenu.css
wget -O jquery.ui.selectmenu.js http://view.jqueryui.com/selectmenu/ui/jquery.ui.selectmenu.js
git clone https://github.com/andrefigueira/json-formatter.git

cp json-formatter/src/jaysun.1.0.js jaysun.js

for x in r.js qTip2 jQuery-Timepicker-Addon JSON-js
do
        pushd $x
        git log > git-log
        rm -rf .git
        popd
done

mkdir html5shiv
pushd html5shiv
unzip -o ../html5shiv.zip
mv */dist/* ..
popd
rm -rf html5shiv/
rm -f html5shiv.zip

unzip -o jquery-ui.zip
unzip -o jquery-ui-themes.zip
rm -rf jquery-ui
mv jquery-ui-$JQUERYUI.custom jquery-ui
mv jquery-ui/css jquery-ui/css-old
mv jquery-ui-themes-$JQUERYUI/themes jquery-ui/css
mv jquery-ui/js/jquery-$JQUERY.js jquery-ui/js/jquery.js
mv jquery-ui/js/jquery-ui-$JQUERYUI.custom.js jquery-ui/js/jquery-ui.js
mv jquery-ui/js/jquery-ui-$JQUERYUI.custom.min.js jquery-ui/js/jquery-ui.min.js
mv jquery-ui/css/ui-lightness/jquery-ui-$JQUERYUI.custom.min.css jquery-ui/css/ui-lightness/jquery-ui.min.css
mv jquery-ui/css/ui-lightness/jquery-ui-$JQUERYUI.custom.css jquery-ui/css/ui-lightness/jquery-ui.css
rm -f jquery-ui-$JQUERYUI.zip
rm -rf jquery.formwizard
mkdir jquery.formwizard
pushd jquery.formwizard
unzip -o ../jquery.formwizard-$JQUERYFORMWIZARD.zip
mv thecodemine-formwizard-*/* .
rmdir thecodemine-formwizard-*
popd
rm -f jquery.formwizard-$JQUERYFORMWIZARD.zip
unzip -o fileicons.zip
rm -f fileicons.zip

popd
sed 's/@VERSION@/'$VERSION'/g' myemsl-builddeps.spec.in > myemsl-builddeps.spec
git add -A code
git commit -a -m "Auto Update to $VERSION"
git tag $VERSION
