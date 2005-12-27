# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mhash/mhash-0.9.3-r1.ebuild,v 1.1 2005/12/27 03:05:00 robbat2 Exp $

inherit eutils

DESCRIPTION="library providing a uniform interface to a large number of hash algorithms"
HOMEPAGE="http://mhash.sourceforge.net/"
SRC_URI="mirror://sourceforge/mhash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A} && cd "${S}"
	# for 0.9.3 only, please send patch upstream
	epatch "${FILESDIR}/${P}-mhash_free.patch"
}

src_compile() {
	econf \
		--enable-static \
		--enable-shared || die
	emake || die "make failure"
}

src_install() {
	dodir /usr/{bin,include,lib}
	make install DESTDIR="${D}" || die "install failure"

	dodoc AUTHORS INSTALL NEWS README TODO THANKS ChangeLog
	dodoc doc/*.txt doc/skid*
	prepalldocs
	cd doc && dohtml mhash.html || die "dohtml failed"
}
