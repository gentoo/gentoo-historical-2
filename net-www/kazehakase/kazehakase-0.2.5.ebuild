# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/kazehakase/kazehakase-0.2.5.ebuild,v 1.3 2005/03/01 17:40:57 nakano Exp $

IUSE="migemo estraier thumbnail"

DESCRIPTION="Kazehakase is a browser with gecko engine like Epiphany or Galeon."
SRC_URI="mirror://sourceforge.jp/${PN}/13324/${P}.tar.gz"
HOMEPAGE="http://kazehakase.sourceforge.jp/"

SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc ~sparc"
LICENSE="GPL-2"

DEPEND=">=net-www/mozilla-1.7
	x11-libs/pango
	>=x11-libs/gtk+-2
	dev-util/pkgconfig
	net-misc/curl
	migemo? ( || ( app-text/migemo app-text/cmigemo ) )
	estraier? ( app-text/estraier )
	thumbnail? ( virtual/ghostscript )"

pkg_setup(){
	local moz_use="$(</var/db/pkg/`best_version net-www/mozilla`/USE)"

	# >=net-www/mozilla-1.7.3-r2 always depend on gtk2.
	if ! has_version '>=net-www/mozilla-1.7.3-r2' && ! has gtk2 ${moz_use}
	then
		echo
		eerror
		eerror "This needs mozilla used gtk2."
		eerror "To build mozilla use gtk2, please type following command:"
		eerror
		eerror "    # USE=\"gtk2\" emerge mozilla"
		eerror
		die
	fi
}

src_compile(){
	econf `use_enable migemo` || die
	emake || die
}

src_install(){
	emake DESTDIR="${D}" install || die
	dodoc ABOUT-NLS AUTHORS COPYING* ChangeLog NEWS README* TODO.ja
}

pkg_postinst(){
	if use thumbnail; then
		einfo "To enable thumbnail, "
		einfo "   1. Go to Preference."
		einfo "   2. Check \"Create thumbnail\"."
		einfo
		ewarn "Creating thumbnail process is still unstable (sometimes causes crash),"
		ewarn "but most causes of unstability are Mozilla. If you find a crash bug on"
		ewarn "Kazehakase, please confirm the following:"
		ewarn
		ewarn "   1. Load a crash page with Mozilla."
		ewarn "   2. Print preview the page."
		ewarn "   3. Close print preview window."
		ewarn "   4. Print the page to a file."
		ewarn
	fi
}
