# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/tcsh/tcsh-6.12.ebuild,v 1.3 2002/12/18 14:51:39 vapier Exp $

MY_P="${PN}-${PV}.00"
DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
SRC_URI="ftp://ftp.astron.com/pub/tcsh/${MY_P}.tar.gz"
HOMEPAGE="http://www.tcsh.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc "
IUSE="perl"

RDEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	perl? ( sys-devel/perl )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-tc.os.h-gentoo.diff || die
}

src_compile() {
	econf --prefix=/
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install install.man || die

	if [ "`use perl`" ] ; then
		perl tcsh.man2html || die
		dohtml tcsh.html/*.html
	fi

	dosym /bin/tcsh /bin/csh
	dodoc FAQ Fixes NewThings Ported README WishList Y2K

	insinto /etc
	doins ${FILESDIR}/csh.cshrc ${FILESDIR}/csh.login
}
