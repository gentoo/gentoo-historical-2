# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbdate/bbdate-0.2.4-r1.ebuild,v 1.1 2008/09/17 19:18:01 coldwind Exp $

inherit eutils autotools

DESCRIPTION="blackbox date display"
HOMEPAGE="http://sourceforge.net/projects/bbtools"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/blackbox"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-as-needed.patch
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS BUGS INSTALL ChangeLog TODO

	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${D}"/usr/share/bbtools/bbtoolsrc.in \
		"${D}"/usr/share/doc/${PF}/bbtoolsrc.example
}
