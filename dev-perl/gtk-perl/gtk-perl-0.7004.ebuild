# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk-perl/gtk-perl-0.7004.ebuild,v 1.5 2001/10/06 10:52:28 hallski Exp $

A=Gtk-Perl-${PV}.tar.gz
S=${WORKDIR}/Gtk-Perl-${PV}
DESCRIPTION="Perl bindings for GTK"
SRC_URI="ftp://ftp.rz.ruhr-uni-bochum.de/pub/CPAN/authors/id/L/LU/LUPUS/${A}"
HOMEPAGE="http://www.perl.org/"

DEPEND=">=x11-libs/gtk+-1.2.8 sys-devel/perl"


src_compile() {                           
  perl Makefile.PL 
  try make
}

src_install() {                               
  try make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install
  dodoc ChangeLog MANIFEST NOTES README VERSIONS WARNING
}





