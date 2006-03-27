# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-PO/Locale-PO-0.16.ebuild,v 1.4 2006/03/27 19:29:04 gustavoz Exp $

inherit perl-module

DESCRIPTION="Object-oriented interface to gettext po-file entries"
SRC_URI="mirror://cpan/authors/id/A/AL/ALANSZ/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~alansz/${P}/"

DEPEND="${DEPEND}
	sys-devel/gettext"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~m68k ~ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

SRC_TEST="do"
