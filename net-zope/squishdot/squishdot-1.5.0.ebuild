# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/squishdot/squishdot-1.5.0.ebuild,v 1.2 2003/04/04 06:03:54 kutsuya Exp $

inherit zproduct
NEW_PV=$(echo ${PV} |sed -e "s/\./-/g")

DESCRIPTION="A web-based news publishing and discussion product for Zope."
HOMEPAGE="http://squishdot.org/"
SRC_URI="${HOMEPAGE}/Download/Squishdot-${NEW_PV}.tar.gz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc"

ZPROD_LIST="Squishdot"



