# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI/CGI-3.04.ebuild,v 1.6 2004/10/16 23:57:20 rac Exp $

inherit perl-module

myconf="INSTALLDIRS=vendor"
MY_P=${PN}.pm-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Perl CGI Module"
SRC_URI="http://www.cpan.org/authors/id/L/LD/LDS/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/L/LD/LDS/CGI.pm-${PV}/"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc alpha ~mips ia64"
DEPEND=">=dev-lang/perl-5.8.0-r12"
