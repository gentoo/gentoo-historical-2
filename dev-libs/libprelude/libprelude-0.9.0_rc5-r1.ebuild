# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libprelude/libprelude-0.9.0_rc5-r1.ebuild,v 1.2 2005/05/16 03:10:44 vapier Exp $

inherit versionator perl-module flag-o-matic

MY_P="${PN}-$(replace_version_separator 3 '-')"
DESCRIPTION="Prelude-IDS Framework Library"
HOMEPAGE="http://www.prelude-ids.org/"
SRC_URI="http://www.prelude-ids.org/download/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~ia64 ~amd64"
IUSE="perl python pcre"

DEPEND=">=net-libs/gnutls-1.0.17
	pcre? ( dev-libs/libpcre )"

#	doc? ( dev-util/gtk-doc )"
# Doc disabled as per bug 77575

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use perl && perl-module_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	grep -qs 'include.*fts.h' prelude-adduser/prelude-adduser.c || die "remove lfs filter"
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
	make DESTDIR=${D} install || die "make install failed"
	use perl && fixlocalpod
}

pkg_preinst() { use perl && perl-module_pkg_preinst ; }
pkg_postinst() { use perl && perl-module_pkg_postinst ; }
pkg_prerm() { use perl && perl-module_pkg_prerm ; }
pkg_postrm() { use perl && perl-module_pkg_postrm ; }
