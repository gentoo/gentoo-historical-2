# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/terminal/terminal-0.2.4.ebuild,v 1.3 2005/09/07 18:18:51 bcowan Exp $

DESCRIPTION="Terminal with close ties to xfce"
HOMEPAGE="http://www.os-cillation.com/"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="dbus"

RDEPEND=">=x11-libs/gtk+-2.4
	>=xfce-extra/exo-0.3.0_pre1
	dbus? ( =sys-apps/dbus )
	>=x11-libs/vte-0.11.11
	>=xfce-base/libxfce4mcs-4.2.0"

MY_P="${PN/t/T}-${PV/_/}"
BZIPPED=1
GOODIES=1

if ! use dbus; then
	XFCE_CONFIG="--disable-dbus"
fi

inherit xfce4