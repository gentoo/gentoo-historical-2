# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/mksh/mksh-23.ebuild,v 1.3 2006/06/14 23:45:01 hanno Exp $

DESCRIPTION="MirBSD KSH Shell"
HOMEPAGE="http://mirbsd.de/mksh/"
SRC_URI="http://mirbsd.mirsolutions.de/MirOS/distfiles/${PN}-R${PV}.cpio.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
DEPEND="app-arch/cpio"
RDEPEND=""
S=${WORKDIR}/${PN}

src_unpack() {
	gzip -dc ${DISTDIR}/${PN}-R${PV}.cpio.gz | cpio -mid
}

src_compile() {
	CPPFLAGS="-D_FILE_OFFSET_BITS=64" sh Build.sh -d -r
}

src_install() {
	dobin mksh
	doman mksh.1
}
