# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cgi-Simple/Cgi-Simple-0.075.ebuild,v 1.1 2004/06/05 14:32:31 mcummings Exp $

inherit perl-module


S=${WORKDIR}/${P}
DESCRIPTION="The Perl CGI::Simple Module"
SRC_URI="http://www.cpan.org/modules/by-authors/id/J/JF/JFREEMAN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/JFREEMAN/${P}/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha"

SRC_TEST="do"
