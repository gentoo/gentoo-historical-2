# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/openbox/openbox-1.2.4.ebuild,v 1.7 2003/02/13 17:51:24 vapier Exp $

IUSE="nls"

inherit commonbox

S=${WORKDIR}/${P}
DESCRIPTION="Window manager based on BlackBox"
SRC_URI="ftp://sunsite.dk/projects/openbox/${P}.tar.gz"
HOMEPAGE="http://openbox.sunsite.dk"

SLOT="1"
LICENSE="BSD"
KEYWORDS="x86 ppc sparc "

myconf="--with-x \
	--enable-shape \
	--enable-slit \
	--enable-interlace \
	--enable-clobber"


mydoc="CHANGE* LICENSE BUGS CodingStyle data/README*"
