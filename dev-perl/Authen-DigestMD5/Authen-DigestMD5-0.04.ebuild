# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-DigestMD5/Authen-DigestMD5-0.04.ebuild,v 1.12 2005/11/29 03:14:35 tgall Exp $

inherit perl-module

DESCRIPTION="SASL DIGEST-MD5 authentication (RFC2831)"
SRC_URI="mirror://cpan/authors/id/S/SA/SALVA/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~salva/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

export OPTIMIZE="$CFLAGS"
