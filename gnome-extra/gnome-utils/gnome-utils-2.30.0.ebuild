# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-2.30.0.ebuild,v 1.8 2010/09/29 09:51:35 nirbheek Exp $

EAPI="2"

inherit gnome2

DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="doc ipv6 test"

RDEPEND=">=dev-libs/glib-2.20.0
	>=x11-libs/gtk+-2.18.0
	>=gnome-base/gnome-panel-2.13.4
	>=gnome-base/libgtop-2.12
	>=gnome-base/gconf-2
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libXext
	x11-libs/libX11"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.10 )"

DOCS="AUTHORS ChangeLog NEWS README THANKS"

pkg_setup() {
	if ! use debug; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		$(use_enable ipv6)
		--enable-maintainer-flags=no
		--enable-zlib
		--disable-static
		--disable-schemas-install
		--disable-scrollkeeper"
}

src_prepare() {
	gnome2_src_prepare

	# Remove idiotic -D.*DISABLE_DEPRECATED cflags
	# This method is kinda prone to breakage. Recheck carefully with next bump.
	# bug 339074
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode 
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"

	if ! use test ; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die "sed 2 failed"
	fi
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
