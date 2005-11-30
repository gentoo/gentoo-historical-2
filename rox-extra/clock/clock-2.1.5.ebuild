# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/clock/clock-2.1.5.ebuild,v 1.1.1.1 2005/11/30 09:40:52 chriswhite Exp $

MY_PN="Clock"

DESCRIPTION="Clock - a clock for the ROX Desktop"
HOMEPAGE="http://www.kerofin.demon.co.uk/rox/clock.html"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

ROX_CLIB_VER=2.1.2

SET_PERM=true

APPNAME=Clock

S=${WORKDIR}

inherit rox
