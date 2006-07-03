# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-AuthCookie/Apache-AuthCookie-3.08.ebuild,v 1.5 2006/07/03 20:07:15 ian Exp $

inherit perl-module

DESCRIPTION="Perl Authentication and Authorization via cookies"
HOMEPAGE="http://search.cpan.org/~mschout/Apache-AuthCookie-3.08/"
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHOUT/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 x86"
IUSE=""

DEPEND=">=www-apache/mod_perl-2"
RDEPEND="${DEPEND}"