# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI/CGI-2.97.ebuild,v 1.1 2003/07/16 17:23:23 mcummings Exp $

inherit perl-module

MY_P=${PN}.pm-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Perl CGI Module"
SRC_URI="http://www.cpan.org/authors/id/L/LD/LDS/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/L/LD/LDS/CGI.pm-${PV}/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha"

DEPEND=">=dev-perl/File-Spec-0.82"
