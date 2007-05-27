# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML-Common/XML-LibXML-Common-0.13.ebuild,v 1.22 2007/05/27 00:49:29 kumba Exp $

inherit perl-module

DESCRIPTION="Routines and Constants common for XML::LibXML and XML::GDOME"
HOMEPAGE="http://search.cpan.org/~phish/"
SRC_URI="mirror://cpan/authors/id/P/PH/PHISH/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.4.1
	dev-lang/perl"
