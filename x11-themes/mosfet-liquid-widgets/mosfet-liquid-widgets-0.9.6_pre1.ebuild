# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mosfet-liquid-widgets/mosfet-liquid-widgets-0.9.6_pre1.ebuild,v 1.2 2003/01/19 19:08:46 verwilst Exp $
inherit kde-base

need-kde 3.1_rc1

S=${WORKDIR}/mosfet-liquid0.9.6pre1
DESCRIPTION="Mosfet's High-Permormance Liquid Widgets and Style for KDE 3.1.x"
SRC_URI="http://www.mosfet.org/mosfet-liquid${PV//_/-}.tar.gz"
HOMEPAGE="http://www.mosfet.org/liquid.html"
LICENSE="BSD"

KEYWORDS="~x86"

newdepend ">=kde-base/kdebase-3.1_rc1"
