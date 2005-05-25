# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Session/Apache-Session-1.60.ebuild,v 1.11 2005/05/25 14:36:05 mcummings Exp $

inherit perl-module
MY_PV=${PV/0/}
MY_P=${PN}-${MY_PV}
IUSE=""

S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl module for Apache::Session"
SRC_URI="mirror://cpan/authors/id/J/JB/JBAKER/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jbaker/${MY_P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	perl-core/Digest-MD5
	perl-core/Storable"
