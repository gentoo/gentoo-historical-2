# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Sync/File-Sync-0.09.ebuild,v 1.3 2004/06/27 17:41:34 hansmi Exp $

inherit perl-module

DESCRIPTION="Perl access to fsync() and sync() function calls"
HOMEPAGE="http://search.cpan.org/~cevans/${P}/"
SRC_URI="http://www.cpan.org/authors/id/C/CE/CEVANS/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

SRC_TEST="do"
