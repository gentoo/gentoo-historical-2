# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-gnustep/imageviewer/imageviewer-0.6.2.ebuild,v 1.4 2004/04/17 19:43:33 aliz Exp $

inherit gnustep

DESCRIPTION="ImageViewer is a small image viewer"
HOMEPAGE="http://www.nice.ch/~phip/softcorner.html"
SRC_URI="http://www.nice.ch/~phip/ImageViewer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=dev-util/gnustep-gui-0.8.5"

S=${WORKDIR}/ImageViewer
