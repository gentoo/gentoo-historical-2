# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.5.5.ebuild,v 1.1 2006/03/22 11:10:11 genstef Exp $

DESCRIPTION="Small utility for searching ebuilds with indexing for fast results"
HOMEPAGE="http://dev.croup.de/proj/eix"
SRC_URI="mirror://sourceforge/eix/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="sys-apps/portage"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "Please run 'update-eix' to setup the portage search database."
	einfo "The database file will be located at /var/cache/eix"
	echo
	einfo "If you want to use cdb support, you need to add"
	einfo "    PORTDIR_CACHE_METHOD=\"cdb\""
	einfo "to /etc/eixrc or ~/.eixrc"
	echo
	einfo "If you want to use the backported cache patch of portage-2.1"
	einfo "you need to add"
	einfo "    PORTDIR_CACHE_METHOD=\"backport\""
	einfo "to /etc/eixrc or ~/.eixrc"
	echo
	einfo "As of >=eix-0.5.4, \"metadata\" is the new default cache."
	einfo "It's independent of the portage-version and the cache used by portage."
}
