# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enscript/enscript-1.6.3.ebuild,v 1.7 2002/10/04 05:04:57 vapier Exp $

S=${WORKDIR}/${P}
SRC_URI="http://www.iki.fi/mtr/genscript/${P}.tar.gz"

HOMEPAGE="http://www.gnu.org/software/enscript/enscript.html"
KEYWORDS="x86 sparc sparc64"
SLOT="0"
LICENSE="GPL-2"
DESCRIPTION="GNU's enscript is a powerful text-to-postsript converter"

DEPEND="sys-devel/flex
	sys-devel/bison"

src_compile() {

	./configure 	--host=${CHOST} \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--infodir=/usr/share/info \
			--sysconfdir=/etc
	assert

	emake || die
}

src_install () {
	make 	prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		install || die
	
	dodoc AUTHORS COPYING ChangeLog FAQ.html NEWS README* THANKS TODO
}

pkg_postinst() {
	echo "
	Now, customize /etc/enscript.cfg.
	"
}
