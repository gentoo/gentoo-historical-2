# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk-perl/gtk-perl-0.7008-r9.ebuild,v 1.3 2002/12/15 10:44:17 bjb Exp $

inherit perl-module

MY_P=Gtk-Perl-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl bindings for GTK"
SRC_URI="http://www.gtkperl.org/${MY_P}.tar.gz"
HOMEPAGE="http://www.perl.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	media-libs/gdk-pixbuf 
	=x11-libs/gtk+-1.2*
	dev-perl/XML-Writer
	dev-perl/XML-Parser
	gnome? ( gnome-base/gnome-libs )"

mydoc="VERSIONS WARNING NOTES"

use gnome || myconf="${myconf} --without-gnome --without-gnomeprint --without-applets"

src_unpack() {

	unpack ${A}
	# Fix gdk-pixbuf-0.20.0 not detected, bug #10232.
	cd ${S}; patch -p1 < ${FILESDIR}/${P}-gdkpixbuf-detect-fix.patch || die 
	cd ${S}
	cp Makefile.PL Makefile.PL.bak
	perl -pi -e '/CCMD/ && s|/m;|/mg;|' */Makefile.PL
	cd ${S}
        perl Makefile.PL ${myconf} \                                            
        PREFIX=${D}/usr
}


src_compile() {

        make ${mymake} || die "compilation failed"
}
