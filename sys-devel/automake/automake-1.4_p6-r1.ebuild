# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.4_p6-r1.ebuild,v 1.5 2010/03/07 22:51:30 maekke Exp $

inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="http://sources.redhat.com/automake/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	sys-devel/automake-wrapper
	>=sys-devel/autoconf-2.59-r6
	sys-devel/gnuconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.4-nls-nuisances.patch #121151
	epatch "${FILESDIR}"/${PN}-1.4-libtoolize.patch
	epatch "${FILESDIR}"/${PN}-1.4-subdirs-89656.patch
	epatch "${FILESDIR}"/${PN}-1.4-ansi2knr-stdlib.patch
	epatch "${FILESDIR}"/${PN}-1.4-CVE-2009-4029.patch #295357
	sed -i 's:error\.test::' tests/Makefile.in #79529
	sed -i \
		-e "/^@setfilename/s|automake|automake${SLOT}|" \
		-e "s|automake: (automake)|automake v${SLOT}: (automake${SLOT})|" \
		-e "s|aclocal: (automake)|aclocal v${SLOT}: (automake${SLOT})|" \
		automake.texi || die "sed failed"
	export WANT_AUTOCONF=2.5
}

src_install() {
	emake install DESTDIR="${D}" \
		pkgdatadir=/usr/share/automake-${SLOT} \
		m4datadir=/usr/share/aclocal-${SLOT} \
		|| die
	rm -f "${D}"/usr/bin/{aclocal,automake}
	dosym automake-${SLOT} /usr/share/automake

	dodoc NEWS README THANKS TODO AUTHORS ChangeLog
	doinfo *.info

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
