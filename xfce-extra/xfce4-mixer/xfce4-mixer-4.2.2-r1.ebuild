# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mixer/xfce4-mixer-4.2.2-r1.ebuild,v 1.2 2006/12/02 09:51:49 dev-zero Exp $

inherit xfce42

DESCRIPTION="Xfce 4 mixer panel plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="alsa"

RDEPEND="|| ( ( x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM )
	virtual/x11 )
	~xfce-base/xfce4-panel-${PV}
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xproto virtual/x11 )"

use alsa && XFCE_CONFIG="--with-sound=alsa"

core_package