# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DOM/XML-DOM-1.44.ebuild,v 1.14 2010/01/11 19:02:54 armin76 Exp $

inherit perl-module

DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~tjmather/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-perl/libwww-perl
	>=dev-perl/libxml-perl-0.07
	>=dev-perl/XML-Parser-2.30
	dev-perl/XML-RegExp
	dev-lang/perl"
