# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/gimp-print-cups/gimp-print-cups-4.3.0-r1.ebuild,v 1.5 2003/03/08 09:40:37 lordvan Exp $

MY_PN=${PN/-cups/}

DESCRIPTION="The Common Unix Printing System - Gimp Print Drivers"
HOMEPAGE="http://www.cups.org"
KEYWORDS="x86"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

S=${WORKDIR}/${MY_PN}-${PV}
DEPEND="net-print/cups 
	=x11-libs/gtk+-1.2*
	media-gfx/imagemagick
	sys-libs/readline
	sys-devel/perl
        !media-gfx/gimp-print"

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	local myconf
	use nls && myconf="${myconf} --enable-nls"
	use nls || myconf="${myconf} --disable-nls"
	use readline && myconf="${myconf} --enable-readline"
	use readline || myconf="${myconf} --disable-readline"

	#--without-translated-ppds \
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--localstatedir=/var/lib \
		--infodir=/usr/share/info \
		--with-cups \
		--enable-test \
		--with-samples \
		--without-gimp \
		--with-escputil \
		--enable-lexmarkutil \
		--with-foomatic \
		--with-testpattern \
		--with-user-guide \
		--host=${CHOST} ${myconf} || die "bad ./configure"


	emake || die "compile problem"
	patch src/main/gimpprint.m4 < ${FILESDIR}/gimpprint.m4.patch || die
}

src_install () {
	make install DESTDIR=${D} || die

	exeinto /usr/share/gimp-print
	doexe test/{unprint,pcl-unprint,bjc-unprint,parse-escp2,parse-bjc}

	dodoc AUTHORS COPYING ChangeLog NEWS README \
		 doc/gimpprint.ps
	dohtml doc/manual-html doc/FAQ.html
}
