# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/terminal/terminal-0.2.2-r1.ebuild,v 1.4 2005/02/25 22:50:36 bcowan Exp $

DESCRIPTION="Terminal with close ties to xfce"
HOMEPAGE="http://www.os-cillation.com/"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"

RDEPEND=">=x11-libs/gtk+-2.4*
	>=xfce-extra/exo-0.2.0-r1
	>=x11-libs/vte-0.11.11
	>=xfce-base/libxfce4mcs-4.2.0"
MY_P="${PN/t/T}-${PV}"
BZIPPED=1
GOODIES=1

inherit xfce4
