# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/bsdsfv/bsdsfv-1.14.ebuild,v 1.5 2003/08/05 14:36:31 vapier Exp $

inherit eutils

DESCRIPTION="BSDSFV: All-in-one SFV checksum utility"
HOMEPAGE="http://bsdsfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/bsdsfv/${PN}.${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND="virtual/glibc"

S=${WORKDIR}/${PN}

src_compile() {
	epatch ${FILESDIR}/${PN}-${PV}-gentoo.diff
	emake || die
}

src_install() {
	dobin bsdsfv
	dodoc README MANUAL
}
