# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-LocalDelivery/Email-LocalDelivery-0.217.ebuild,v 1.5 2008/01/05 16:52:21 armin76 Exp $

inherit perl-module

DESCRIPTION="Local delivery of RFC2822 message format and headers"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rjbs/"

LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"
SLOT="0"

DEPEND="dev-lang/perl dev-perl/Email-FolderType dev-perl/File-Path-Expand"

#File::Path::Expand
