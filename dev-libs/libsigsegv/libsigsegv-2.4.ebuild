# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigsegv/libsigsegv-2.4.ebuild,v 1.10 2008/02/04 20:31:36 grobian Exp $

inherit eutils autotools

DESCRIPTION="GNU libsigsegv is a library for handling page faults in user mode."
HOMEPAGE="ftp://ftp.gnu.org/pub/gnu/libsigsegv/"
SRC_URI="mirror://gnu/libsigsegv/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	AT_M4DIR=m4 eautoreconf
	econf --enable-shared
	emake || die "emake failed."
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
	dodoc AUTHORS ChangeLog* NEWS PORTING README*
}
