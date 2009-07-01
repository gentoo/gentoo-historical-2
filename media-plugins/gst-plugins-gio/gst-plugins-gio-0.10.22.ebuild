# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gio/gst-plugins-gio-0.10.22.ebuild,v 1.8 2009/07/01 16:36:15 armin76 Exp $

inherit gst-plugins-base

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.22
	>=dev-libs/glib-2.15.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	gst-plugins-base_src_configure --enable-experimental
	gst-plugins10_find_plugin_dir
	emake || die "emake failed."
}
