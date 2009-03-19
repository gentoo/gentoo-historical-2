# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.15.4.ebuild,v 1.3 2009/03/19 14:42:39 gentoofan23 Exp $

inherit multilib

DESCRIPTION="Search and query ebuilds, portage incl. local settings, ext.
overlays, version changes, and more"
HOMEPAGE="http://eix.sourceforge.net"
SRC_URI="mirror://sourceforge/eix/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="doc sqlite"

RDEPEND="sqlite? ( >=dev-db/sqlite-3 )
	app-arch/bzip2"
DEPEND="${RDEPEND}
	app-arch/lzma-utils
	doc? ( dev-python/docutils )"

src_compile() {
	econf --with-bzip2 $(use_with sqlite) $(use_with doc rst) \
		--with-ebuild-sh-default="/usr/$(get_libdir)/portage/bin/ebuild.sh" \
		--with-portage-rootpath="${ROOTPATH}"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog doc/format.txt
	use doc && dodoc doc/format.html
}

pkg_postinst() {
	ewarn
	ewarn "Security Warning:"
	ewarn
	ewarn "Since >=eix-0.12.0, eix uses by default OVERLAY_CACHE_METHOD=\"parse|ebuild*\""
	ewarn "This is rather reliable, but ebuilds may be executed by user \"portage\". Set"
	ewarn "OVERLAY_CACHE_METHOD=parse in /etc/eixrc if you do not trust the ebuilds."
	if test -d /var/log && ! test -x /var/log || test -e /var/log/eix-sync.log
	then
		einfo
		einfo "eix-sync no longer supports redirection to /var/log/eix-sync.log"
		einfo "You can remove that file."
	fi
}
