# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/murmur/murmur-0.9.4.ebuild,v 1.3 2007/02/28 09:24:31 drizzt Exp $

inherit eutils toolchain-funcs

MY_P=mumble-${PV}

DESCRIPTION="voice chat software for gaming written in Qt4 (server)"
HOMEPAGE="http://mumble.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="pch"

DEPEND="=x11-libs/qt-4*"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	if ! built_with_use -o =x11-libs/qt-4* sqlite sqlite3; then
		echo
		ewarn "You need to build Qt4 with the sqlite and/or sqlite3 use flag"
		echo
		die "Your Qt4 has no sqlite support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use pch || sed -i -e '3s: precompile_header$::' mumble.pri
}

src_compile() {
	qmake murmur.pro 	|| die "qmake failed"
	emake CC="$(tc-getCC) ${CFLAGS}" \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		LINK="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	dodoc README CHANGES	|| die "installing docs failed"
	dobin murmur			|| die "installing failed"
	insinto /etc/murmur
	doins murmur.ini
	newinitd "${FILESDIR}"/murmur.rc murmur
	newconfd "${FILESDIR}"/murmur.confd murmur
}
