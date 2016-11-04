#!/bin/bash
set -e
set +h

install -v -m644 -D    ../cracklib-words-2.9.6.gz \
                         /usr/share/dict/cracklib-words.gz     &&
gunzip -v                /usr/share/dict/cracklib-words.gz     &&
ln -v -sf cracklib-words /usr/share/dict/words                 &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      /lib/cracklib                         &&
create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words

