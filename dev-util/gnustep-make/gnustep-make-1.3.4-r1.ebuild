# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnustep-make/gnustep-make-1.3.4-r1.ebuild,v 1.5 2003/02/28 16:54:59 liquidx Exp $

DESCRIPTION="GNUstep makefile package (unstable)"
HOMEPAGE="http://www.gnustep.org"
LICENSE="LGPL-2.1"
DEPEND="virtual/glibc
	>=sys-devel/gcc-3.1
	>=dev-libs/ffcall-1.8d
	>=dev-libs/gmp-3.1.1
	>=dev-util/guile-1.4
	>=dev-libs/openssl-0.9.6d
	>=media-libs/tiff-3.5.7-r1
	>=dev-libs/libxml2-2.4.22
	>=x11-wm/WindowMaker-0.80.1"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="x86 sparc "
SLOT="0"

src_compile() {
	./configure \
		--host=${CHOST} || die "./configure failed"
	emake || die
}

src_install () {

	make \
	GNUSTEP_SYSTEM_ROOT=${D}/usr/GNUstep/System \
	GNUSTEP_LOCAL_ROOT=${D}/usr/GNUstep/Local \
	GNUSTEP_NETWORK_ROOT=${D}/usr/GNUstep/Network \
	install || die "install failed"

}
