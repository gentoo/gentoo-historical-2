# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/opera/opera-6.0_pre1.ebuild,v 1.2 2001/12/29 17:41:37 danarmak Exp $

S=${WORKDIR}/opera-6.0-20011122.2-shared_qt.i386
DESCRIPTION="Opera webbrowser, version 6.0 TP"
SRC_URI="ftp://ftp.opera.com/pub/opera/linux/600/tp1/opera-6.0-20011122.2-shared_qt.i386.tar.gz"
HOMEPAGE="http://www.opera.com"

DEPEND=">=x11-libs/qt-2.3.0"

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

