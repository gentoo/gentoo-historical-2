# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp-print/gimp-print-5.0.0_alpha2.ebuild,v 1.2 2004/06/07 21:43:50 agriffis Exp $

inherit flag-o-matic libtool

IUSE="nls gtk readline cups foomaticdb ppds"

MY_P=${P/_/-}

DESCRIPTION="Gimp Print Drivers"
HOMEPAGE="http://gimp-print.sourceforge.net"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64"
SRC_URI="mirror://sourceforge/gimp-print/${MY_P}.tar.bz2"

DEPEND="cups? ( >=net-print/cups-1.1.14 )
	media-gfx/imagemagick
	virtual/ghostscript
	sys-libs/readline
	gtk? ( =x11-libs/gtk+-1.2* )
	dev-lang/perl
	foomaticdb? ( net-print/foomatic-db-engine )"

LICENSE="GPL-2"
SLOT="0"

S=${WORKDIR}/${MY_P}

append-flags -fno-inline-functions

src_compile() {
	elibtoolize --reverse-deps

	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	use readline \
		&& myconf="${myconf} --with-readline" \
		|| myconf="${myconf} --without-readline"

	use gtk \
		&& myconf="${myconf} --enable-lexmarkutil" \
		|| myconf="${myconf} --disable-lexmarkutil"

	has_version =media-gfx/gimp-1.2* \
		&& myconf="${myconf} --with-gimp" \
		|| myconf="${myconf} --without-gimp"

	if use cups; then
		myconf="${myconf} --with-cups"
	else
		myconf="${myconf} --without-cups"
	fi

	if use cups && use ppds; then
		myconf="${myconf} --enable-cups-ppds"
	else
		myconf="${myconf} --disable-cups-ppds"
	fi

	use foomaticdb \
		&& myconf="${myconf} --with-foomatic3" \
		|| myconf="${myconf} --without-foomatic"

	# --without-translated-ppds enabled \
	GIMPTOOL=/usr/bin/gimptool-1.2 econf \
		--enable-test \
		--with-ghostscript \
		--with-user-guide \
		--with-samples \
		--with-escputil \
		$myconf || die

	# IJS Patch
	sed -i -e "s/<ijs/<ijs\/ijs/g" src/ghost/ijsgimpprint.c

	emake || die "compile problem"
}

src_install () {
	make install DESTDIR=${D} || die

	exeinto /usr/share/gimp-print
	doexe test/{unprint,pcl-unprint,bjc-unprint,parse-escp2,escp2-weavetest,run-testdither,run-weavetest,testdither}

	dodoc AUTHORS COPYING ChangeLog NEWS README \
		doc/users_guide/users-guide.ps doc/users_guide/users-guide.pdf \
		${D}/usr/share/gimp-print/doc/gimpprint.ps
	dohtml doc/FAQ.html
	dohtml -r doc/users_guide/html doc/developer/developer-html
	rm -fR ${D}/usr/share/gimp-print/doc
}
