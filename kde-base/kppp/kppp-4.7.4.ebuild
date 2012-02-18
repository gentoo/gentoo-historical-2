# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kppp/kppp-4.7.4.ebuild,v 1.4 2012/02/18 15:51:35 nixnut Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="KDE: A dialer and front-end to pppd."
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="
	net-dialup/ppp
"
