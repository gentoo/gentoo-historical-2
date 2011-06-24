# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-postgresql/eselect-postgresql-1.0.10.ebuild,v 1.4 2011/06/24 14:51:20 armin76 Exp $

EAPI="4"

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ppc-macos x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect
		 !!dev-db/libpq"

S="${WORKDIR}"

src_install() {
	keepdir /etc/eselect/postgresql

	insinto /usr/share/eselect/modules
	doins postgresql.eselect

	dosym /usr/bin/eselect /usr/bin/postgresql-config
}

pkg_postinst() {
	ewarn "If you are updating from app-admin/eselect-postgresql-0.4 or older, run:"
	ewarn
	ewarn "    eselect postgresql update"
	ewarn
	ewarn "To get your system in a proper state."
	elog "You should set your desired PostgreSQL slot:"
	elog "    eselect postgresql list"
	elog "    eselect postgresql set <slot>"
}
