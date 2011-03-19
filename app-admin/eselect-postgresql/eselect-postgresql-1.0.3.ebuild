# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-postgresql/eselect-postgresql-1.0.3.ebuild,v 1.1 2011/03/19 21:58:13 titanofold Exp $

EAPI="4"

DESCRIPTION="Utility to select the default PostgreSQL slot"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~titanofold/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="app-admin/eselect
		!!dev-db/libpq"

src_install() {
	keepdir /etc/eselect/postgresql

	insinto /usr/share/eselect/modules
	doins postgresql.eselect

	dosym /usr/bin/eselect /usr/bin/postgresql-config
}

pkg_postinst() {
	elog "You need to set your default slot:"
	elog "    eselect postgresql set <slot>"
}
