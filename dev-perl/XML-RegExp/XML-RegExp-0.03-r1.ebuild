# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-RegExp/XML-RegExp-0.03-r1.ebuild,v 1.11 2005/08/26 00:42:34 agriffis Exp $

inherit perl-module

DESCRIPTION="A Perl module which contains contains regular expressions for the following XML tokens: BaseChar, Ideographic, Letter, Digit, Extender, CombiningChar, NameChar, EntityRef, CharRef, Reference, Name, NmToken, and AttValue."
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/XML/XML-RegExp-0.03.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.29"
