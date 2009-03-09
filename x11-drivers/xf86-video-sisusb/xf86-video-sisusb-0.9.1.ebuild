# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sisusb/xf86-video-sisusb-0.9.1.ebuild,v 1.2 2009/03/09 01:15:43 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="SiS USB video driver"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86miscproto
	x11-proto/xineramaproto
	x11-proto/xproto"

src_unpack() {
	x-modular_src_unpack
	cd "${S}"
	# This package relies on the define as xorg-server-1.6 has it, so
	# sed it back to what xorg-server-1.5 uses
	sed -i '/XF86_VERSION_NUMERIC/s:\([[:digit:]]\)):\1,0):' src/*.[ch]
}
