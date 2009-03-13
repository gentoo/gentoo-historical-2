# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ati/xf86-video-ati-6.7.197.ebuild,v 1.5 2009/03/13 15:25:29 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="ATI video driver"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.2"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xf86miscproto
	x11-proto/xproto
	dri? ( x11-proto/glproto
			x11-proto/xf86driproto
			>=x11-libs/libdrm-2 )"

CONFIGURE_OPTIONS="$(use_enable dri)"

src_install() {
	x-modular_src_install
	insinto /usr/share/hwdata/videoaliases
	doins "${FILESDIR}/old_hw_data/ati.xinf"
	doins "${FILESDIR}/old_hw_data/r128.xinf"
}
