# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/lard/lard-2.0.14.ebuild,v 1.4 2002/11/28 01:45:37 george Exp $

IUSE=""

DESCRIPTION="Language for Asynchronous Research and Development. Used to describe and simulate asynchronous circuits"
HOMEPAGE="http://www.cs.man.ac.uk/amulet/projects/lard/"
SRC_URI="ftp://ftp.cs.man.ac.uk/pub/amulet/lard/${P}.tar.gz
	ftp://ftp.cs.man.ac.uk/pub/amulet/lard/lard-demos-2.0.12.tar.gz
	ftp://ftp.cs.man.ac.uk/pub/amulet/lard/lard-doc-2.0.14.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~sparc64"

DEPEND="sys-devel/flex
	dev-lang/tcl
	dev-lang/tk
	sys-devel/bison
	sys-devel/binutils
	dev-tcltk/tclx
	dev-libs/gmp
	sys-devel/perl
	dev-tcltk/bwidget"

src_unpack() {
	unpack ${A} ; cd ${S}
	patch -p1 < ${FILESDIR}/lard-2.0.14-configure.patch || die
}

src_compile() {
	econf --libdir=/usr/lib/lard
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"

	dodoc AUTHORS COPYING NEWS README

	dodir /usr/share/doc/${PF}/demos
	cp -R ${WORKDIR}/lard-demos-2.0.12/* ${D}/usr/share/doc/${PF}/demos
	cd ${WORKDIR}/lard-doc
	find . -name "*.doc *.cgi" -exec rm {} \;
	dodir /usr/share/doc/${PF}/html
	cp -R * ${D}/usr/share/doc/${PF}/html
	cd ${WORKDIR}
	dosed "s:\$exec_prefix:#\$exec_prefix:g" /usr/bin/lcd
}
