# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/boehm-gc/boehm-gc-6.2-r1.ebuild,v 1.1 2004/03/11 20:38:14 usata Exp $

S=${WORKDIR}/gc${PV/_/}

DESCRIPTION="The Boehm-Demers-Weiser conservative garbage collector"
HOMEPAGE="http://www.hpl.hp.com/personal/Hans_Boehm/gc/"
SRC_URI="http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc${PV/_/}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha ~ppc ~amd64"

DEPEND="virtual/glibc"

src_compile() {
	econf --enable-threads=pthreads \
		|| die "Configure failed..."
	emake || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		DESTDIR=${D} install-exec || die
	insinto /usr/include/gc
	doins include/*.h
	insinto /usr/include/gc/private
	doins include/private/*.h

	dodoc README.QUICK doc/README* doc/barrett_diagram
	dohtml doc/*.html
	newman doc/gc.man gc.3
}
