# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsole/konsole-4.3.4.ebuild,v 1.2 2009/12/23 00:36:24 abcd Exp $

EAPI="2"

KMNAME="kdebase-apps"
inherit kde4-meta

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook"

COMMONDEPEND="
	!aqua? (
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libxklavier-3.2
		x11-libs/libXrender
		x11-libs/libXtst
	)
"
DEPEND="${COMMONDEPEND}
	!aqua? (
		x11-apps/bdftopcf
		x11-proto/kbproto
		x11-proto/renderproto
	)
"
RDEPEND="${COMMONDEPEND}"
