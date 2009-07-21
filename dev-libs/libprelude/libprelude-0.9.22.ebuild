# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libprelude/libprelude-0.9.22.ebuild,v 1.6 2009/07/21 14:34:38 chainsaw Exp $

inherit perl-module flag-o-matic eutils

DESCRIPTION="Prelude-IDS Framework Library"
HOMEPAGE="http://www.prelude-ids.org/"
SRC_URI="http://www.prelude-ids.org/download/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~ppc sparc x86"
IUSE="doc perl python swig"

RDEPEND=">=net-libs/gnutls-1.0.17
	!net-analyzer/prelude-nids"

DEPEND="${RDEPEND}
	sys-devel/flex"

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
		$(use_enable doc gtk-doc) \
		$(use_with swig) \
		$(use_with perl) \
		$(use_with python) \
		|| die "econf failed"

	emake OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	use perl && fixlocalpod
}

pkg_preinst() { use perl && perl-module_pkg_preinst ; }
pkg_postinst() { use perl && perl-module_pkg_postinst ; }
pkg_prerm() { use perl && perl-module_pkg_prerm ; }
pkg_postrm() { use perl && perl-module_pkg_postrm ; }
