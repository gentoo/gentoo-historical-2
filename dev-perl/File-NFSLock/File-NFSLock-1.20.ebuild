# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NFSLock/File-NFSLock-1.20.ebuild,v 1.5 2007/01/15 19:40:37 mcummings Exp $

inherit perl-module

DESCRIPTION="NFS compatible (safe) locking utility"
SRC_URI="mirror://cpan/authors/id/B/BB/BBB/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~bbb/"

SRC_TEST="do"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~x86"
IUSE=""


DEPEND="dev-lang/perl"
