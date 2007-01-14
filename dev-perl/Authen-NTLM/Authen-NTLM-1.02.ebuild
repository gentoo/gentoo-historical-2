# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-NTLM/Authen-NTLM-1.02.ebuild,v 1.17 2007/01/14 22:26:16 mcummings Exp $

inherit perl-module

S=${WORKDIR}/NTLM-${PV}
DESCRIPTION="An NTLM authentication module"
SRC_URI="mirror://cpan/authors/id/M/MA/MARKBUSH/NTLM-${PV}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Authen/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
IUSE=""

DEPEND=">=virtual/perl-MIME-Base64-3.00
	dev-lang/perl"

export OPTIMIZE="$CFLAGS"
