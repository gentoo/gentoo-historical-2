# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca-gnupg/qca-gnupg-2.0.0_beta3.ebuild,v 1.9 2009/08/19 14:04:29 betelgeuse Exp $

EAPI="2"

inherit eutils qt4

MY_P="${P/_/-}"
QCA_VER="${PV%.*}"

DESCRIPTION="GnuPG plugin for QCA"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/${QCA_VER}/plugins/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND=">=app-crypt/qca-${QCA_VER}[debug?]
	x11-libs/qt-core"
RDEPEND="${DEPEND}
	app-crypt/gnupg"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# cannot use econf because of non-standard configure script
	./configure \
		--qtdir=/usr \
		$(use debug && echo "--debug" || echo "--release") \
		--no-separate-debug-info \
		|| die "configure failed"

	eqmake4 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
