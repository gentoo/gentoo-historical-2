# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/yacas/yacas-1.0.55.ebuild,v 1.1 2003/07/09 23:48:16 george Exp $

IUSE=""

DESCRIPTION="very powerful general purpose Computer Algebra System"
HOMEPAGE="http://yacas.sourceforge.net/"
SRC_URI="http://${PN}.sourceforge.net/backups/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=sys-apps/sed-4"

src_compile() {
	econf || die "./configure failed"
	emake || die

	# only build gui, if we use x
	# proteus is untested and does not compile this way,
	# needs an installed (and merged) yacas to compile.
	#if use X ; then
	#	cd proteus
	#	emake depend -f makefile.linux 	|| die
	#	emake -f makefile.linux 	|| die
	#	cd ..
	#fi
}

src_install() {
	# a very strange Makefile's, that do not honor standard wrappings :(
	find -name Makefile |xargs sed -i -e "s:datadir = /usr/share:datadir = ${D}/usr/share:"
	cd manmake
	sed -i -e "s:htmldir = :htmldir = ${D}:" -e "s:psdir = :psdir = ${D}:" Makefile
	cd ${S}

	DESTDIR=${D} make install-strip || die

	# see above notice
	#if ( use X ); then
	#	cd proteus
	#	emake install-strip -f makefile.linux || die
	#	cd ..
	#fi

	dodoc AUTHORS INSTALL NEWS README TODO
	mv ${D}/usr/share/${PN}/documentation ${D}/usr/share/doc/${PF}/html
	rmdir ${D}/usr/include/
}
