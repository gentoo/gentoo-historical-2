# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/opera/opera-6.0_pre2.ebuild,v 1.1 2001/12/24 01:36:53 drobbins Exp $

NV=6.0-20011129.2-shared_qt.i386
S=${WORKDIR}/opera-${NV}
DESCRIPTION="Opera webbrowser, version 6.0 TP"
SRC_URI="ftp://ftp.opera.com/pub/opera/linux/600/tp2/opera-${NV}.tar.gz"
HOMEPAGE="http://www.opera.com"

DEPEND=">=x11-libs/qt-x11-2.3.0"

src_install() {

	./install.sh \
		--exec_prefix=${D}/usr/bin \
		--wrapperdir=${D}/usr/share/opera/bin \
		--docdir=${D}/usr/share/doc/${P} \
		--sharedir=${D}/usr/share/opera \
		--plugindir=${D}/usr/share/opera/plugins
	rm /usr/share/doc/${P}/help
	dosym /usr/share/opera/help /usr/share/doc/${P}/help
	dosed /usr/bin/opera
}

