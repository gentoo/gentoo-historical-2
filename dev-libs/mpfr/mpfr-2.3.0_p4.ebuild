# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mpfr/mpfr-2.3.0_p4.ebuild,v 1.8 2008/02/25 02:53:40 vapier Exp $

# NOTE: we cannot depend on autotools here starting with gcc-4.3.x
inherit eutils

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="library for multiple-precision floating-point computations with exact rounding"
HOMEPAGE="http://www.mpfr.org/"
SRC_URI="http://www.mpfr.org/mpfr-current/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/gmp-4.1.4-r2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack "${MY_P}.tar.bz2"
	cd "${S}"
	[[ ${PLEVEL} == ${PV} ]] && return 0
	for ((i=1; i<=PLEVEL; ++i)) ; do
		patch=patch$(printf '%02d' ${i})
		if [[ -f ${FILESDIR}/${MY_PV}/${patch} ]] ; then
			epatch "${FILESDIR}"/${MY_PV}/${patch}
		elif [[ -f ${DISTDIR}/${PN}-${MY_PV}_p${i} ]] ; then
			epatch "${DISTDIR}"/${PN}-${MY_PV}_p${i}
		else
			ewarn "${DISTDIR}/${PN}-${MY_PV}_p${i}"
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
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	dohtml *.html
}
