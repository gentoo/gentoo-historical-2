# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libapreq/libapreq-1.0-r2.ebuild,v 1.4 2002/12/17 06:13:09 lostlogic Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Apache Request Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-category/15_World_Wide_Web_HTML_HTTP_CGI/Apache/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/15_World_Wide_Web_HTML_HTTP_CGI/Apache/${P}.readme"

SLOT="0"
LICENSE="Apache-1.1 as-is"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	<dev-perl/mod_perl-1.99"

mydoc="TODO"
