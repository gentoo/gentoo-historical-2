# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DT/XML-DT-0.24.1.ebuild,v 1.2 2003/09/06 22:37:58 msterret Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A perl XML down translate module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha"

DEPEND="${DEPEND}
	dev-perl/libwww-perl
	dev-perl/XML-LibXML
	dev-perl/Test-Simple
	>=dev-perl/XML-Parser-2.31"

src_compile() {
        echo "" | perl-module_src_compile
		}
