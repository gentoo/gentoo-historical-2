# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mosfet-liquid-widgets/mosfet-liquid-widgets-0.9.6_pre4.ebuild,v 1.8 2004/06/19 13:30:55 pyrania Exp $

inherit kde

need-kde 3.1_rc1

S=${WORKDIR}/mosfet-liquid0.9.6pre4
DESCRIPTION="Mosfet's High-Permormance Liquid Widgets and Style for KDE 3.1.x"
SRC_URI="http://www.mosfet.org/mosfet-liquid${PV//_/-}.tar.gz"
HOMEPAGE="http://www.mosfet.org/liquid.html"
LICENSE="BSD"

KEYWORDS="x86 ppc sparc"
ISUE=""

newdepend ">=kde-base/kdebase-3.1_rc1"
