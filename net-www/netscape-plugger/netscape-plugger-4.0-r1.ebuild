# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/netscape-plugger/netscape-plugger-4.0-r1.ebuild,v 1.4 2002/07/11 06:30:49 drobbins Exp $

MYP=${P#netscape-}-linux-x86-glibc
S=${WORKDIR}/plugger-4.0
DESCRIPTION="Plugger 4.0 streaming media plugin"
SRC_URI="http://fredrik.hubbe.net/plugger/"${MYP}.tar.gz
HOMEPAGE="http://fredrik.hubbe.net/plugger.html"

src_install() {                               
	cd ${S}
	dodir /opt/netscape/plugins /etc
	insinto /opt/netscape/plugins
	doins plugger.so
	insinto /etc
	doins pluggerrc
	dodoc README COPYING
	doman plugger.7
	insinto /usr/bin
	dobin plugger-4.0
	dosym plugger-4.0 /usr/bin/plugger

	if use mozilla; then
		into /usr/lib/mozilla/plugins
		dosym /opt/netscape/plugins/plugger.so \
			/usr/lib/mozilla/plugins/plugger.so
	fi
  
}
