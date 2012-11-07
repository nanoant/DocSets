#!/bin/bash
# common OpenGL docset build script, please do not call it directly

if [ "$output" == "" ]; then echo 'please set $output variable'; exit 1; fi

rxml2html='s/"[^"]*gl\([^"]*\)\.xml"/"gl\1.html"/'

rm -rf $output
mkdir -p $output/Contents/Resources/Documents
cp -p $icon $output/icon.png

cp -p $css/xhtml/*.css $output/Contents/Resources/Documents
cat >> $output/Contents/Resources/Documents/opengl-man.css <<CSS
html, body {
	margin: 0;
	padding: 0;
	font-family: 'Lucida Grande', Geneva, sans-serif;
	font-size: 13px;
	font-weight: normal;
}
h1 {
	margin: 0;
	padding: 20px;
}
h2 {
	color: #f24e32;
	font-weight: normal;
	font-size: 17px;
}
div.refsect1 {
	border-top: 1px solid #eee;
	background-image: -webkit-gradient(linear,center top,center bottom,from(#f9f9f9),color-stop(0.6,#ffffff),to(#ffffff));
}
code, tt, pre, div.funcsynopsis td, span.citerefentry {
	font-family: Menlo, monospace;
}
div.funcsynopsis, div.funcsynopsis td {
	font-size: 14px;
}
div.refentry > div, body > p, body > h2 {
	padding: 0 20px;
}
div.refentry > div.refsynopsisdiv {
	border-top: 1px solid #eee;
	padding: 10px 20px;
	background-image: -webkit-gradient(linear,center top,center bottom,from(#fff6e0),color-stop(0.6,#fff9ea),color-stop(0.9,#fff9ea),to(#fff6e0));
	border-bottom: 1px solid #fff0d0;
}
div.refentry > div.refsynopsisdiv h2 { display: none; }
div.refentry {
	margin: 0;
}
div.refnamediv, div.refentry {
	padding: 0;
}
div.refnamediv p, div.refnamediv h2 {
	margin: 0;
	padding: 10px 0;
	color: #333;
}
div.refnamediv p {
	padding-top: 0;
	font-size: 13px;
}
div.refnamediv h2 {
	padding-bottom: 2px;
	color: black;
	font-weight: bold;
	font-style: normal;
	font-size: 19px;
}
div.refnamediv {
	background-color: #fff;
}
a:visited, a:visited span.citerefentry {
	color: #036;
	text-decoration: none;
}
a, a span.citerefentry {
	color: #36c;
	text-decoration: none;
}
a#Copyright, a#Copyright + h2, a#Copyright + h2 + p {
	display: none;
}
CSS

sed \
	-e $rxml2html \
	-e 's/..\/..\/mancommon\///' \
	-e 's/<\/head>/<\/head><link rel="stylesheet" href="opengl-man.css"\/>/' \
	$src/xhtml/start.html > $output/Contents/Resources/Documents/index.html

echo '<Tokens version="1.0">' > $output/Contents/Resources/Tokens.xml

for f in `ls $src/xhtml/gl*.xml | sed "s/$src\/xhtml\/\(.*\)\.xml/\1/"`; do
	sed \
		-e $rxml2html \
		-e "s/<h2>Name<\/h2><p>$f [^a-zA-Z ]*/<h2>$f<\/h2><p>/" \
		-e 's/<\/head>/<\/head><link rel="stylesheet" href="opengl-man.css"\/>/' \
		$src/xhtml/$f.xml > $output/Contents/Resources/Documents/$f.html
	echo "<File path=\"$f.html\"><Token><TokenIdentifier>//apple_ref/cpp/func/$f</TokenIdentifier></Token></File>" \
		>> $output/Contents/Resources/Tokens.xml
done

echo '</Tokens>' >> $output/Contents/Resources/Tokens.xml

cat > $output/Contents/Resources/Nodes.xml <<XML
<DocSetNodes version="1.0">
	<TOC>
		<Node type="folder">
			<Name>$title Reference Pages</Name>
			<Path>index.html</Path>
		</Node>
	</TOC>
</DocSetNodes>
XML

cat > $output/Contents/Info.plist <<XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>org.opengl.$id</string>
	<key>CFBundleName</key>
	<string>$title</string>
	<key>DocSetPlatformFamily</key>
	<string>$id</string>
	<key>DashDocSetFamily</key>
	<string>doxy</string>
</dict>
</plist>
XML

/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil index $output
