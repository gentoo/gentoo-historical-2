# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/ncview/ncview-1.92d.ebuild,v 1.5 2004/04/19 11:49:24 phosphan Exp $

DESCRIPTION="X-based viewer for netCDF files"
SRC_URI="ftp://cirrus.ucsd.edu/pub/ncview/${P}.tar.gz"
HOMEPAGE="http://meteora.ucsd.edu/~pierce/ncview_home_page.html"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND="app-sci/netcdf
	virtual/x11"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install() {
#	dodir /lib/ncview
	dobin ncview
	doman ncview.1
	insinto /usr/lib/ncview
	doins 3gauss.ncmap 3saw.ncmap default.ncmap \
		detail.ncmap hotres.ncmap \
		nc_overlay.earth.lat-lon.p8deg \
		nc_overlay.lat-lon-grid.20x60 \
		nc_overlay.lat-lon-grid.10x30
	insinto /usr/lib/X11/app-defaults
	doins Ncview
}
