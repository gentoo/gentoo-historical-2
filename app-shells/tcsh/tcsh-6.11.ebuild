# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.11.ebuild,v 1.6 2002/10/05 05:39:09 drobbins Exp $

IUSE="perl"
			
S=${WORKDIR}/${P}.00
DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
SRC_URI="ftp://ftp.gw.com/pub/unix/tcsh/${P}.tar.gz
	ftp://ftp.astron.com/pub/tcsh/${P}.tar.gz
	ftp://ftp.funet.fi/pub/unix/shells/tcsh/${P}.tar.gz"
HOMEPAGE="http://www.tcsh.org/"
DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	perl? ( sys-devel/perl )"

HOMEPAGE="http://www.tcsh.org/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc sparc sparc64"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-tc.os.h-gentoo.diff || die
}

src_compile() {

	econf \
		--prefix=/ || die

	emake || die
}

src_install() {

	make DESTDIR=${D} install install.man || die

	use perl && ( \
		perl tcsh.man2html || die
		dohtml tcsh.html/*.html
	)

	dosym /bin/tcsh /bin/csh
	dodoc FAQ Fixes NewThings Ported README WishList Y2K

	insinto /etc
	doins ${FILESDIR}/csh.cshrc ${FILESDIR}/csh.login
}
