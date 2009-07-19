# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-4.0.ebuild,v 1.1 2009/07/19 19:50:14 eva Exp $

inherit eutils

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"
SRC_URI="mirror://sourceforge/gswitchit/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="x11-misc/xkeyboard-config
	x11-libs/libX11
	>=x11-libs/libXi-1.1.3
	x11-apps/xkbcomp
	x11-libs/libxkbfile
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.0
	app-text/iso-codes"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.4 )"

src_compile() {
	local xkbbase

	# see bug #113108
	if has_version x11-apps/xkbcomp; then
		xkbbase=/usr/share/X11/xkb
	else
		xkbbase=/usr/$(get_libdir)/X11/xkb
	fi

	econf \
		--disable-static
		--with-xkb-base=${xkbbase} \
		--with-xkb-bin-base=/usr/bin \
		$(use_enable doc gtk-doc)

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS CREDITS ChangeLog NEWS README || die "dodoc failed"
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libxklavier.so.12
	preserve_old_lib /usr/$(get_libdir)/libxklavier.so.12.2.0
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libxklavier.so.12
	preserve_old_lib_notify /usr/$(get_libdir)/libxklavier.so.12.2.0
}
