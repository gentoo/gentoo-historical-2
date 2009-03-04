# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-desktopthemes/kdeartwork-desktopthemes-4.2.1.ebuild,v 1.1 2009/03/04 20:45:48 alexxy Exp $

EAPI="2"

KMMODULE="desktopthemes"
KMNAME="kdeartwork"
inherit kde4-meta

DESCRIPTION="Additional themes from kde"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	!kdeprefix? ( !<kde-base/kdeplasma-addons-${PV}[-kdeprefix] )"
RDEPEND="${DEPEND}"
