# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mosfet-liquid-widgets/mosfet-liquid-widgets-0.7-r3.ebuild,v 1.8 2002/10/22 15:45:01 bjb Exp $

inherit kde-base || die

need-kde 2.2

PN=mosfet-liquid
S=${WORKDIR}/${PN}${PV}
DESCRIPTION="Mosfet's High-Permormance Liquid Widgets and Style for KDE2.2+"
SRC_URI="http://www.mosfet.org/${PN}${PV}.tar.gz"
LICENSE="QPL-1.0"

KEYWORDS="x86 ppc alpha"

HOMEPAGE="http://www.mosfet.org/liquid.html"

newdepend ">=kde-base/kdebase-2.2"
