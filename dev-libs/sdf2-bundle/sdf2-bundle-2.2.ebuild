# Copyright 2004-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/sdf2-bundle/sdf2-bundle-2.2.ebuild,v 1.1 2004/07/17 22:47:02 karltk Exp $

DESCRIPTION="Advanced syntax definition formalism"
HOMEPAGE="http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/SDF2"
SRC_URI="ftp://ftp.stratego-language.org/pub/stratego/sdf2/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=dev-libs/aterm-2.1"

src_compile() {
	oldCFLAGS="${CFLAGS}"
	CFLAGS=""
	econf || die "Failed to configure"
	CFLAGS=${oldCFLAGS}
	make || die "Failed to compile"
}

src_install() {
	make DESTDIR=${D} install || die "Failed to install"
}
