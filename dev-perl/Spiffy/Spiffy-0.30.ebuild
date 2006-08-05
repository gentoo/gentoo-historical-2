# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spiffy/Spiffy-0.30.ebuild,v 1.11 2006/08/05 20:36:41 mcummings Exp $

inherit perl-module

DESCRIPTION="Spiffy Perl Interface Framework For You"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/I/IN/INGY/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc ~x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-lang/perl-5.6.1"
RDEPEND="${DEPEND}"
