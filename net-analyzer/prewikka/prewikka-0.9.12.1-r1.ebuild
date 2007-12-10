# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/prewikka/prewikka-0.9.12.1-r1.ebuild,v 1.4 2007/12/10 14:49:11 armin76 Exp $

inherit distutils

DESCRIPTION="Prelude-IDS Frontend"
HOMEPAGE="http://www.prelude-ids.org/"
SRC_URI="http://www.prelude-ids.org/download/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	>=dev-python/cheetah-0.9.18
	>=dev-libs/libprelude-0.9.0
	>=dev-libs/libpreludedb-0.9.0"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-libs/libprelude python ; then
		die 'requires dev-libs/libprelude to be built with "python" use flag'
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-create-user.patch
}

src_install() {
	distutils_src_install
	dodir /etc/prewikka
	insinto /etc/prewikka
	doins "${FILESDIR}"/prewikka.conf-sample
	rm "${D}"/\-dist
}

pkg_postinst() {
	elog
	elog "For additional installation instructions go to"
	elog "https://trac.prelude-ids.org/wiki/InstallingPrewikka"
	elog
	elog "The default config from the website is installed as"
	elog "/etc/prewikka/prewikka.conf-sample"
}
