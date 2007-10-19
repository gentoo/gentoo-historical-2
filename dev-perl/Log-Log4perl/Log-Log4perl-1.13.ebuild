# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-Log4perl/Log-Log4perl-1.13.ebuild,v 1.1 2007/10/19 21:22:29 ian Exp $

inherit perl-module

DESCRIPTION="Log::Log4perl is a Perl port of the widely popular log4j logging package."
SRC_URI="mirror://cpan/authors/id/M/MS/MSCHILLI/${P}.tar.gz"
HOMEPAGE="http://log4perl.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
