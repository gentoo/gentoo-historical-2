# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-gettext/Locale-gettext-1.01-r1.ebuild,v 1.11 2004/06/25 00:43:03 agriffis Exp $

inherit perl-module

MY_P="gettext-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Perl module for accessing the GNU locale utilities"
HOMEPAGE="http://cpan.org/modules/by-module/Locale/${MY_P}.readme"
SRC_URI="http://cpan.org/modules/by-module/Locale/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ~ppc sparc mips alpha arm amd64 s390"
IUSE=""

DEPEND="sys-devel/gettext"
