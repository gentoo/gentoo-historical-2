# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms-shn/xmms-shn-2.2.3-r1.ebuild,v 1.1 2001/10/06 17:22:51 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="This input plugin allows xmms to play .shn compressed (lossless) files"
SRC_URI="http://shnutils.freeshell.org/xmms-shn/source/xmms-shn-2.2.3.tar.bz2"
HOMEPAGE="http://shnutils.freeshell.org/xmms-shn"
DEPEND="virtual/glibc >=media-sound/xmms-1.2.3"

src_compile() {
	try ./configure --prefix=/usr --host=${CHOST}
	try make
}

src_install() {
	try make DESTDIR=${D} libdir=/usr/lib/xmms/Input install
	dodoc AUTHORS COPYING NEWS README
}

