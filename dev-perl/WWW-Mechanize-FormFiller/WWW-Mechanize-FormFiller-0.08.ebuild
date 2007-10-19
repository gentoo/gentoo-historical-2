# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Mechanize-FormFiller/WWW-Mechanize-FormFiller-0.08.ebuild,v 1.1 2007/10/19 20:10:50 ian Exp $

inherit perl-module

DESCRIPTION="Framework to automate HTML forms "
SRC_URI="mirror://cpan/authors/id/C/CO/CORION/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~corion/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/Data-Random
	dev-perl/libwww-perl"
