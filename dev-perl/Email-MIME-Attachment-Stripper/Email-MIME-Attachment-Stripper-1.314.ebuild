# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-MIME-Attachment-Stripper/Email-MIME-Attachment-Stripper-1.314.ebuild,v 1.3 2009/11/19 07:48:11 tove Exp $

inherit perl-module

DESCRIPTION="Strip the attachments from a mail"
HOMEPAGE="http://search.cpan.org/~rjbs/"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ia64 ~ppc ~ppc64 sparc x86"

DEPEND=">=dev-perl/Email-MIME-1.857
	|| ( >=dev-perl/Email-MIME-1.900 >=dev-perl/Email-MIME-Modifier-1.441 )
	>=dev-perl/Email-MIME-ContentType-1.012
	dev-lang/perl"

SRC_TEST="do"
