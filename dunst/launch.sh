#!/bin/sh

pidof dunst && killall dunst

DUNST_FILE=~/.cache/wal/dunstrc

dunst -config ~/.cache/wal/dunstrc > /dev/null 2>&1 &
