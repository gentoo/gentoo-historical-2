# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/mksh/mksh-33.ebuild,v 1.1 2008/03/26 00:12:51 hanno Exp $

DESCRIPTION="MirBSD KSH Shell"
HOMEPAGE="http://mirbsd.de/mksh"
SRC_URI="http://www.mirbsd.org/MirOS/dist/mir/mksh/${PN}-R${PV}.cpio.gz
	http://www.mirbsd.org/cvs.cgi/~checkout~/contrib/code/Snippets/arc4random.c?rev=1.3"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="app-arch/cpio"
RDEPEND=""
S="${WORKDIR}/${PN}"

src_unpack() {
	gzip -dc "${DISTDIR}/${PN}-R${PV}.cpio.gz" | cpio -mid
	cp "${DISTDIR}/arc4random.c?rev=1.3" "${S}/arc4random.c" || die
}

src_compile() {
	sh Build.sh -r || die
}

src_install() {
	exeinto /bin
	doexe mksh || die
	doman mksh.1 || die
	dodoc dot.mkshrc || die
}

src_test() {
	./test.sh || die
}
