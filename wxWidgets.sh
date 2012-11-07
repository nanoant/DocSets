#!/bin/bash

if [ "`which dot`" == "" ]; then
	echo 'you need to install Graphviz from http://www.graphviz.org'
	exit 1
fi

if [ "`which doxygen`" == "" ]; then
	echo 'you need to install Doxygen from http://www.doxygen.org'
	exit 1
fi

if [ ! -d wxWidgets/ ]; then
	svn co http://svn.wxwidgets.org/svn/wx/wxWidgets/tags/WX_2_9_4 wxWidgets
fi

cat > wxWidgets/docs/doxygen/Doxyfile <<DOXY
@INCLUDE = Doxyfile_inc

GENERATE_DOCSET        = YES
GENERATE_HTML          = YES
SEARCHENGINE           = NO
DISABLE_INDEX          = YES
GENERATE_TREEVIEW      = NO
QUIET                  = NO

DOCSET_FEEDNAME        = "wxWidgets 2.9"
DOCSET_BUNDLE_ID       = wxwidgets.doxygen.wx29
DOCSET_PUBLISHER_ID    = org.wxwidgets.doxygen
DOCSET_PUBLISHER_NAME  = "wxWidgets Team"
DOXY

rm -rf wxWidgets/docs/doxygen/out
cd wxWidgets/docs/doxygen
doxygen || exit 1
cd ../../..

# fix missing XML elements closing (who knows why it happens!?)
sed -i '' 's:</TOC>:</Subnodes></Node></Subnodes></Node></Subnodes></Node></TOC>:' wxWidgets/docs/doxygen/out/html/Nodes.xml
make -C wxWidgets/docs/doxygen/out/html || exit 1

rm -rf wxWidgets.docset
mv wxWidgets/docs/doxygen/out/html/wxwidgets.doxygen.wx29.docset wxWidgets.docset

cp -p wxWidgets.css wxWidgets.docset/Contents/Resources/Documents/custom_stylesheet.css
cp -p wxWidgets.png wxWidgets.docset/icon.png

cat > wxWidgets.docset/Contents/Info.plist <<XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
     <key>CFBundleName</key>
     <string>wxWidgets</string>
     <key>CFBundleIdentifier</key>
     <string>org.wxwidgets.doxygen.wx29.docset</string>
     <key>DocSetFeedName</key>
     <string>wxWidgets 2.9</string>
     <key>DocSetPublisherIdentifier</key>
     <string>org.wxwidgets.doxygen</string>
     <key>DocSetPublisherName</key>
     <string>wxWidgets Team</string>
     <key>DashDocSetFamily</key>
     <string>doxy</string>
     <key>DocSetPlatformFamily</key>
     <string>wx</string>
</dict>
</plist>
XML
