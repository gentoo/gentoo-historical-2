# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/thumbs/thumbs-0.1.3.ebuild,v 1.6 2007/11/15 20:19:03 drac Exp $

ROX_LIB="2.0.0"
inherit rox

MY_PN="Thumbs"

DESCRIPTION="A very simple Rox thumbnail image manager"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/thumbs.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="amd64 ~sparc x86"

APPNAME=${MY_PN}
S=${WORKDIR}
