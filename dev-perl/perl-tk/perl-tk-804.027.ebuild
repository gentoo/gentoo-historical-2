# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perl-tk/perl-tk-804.027.ebuild,v 1.8 2004/10/08 17:53:48 gmsoft Exp $

inherit perl-module eutils

MY_P=Tk-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A Perl Module for Tk"
HOMEPAGE="http://search.cpan.org/~ni-s/${MY_P}/"
SRC_URI="http://cpan.org/modules/by-authors/id/NI-S/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha arm hppa ~amd64 ~ia64 ~ppc64"
IUSE=""

DEPEND="virtual/x11"

mydoc="ToDo VERSIONS"
