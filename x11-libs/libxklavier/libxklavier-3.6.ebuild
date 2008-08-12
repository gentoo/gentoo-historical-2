# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-3.6.ebuild,v 1.6 2008/08/12 13:39:00 armin76 Exp $

inherit eutils

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"
SRC_URI="mirror://sourceforge/gswitchit/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="|| ( x11-misc/xkeyboard-config x11-misc/xkbdata )
		 x11-libs/libX11
		 x11-apps/xkbcomp
		 x11-libs/libxkbfile
		 >=dev-libs/glib-2.16
		 >=dev-libs/libxml2-2.0
		 app-text/iso-codes"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		doc? ( app-doc/doxygen )"

src_compile() {
	local xkbbase

	# see bug #113108
	if has_version x11-apps/xkbcomp; then
		xkbbase=/usr/share/X11/xkb
	else
		xkbbase=/usr/$(get_libdir)/X11/xkb
	fi

	econf --with-xkb-base=${xkbbase} --with-xkb-bin-base=/usr/bin \
		  $(use_enable doc doxygen) || die

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die

	insinto /usr/share/libxklavier
	use sparc && doins "${FILESDIR}/sun.xml"

	dodoc AUTHORS CREDITS ChangeLog NEWS README
}

pkg_postinst() {
	ewarn "Please note that the soname of the library changed!"
	ewarn "If you are upgrading from a version prior to 3.4 you need"
	ewarn "to fix dynamic linking inconsistencies by executing:"
	ewarn "revdep-rebuild -X --library libxklavier.so.11"
}
