# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnustep-gui/gnustep-gui-0.8.5-r1.ebuild,v 1.5 2004/07/14 23:36:41 agriffis Exp $

inherit gnustep

DESCRIPTION="GNUstep AppKit implementation"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"
IUSE=""
DEPEND=">=dev-util/gnustep-base-1.6.0
	>=media-libs/tiff-3.5.7
	>=media-libs/jpeg-6b-r2"
PDEPEND="=dev-util/gnustep-back-${PV}*"

src_compile() {
	egnustepmake \
		--with-jpeg-library=/usr/lib \
		--with-jpeg-include=/usr/include \
		--with-tiff-library=/usr/lib \
		--with-tiff-include=/usr/include \
		|| die "configure failed"
}
