# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglarea/gtkglarea-1.2.3-r1.ebuild,v 1.21 2005/07/24 15:46:31 herbs Exp $

inherit multilib

# GTKGLArea has been abandoned by the author. We'll continue to mirror the
# source on Gentoo mirrors.
DESCRIPTION="GL Extentions for gtk+"
HOMEPAGE="http://www.student.oulu.fi/~jlof/gtkglarea/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE=""

DEPEND="virtual/libc
	=x11-libs/gtk+-1.2*
	virtual/glu
	virtual/opengl"

src_unpack() {
	unpack ${A}
	cd ${S}
	if [ $(get_libdir) != "lib" ] ; then
		libtoolize --copy --force || die "libtoolize failed"
		aclocal || die "aclocal failed"
		autoconf || die "autoconf failed"
	fi
}

src_compile() {
	./configure --prefix=/usr \
		--host=${CHOST} \
		--libdir=/usr/$(get_libdir) || die
	emake || die
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir) install || die
	dodoc AUTHORS ChangeLog NEWS README
	docinto txt
	dodoc docs/*.txt
}
