# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Linux-Inotify2/Linux-Inotify2-1.1.ebuild,v 1.1 2008/02/24 18:50:27 hd_brummy Exp $

inherit perl-module

DESCRIPTION="scalable directory/file change notification"
SRC_URI="http://search.cpan.org/CPAN/authors/id/M/ML/MLEHMANN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mlehmann/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~sparc ~x86"

SRC_TEST="do"

DEPEND="dev-lang/perl"
