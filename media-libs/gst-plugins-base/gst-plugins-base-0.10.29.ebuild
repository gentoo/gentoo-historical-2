# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-base/gst-plugins-base-0.10.29.ebuild,v 1.1 2010/06/28 08:42:41 leio Exp $

# order is important, gnome2 after gst-plugins
inherit gst-plugins-base gst-plugins10 gnome2 flag-o-matic eutils
# libtool

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~hppa ~ia64 ~ppc ~ppc-macos ~ppc64 ~sh ~sparc ~sparc-solaris ~x64-macos ~x64-solaris ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~x86-linux ~x86-macos ~x86-solaris"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.18
	>=media-libs/gstreamer-0.10.29
	>=dev-libs/liboil-0.3.14
	dev-libs/libxml2
	app-text/iso-codes
	!<media-libs/gst-plugins-bad-0.10.10"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.11.5 )
	dev-util/pkgconfig"

DOCS="AUTHORS README RELEASE"

src_compile() {
	# gst doesnt handle opts well, last tested with 0.10.15
	strip-flags
	replace-flags "-O3" "-O2"

	gst-plugins-base_src_configure \
		--disable-introspection \
		$(use_enable nls)
	emake || die "emake failed."
}

src_install() {
	gnome2_src_install
}
