# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libprelude/libprelude-0.9.8.ebuild,v 1.1 2006/06/01 20:50:26 jokey Exp $

inherit perl-module flag-o-matic

DESCRIPTION="Prelude-IDS Framework Library"
HOMEPAGE="http://www.prelude-ids.org/"
SRC_URI="http://www.prelude-ids.org/download/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc-macos ~sparc ~x86"
IUSE="perl python"

DEPEND=">=net-libs/gnutls-1.0.17
	!net-analyzer/prelude-nids"

pkg_setup() {
	use perl && perl-module_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	filter-lfs-flags
}

src_compile() {
	econf \
		$(use_enable perl) \
		$(use_enable python) \
		|| die "econf failed"

	emake -j1 || die "emake failed"
	# -j1 may not be necessary in the future
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	use perl && fixlocalpod
}

pkg_preinst() { use perl && perl-module_pkg_preinst ; }
pkg_postinst() { use perl && perl-module_pkg_postinst ; }
pkg_prerm() { use perl && perl-module_pkg_prerm ; }
pkg_postrm() { use perl && perl-module_pkg_postrm ; }
