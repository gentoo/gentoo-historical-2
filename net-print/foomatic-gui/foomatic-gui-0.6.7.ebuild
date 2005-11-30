# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic-gui/foomatic-gui-0.6.7.ebuild,v 1.1.1.1 2005/11/30 09:48:16 chriswhite Exp $

inherit distutils

DESCRIPTION="GNOME interface for configuring the Foomatic printer filter system"
HOMEPAGE="http://freshmeat.net/projects/foomatic-gui/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT=0
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
S=${WORKDIR}/${PN}

RDEPEND=">=dev-lang/python-2.2.0
	>=dev-python/gnome-python-2.0.0
	>=net-print/foomatic-2.0.2
	>=dev-python/pyxml-0.8
	virtual/ghostscript"
