#!/usr/bin/env bash

# This script does the following:
# 1) Sets the color options of the xfce4 terminal to black-on-white so screenshots will be much easier to read
# 2) Sets the colors and font for xterm windows
# 3) Fix .bashrc to remove bash colors for a much nicer and cleaner output

TERMRC=$HOME/.config/xfce4/terminal/terminalrc
if [ ! -f ${TERMRC} ] ; then
  cat Files/terminalcolors > ${TERMRC}
else
  for line in $(cat Files/terminalcolors) ; do
    OPT=$(echo $line | cut -d '=' -f 1)
    grep -q -E "^${OPT}" ${TERMRC}
    if [ $? -eq 0 ] ; then
      sed -i "s/^${OPT}.*/${LINE}/g" ${TERMRC}
    else
      echo "${LINE}" >> ${TERMRC}
    fi
  done
fi

XRES=$HOME/.Xresources
if [ ! -f ${XRES} ] ; then
  echo "xterm*faceName: Monospace" > $XRES
  echo "xterm*faceSize: 14" >> $XRES
  echo "xterm*foreground: black" >> $XRES
  echo "xterm*background: white" >> $XRES
  xrdb -merge $XRES
else
  grep -q -E "^xterm\*faceName:" $XRES   && sed -i 's/xterm\*faceName:.*/xterm*faceName: Monospace/g' $XRES
  grep -q -E "^xterm\*faceSize:" $XRES   && sed -i 's/xterm\*faceSize:.*/xterm*faceSize: 14/g' $XRES
  grep -q -E "^xterm\*foreground:" $XRES && sed -i 's/xterm\*foreground:.*/xterm*foreground: black/g' $XRES
  grep -q -E "^xterm\*background:" $XRES && sed -i 's/xterm\*background:.*/xterm*background: white/g' $XRES
  xrdb -merge $XRES
fi

sed -i 's/color_prompt=yes/color_prompt=no/g' $HOME/.bashrc
sed -i 's/--color=auto/--color=never/g' $HOME/.bashrc
