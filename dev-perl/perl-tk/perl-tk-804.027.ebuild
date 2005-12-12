# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perl-tk/perl-tk-804.027.ebuild,v 1.17 2005/12/12 08:55:44 spyderous Exp $

inherit perl-module eutils

MY_P=Tk-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A Perl Module for Tk"
HOMEPAGE="http://search.cpan.org/~ni-s/${MY_P}/"
SRC_URI="mirror://cpan/authors/id/N/NI/NI-S/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha arm hppa amd64 ia64 ppc64 mips"
IUSE=""

DEPEND="|| ( x11-libs/libX11 virtual/x11 )"

myconf="X11LIB=/usr/$(get_libdir)"

mydoc="ToDo VERSIONS"
