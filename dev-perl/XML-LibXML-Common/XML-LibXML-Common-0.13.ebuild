# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML-Common/XML-LibXML-Common-0.13.ebuild,v 1.7 2004/06/25 01:11:47 agriffis Exp $

IUSE=""

inherit perl-module

DESCRIPTION="Routines and Constants common for XML::LibXML and XML::GDOME."
SRC_URI="http://www.cpan.org/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/XML/${P}.readme"
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc sparc alpha ~mips"

DEPEND="${DEPEND}
	>=dev-libs/libxml2-2.4.1"
