# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Id: gplflash-0.4.10-r1.ebuild,v 1.7 2002/08/23 15:46:31 cybersystem Exp $

S=${WORKDIR}/flash-0.4.10
DESCRIPTION="GPL Shockwave Flash Player/Plugin"
SRC_URI="http://www.swift-tools.com/Flash/flash-0.4.10.tgz"
HOMEPAGE="http://www.swift-tools.com/Flash"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="media-libs/libflash"

LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	cd ${WORKDIR}
	unpack flash-0.4.10.tgz
	cd ${S}
	patch -p1 <${FILESDIR}/${P}-gcc3-gentoo.diff || die
}

src_compile() {
	cd ${S}
	emake
}

src_install() {                               
  cd ${S}/Plugin
  insinto /opt/netscape/plugins
  doins npflash.so
  cd ${S}
  dodoc README COPYING
  
  if [ "`use mozilla`" ] ; then
    dodir /usr/lib/mozilla/plugins
    dosym /opt/netscape/plugins/npflash.so \
          /usr/lib/mozilla/plugins/npflash.so 
  fi
}
