# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SNMP/Net-SNMP-3.60-r1.ebuild,v 1.3 2002/07/11 06:30:22 drobbins Exp $


inherit perl-module

MY_P=${P/0/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A SNMP Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/Net/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Net/${P}.readme"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"

SLOT="3"
