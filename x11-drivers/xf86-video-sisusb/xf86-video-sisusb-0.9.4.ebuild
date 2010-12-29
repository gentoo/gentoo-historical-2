# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sisusb/xf86-video-sisusb-0.9.4.ebuild,v 1.6 2010/12/29 22:39:30 maekke Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="SiS USB video driver"
KEYWORDS="~alpha amd64 arm ~ia64 ~ppc ppc64 ~sh ~sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86miscproto
	x11-proto/xineramaproto
	x11-proto/xproto"
