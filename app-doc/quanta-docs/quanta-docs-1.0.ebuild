# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/quanta-docs/quanta-docs-1.0.ebuild,v 1.2 2001/12/30 18:06:08 danarmak Exp $

S=${WORKDIR}
DESCRIPTION="Lots of docs for quanta"

list="quanta-css-${PV}.tar.bz2 
   quanta-html-${PV}.tar.bz2 
   quanta-javascript-${PV}.tar.bz2
   quanta-php-${PV}.tar.bz2"
  
for x in $list; do
    SRC_URI="$SRC_URI http://prdownloads.sourceforge.net/quanta/$x"
done

HOMEPAGE="http://quanta.sourceforge.net"

src_install () {

    dodir /usr/share/apps/quanta/doc
    for i in css html javascript php
    do
      cd ${S}/${i}
      cp -R $i $i.docrc ${D}/usr/share/apps/quanta/doc    
    done

}

