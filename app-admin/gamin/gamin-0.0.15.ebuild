# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gamin/gamin-0.0.15.ebuild,v 1.4 2004/10/21 11:29:39 blubb Exp $

inherit eutils

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="http://www.gnome.org/~veillard/gamin/sources/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~hppa ~ia64 ~ppc ~s390 ~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/glib-2.0
	!app-admin/fam"
PROVIDE="virtual/fam"

src_compile() {
	econf \
		--enable-inotify \
		--enable-debug \
		|| die
	# Enable debug for testing the runtime backend patch

	# Currently not smp safe
	emake || die "emake failed"
}

src_install() {
	einstall || die

	dodoc AUTHORS ChangeLog README TODO
}
