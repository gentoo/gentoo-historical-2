# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libksba/libksba-0.4.6.ebuild,v 1.3 2003/02/13 10:43:20 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="KSBA makes X.509 certificates and CMS easily accessible to applications"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/aegypten/${P}.tar.gz"
HOMEPAGE="http://www.gnupg.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

src_install(){
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README README-alpha THANKS TODO VERSION
}
