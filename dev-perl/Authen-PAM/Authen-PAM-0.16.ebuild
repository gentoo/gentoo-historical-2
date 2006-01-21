# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-PAM/Authen-PAM-0.16.ebuild,v 1.6 2006/01/21 21:10:08 corsair Exp $

inherit perl-module

DESCRIPTION="Interface to PAM library"
HOMEPAGE="http://search.cpan.org/~nikip/Authen-PAM-0.16/"
SRC_URI="mirror://cpan/authors/id/N/NI/NIKIP/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="sys-libs/pam"

export OPTIMIZE="$CFLAGS"
