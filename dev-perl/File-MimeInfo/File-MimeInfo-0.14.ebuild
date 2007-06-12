# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-MimeInfo/File-MimeInfo-0.14.ebuild,v 1.1 2007/06/12 18:41:14 mcummings Exp $

inherit perl-module

DESCRIPTION="Determine file type"
SRC_URI="mirror://cpan/authors/id/P/PA/PARDUS/${PN}/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~pardus/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

RDEPEND="dev-perl/File-BaseDir
	x11-misc/shared-mime-info
	dev-lang/perl"
DEPEND="dev-perl/module-build
	${RDEPEND}"
