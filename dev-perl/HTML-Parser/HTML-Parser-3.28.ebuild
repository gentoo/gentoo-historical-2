# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Parser/HTML-Parser-3.28.ebuild,v 1.11 2004/06/25 00:36:33 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Parse <HEAD> section of HTML documents"
SRC_URI="http://cpan.valueclick.com/modules/by-category/15_World_Wide_Web_HTML_HTTP_CGI/HTML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/15_World_Wide_Web_HTML_HTTP_CGI/HTML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc ~sparc alpha hppa ~mips ia64"

DEPEND="${DEPEND}
	>=dev-perl/HTML-Tagset-3.03"

mydoc="ANNOUNCEMENT TODO"

src_compile() {
	echo n |perl Makefile.PL ${myconf} \
	PREFIX=${D}/usr
	make || test
}
