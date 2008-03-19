# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-PO/Locale-PO-0.17-r1.ebuild,v 1.6 2008/03/19 03:04:01 jer Exp $

inherit perl-module

DESCRIPTION="Object-oriented interface to gettext po-file entries"
HOMEPAGE="http://search.cpan.org/~alansz/"
SRC_URI="mirror://cpan/authors/id/A/AL/ALANSZ/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="sys-devel/gettext
	dev-perl/File-Slurp
	dev-lang/perl"

SRC_TEST="do"
