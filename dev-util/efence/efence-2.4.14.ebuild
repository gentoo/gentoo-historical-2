# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/efence/efence-2.4.14.ebuild,v 1.4 2006/06/23 12:42:34 blubb Exp $

inherit eutils versionator toolchain-funcs multilib

MY_P="${PN}_$(replace_all_version_separators '_')"
S="${WORKDIR}/${PN}"
DESCRIPTION="ElectricFence malloc() debugger"
HOMEPAGE="http://www.pf-lug.de/projekte/haya/efence.php"
SRC_URI="http://www.pf-lug.de/projekte/haya/${MY_P}.tar.gz"
RESTRICT="test"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/bash"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.4.13-gentoo.diff
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	make prefix="${D}"/usr LIB_INSTALL_DIR="${D}/usr/$(get_libdir)" install || die "make install failed"
	insinto /usr/include
	doins efence.h efencepp.h efence_config.h noefence.h sem_inc.h \
		|| die "failed to install headers"
	dodoc CHANGES README
}
