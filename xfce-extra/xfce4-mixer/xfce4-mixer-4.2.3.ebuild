# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mixer/xfce4-mixer-4.2.3.ebuild,v 1.1 2005/12/09 21:11:20 dostrow Exp $

inherit xfce42

DESCRIPTION="Xfce 4 mixer panel plugin"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
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