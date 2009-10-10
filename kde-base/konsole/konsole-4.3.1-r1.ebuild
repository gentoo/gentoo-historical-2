# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsole/konsole-4.3.1-r1.ebuild,v 1.2 2009/10/10 09:53:50 ssuominen Exp $

EAPI="2"

KMNAME="kdebase-apps"
inherit kde4-meta

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook"

COMMONDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/libxklavier-3.2
	x11-libs/libXrender
	x11-libs/libXtst
"
DEPEND="${COMMONDEPEND}
	x11-apps/bdftopcf
	x11-proto/kbproto
	x11-proto/renderproto
"
RDEPEND="${COMMONDEPEND}"

PATCHES=( "${FILESDIR}/${P}-kpart-backport-fix.patch" )
