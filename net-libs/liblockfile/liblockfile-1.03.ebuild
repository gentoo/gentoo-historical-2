# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/liblockfile/liblockfile-1.03.ebuild,v 1.14 2003/10/27 09:56:20 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Implements functions designed to lock the standard mailboxes."
SRC_URI="mirror://debian/pool/main/libl/${PN}/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.debian.org"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc sparc alpha"

src_compile() {

	econf --with-mailgroup=mail || die
	emake || die
}

src_install() {

	dodir /usr/{bin,include,lib} /usr/share/man/{man1,man3}
	make  ROOT=${D} install || die
}

