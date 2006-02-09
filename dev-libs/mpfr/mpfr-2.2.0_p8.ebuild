# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mpfr/mpfr-2.2.0_p8.ebuild,v 1.4 2006/02/09 17:27:59 agriffis Exp $

inherit eutils

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="http://www.mpfr.org/"
SRC_URI="http://www.mpfr.org/mpfr-current/${MY_P}.tar.bz2
		mirror://gentoo/mpfr-2.2.0_p5"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=dev-libs/gmp-4.1.4-r2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack "${MY_P}.tar.bz2"
	cd "${S}"
	for ((i=1; i<=PLEVEL; ++i)) ; do
		patch=patch$(printf '%02d' ${i})
		if [ -f  "${FILESDIR}/${MY_PV}/${patch}" ]; then
			epatch "${FILESDIR}/${MY_PV}/${patch}"
		elif [  -f  "${DISTDIR}/${PN}-2.2.0_p${i}" ]; then
			epatch "${DISTDIR}/${PN}-2.2.0_p${i}"
		else
			ewarn "${DISTDIR}/${PN}-2.2.0_p${i}"
			die "patch ${i} missing - please report to bugs.gentoo.org"
		fi
	done
}

src_compile() {
	econf \
		--enable-shared \
		--enable-static \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	dohtml *.html
}
