# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-POP3Client/Mail-POP3Client-2.7-r2.ebuild,v 1.3 2004/06/25 00:44:36 agriffis Exp $

inherit perl-module

MY_P="POP3Client-${PV}"
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"
DESCRIPTION="POP3 client module for Perl"
SRC_URI="http://www.cpan.org/modules/by-module/Mail/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha s390"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"

mydoc="FAQ"
