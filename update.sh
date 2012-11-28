#!/bin/bash

JQUERY=1.8.1
JQUERYUI=1.8.23
JQUERYFORMWIZARD=3.0.5
QUNIT=1.10.0

VERSION=010

if git tag -l | grep -q $VERSION
then
	echo "You should update the version string and rerun the update script"
	exit -1
fi

mkdir -p code
pushd code
wget -O jquery-$JQUERY.min.js http://code.jquery.com/jquery-$JQUERY.min.js
wget -O jquery-$JQUERY.js http://code.jquery.com/jquery-$JQUERY.js
wget -O jquery-ui-$JQUERYUI.custom.zip http://jqueryui.com/download/jquery-ui-$JQUERYUI.custom.zip
wget -O qunit-$QUNIT.js http://code.jquery.com/qunit/qunit-$QUNIT.js
wget -O qunit-$QUNIT.css http://code.jquery.com/qunit/qunit-$QUNIT.css
git clone https://github.com/jrburke/r.js.git
git clone https://github.com/Craga89/qTip2.git
git clone https://github.com/trentrichardson/jQuery-Timepicker-Addon.git
wget -O jquery.formwizard-$JQUERYFORMWIZARD.zip http://thecodemine.org/releases/jquery.formwizard-$JQUERYFORMWIZARD.zip
wget -O modernizr.js http://modernizr.com/downloads/modernizr.js
wget -O almond.js https://raw.github.com/jrburke/almond/master/almond.js
git clone https://github.com/douglascrockford/JSON-js
wget -O jquery.timeago.js http://timeago.yarp.com/jquery.timeago.js
wget https://github.com/aFarkas/html5shiv/zipball/master -O html5shiv.zip

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

mkdir jquery-ui-$JQUERYUI; pushd jquery-ui-$JQUERYUI/; unzip -o ../jquery-ui-$JQUERYUI.custom.zip; popd
rm -f jquery-ui-$JQUERYUI.custom.zip
mkdir jquery-formwizard-$JQUERYFORMWIZARD; pushd jquery-formwizard-$JQUERYFORMWIZARD; unzip -o ../jquery.formwizard-$JQUERYFORMWIZARD.zip; popd
rm -f jquery.formwizard-$JQUERYFORMWIZARD.zip

popd
git add -A code
git commit -m "Auto Update to $VERSION"
git tag $VERSION
