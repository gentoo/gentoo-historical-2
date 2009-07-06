# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.17.0.ebuild,v 1.2 2009/07/06 18:09:44 darkside Exp $

EAPI="1"

inherit multilib

DESCRIPTION="Search and query ebuilds, portage incl. local settings, ext.
overlays, version changes, and more"
HOMEPAGE="http://eix.sourceforge.net"
SRC_URI="mirror://sourceforge/eix/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="+deprecated doc nls sqlite tools"

RDEPEND="sqlite? ( >=dev-db/sqlite-3 )
	nls? ( virtual/libintl )
	app-arch/bzip2"
DEPEND="${RDEPEND}
	app-arch/lzma-utils
	doc? ( dev-python/docutils )
	nls? ( sys-devel/gettext )"

src_compile() {
	econf --with-bzip2 $(use_with sqlite) $(use_with doc rst) \
		$(use_enable nls) $(use_enable tools separate-tools) \
		--with-ebuild-sh-default="/usr/$(get_libdir)/portage/bin/ebuild.sh" \
		--with-portage-rootpath="${ROOTPATH}" \
		$(use_enable deprecated obsolete-reminder)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog doc/format.txt
	use doc && dodoc doc/format.html
}

pkg_postinst() {
	elog "Ask your overlay maintainers to provide metadata or consider to run"
	elog " egencache --repo=foo --update"
	elog "after updates (e.g. in /etc/eix-sync)."
	elog "This will speed up portage and update-eix (when the new default cache method"
	elog "\"...#metadata-flat\" is used and file dates are correct) for those overlays."
	elog "If metadata is provided but file dates are mangled during overlay updates,"
	elog "you may switch to cache method \"metadata-flat\" instead for that overlay:"
	elog "This is even faster, but works only if metadata is actually up-to-date."
	ewarn
	ewarn "Security Warning:"
	ewarn
	ewarn "Since >=eix-0.12.0, eix uses by default OVERLAY_CACHE_METHOD=\"parse|ebuild*\""
	ewarn "(since >=eix-0.16.1 with automagic \"#metadata-flat\")."
	ewarn "This is rather reliable, but ebuilds may be executed by user \"portage\". Set"
	ewarn "OVERLAY_CACHE_METHOD=parse in /etc/eixrc if you do not trust the ebuilds."
	if use deprecated; then
		elog "ATTENTION: The old eix executable names will be going away in 6"
		elog "months or the next major release, whichever is first. Update"
		elog "your scripts"
	else
		elog "ATTENTION: The eix executable names have changed. Update your"
		elog "scripts, if needed. This message will go away soon."
	fi

}
