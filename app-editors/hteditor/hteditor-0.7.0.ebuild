# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hteditor/hteditor-0.7.0.ebuild,v 1.4 2004/03/13 23:00:56 mr_bones_ Exp $

IUSE=""

DESCRIPTION="HT Editor - editor for executable files"
HOMEPAGE="http://hte.sf.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -alpha"

DEPEND="virtual/glibc"

SRC_URI="mirror://sourceforge/hte/ht-${PV}.tar.bz2"
S="${WORKDIR}/ht-${PV}"

src_compile() {
	cd "${S}"
	chmod +x configure
	local myconf="--prefix=/usr --sysconfdir=/etc"
	./configure ${myconf}  || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS KNOWNBUGS TODO COPYING README
}
