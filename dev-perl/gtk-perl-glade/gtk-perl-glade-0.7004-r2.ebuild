# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk-perl-glade/gtk-perl-glade-0.7004-r2.ebuild,v 1.5 2002/07/25 05:23:30 seemant Exp $

inherit perl-module

MY_P=Gtk-Perl-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl bindings for GTK"
SRC_URI="ftp://ftp.rz.ruhr-uni-bochum.de/pub/CPAN/authors/id/L/LU/LUPUS/${MY_P}.tar.gz"
HOEMPAGE="http://www.perl.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="${DEPEND}
	>=dev-perl/gtk-perl-${PV}
	dev-util/glade"

src_compile() {            
	perl Makefile.PL
	emake || die
	cd Glade               
	perl Makefile.PL 
	emake || die
}

src_install() {                               
	cd Glade
	make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install || die
}
