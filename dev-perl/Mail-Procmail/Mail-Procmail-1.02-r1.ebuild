# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Procmail/Mail-Procmail-1.02-r1.ebuild,v 1.7 2004/06/25 00:44:46 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Mail sorting/delivery module for Perl."
SRC_URI="http://www.cpan.org/modules/by-module/Mail/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/MailTools-1.15
	>=dev-perl/LockFile-Simple-0.2.5"
