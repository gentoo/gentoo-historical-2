# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsole/konsole-4.6.2.ebuild,v 1.1 2011/04/06 14:19:24 scarabeus Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdebase-apps"
EGIT_REPONAME="konsole"
KDE_SCM="git"

if [[ ${PV} = *9999* ]]; then
	inherit kde4-base
else
	inherit kde4-meta
fi

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

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
