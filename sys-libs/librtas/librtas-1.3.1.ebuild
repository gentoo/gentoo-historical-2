# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/librtas/librtas-1.3.1.ebuild,v 1.3 2007/05/29 17:03:57 ranger Exp $

inherit eutils

DESCRIPTION=" Librtas provides a set of libraries for user-space access to the Run-Time Abstraction Services (RTAS) on the ppc64 architecture."
SRC_URI="http://librtas.ozlabs.org/releases/librtas-${PV}.tar.gz"
HOMEPAGE="http://librtas.ozlabs.org/"

SLOT="0"
LICENSE="IPL-1"
KEYWORDS="~ppc ~ppc64"
IUSE=""

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/librtas-1.3.1-remove-doc.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Compilation failed"
	dodoc README COPYRIGHT

}

