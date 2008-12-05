# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdparanoia/gst-plugins-cdparanoia-0.10.21.ebuild,v 1.1 2008/12/05 20:16:39 ssuominen Exp $

inherit gst-plugins-base

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.21
	media-sound/cdparanoia"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

# Bypass eclass because entire set of plugins is required to satisfy the build.
src_unpack() {
	unpack ${A}
}

src_compile() {
	gst-plugins-base_src_configure
	emake || die "emake failed."
}
