#!/bin/bash
# This is a simple script that compiles the plugin using the free Flex SDK on Linux/Mac.
# Learn more at http://developer.longtailvideo.com/trac/wiki/PluginsCompiling

FLEXPATH=/Users/sfsekaran/Software/awesm-jwplayer/flex_sdk_3.6a


echo "Compiling awesm plugin..."
$FLEXPATH/bin/mxmlc ./Awesm.as -sp ./ -o ./awesm.swf \
  -library-path+=../../lib \
  -library-path+=./ \
  -load-externs ../../lib/jwplayer-5-classes.xml \
  -use-network=false
