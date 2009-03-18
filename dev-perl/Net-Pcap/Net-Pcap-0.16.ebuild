# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Pcap/Net-Pcap-0.16.ebuild,v 1.2 2009/03/18 18:22:53 ranger Exp $

inherit perl-module eutils

DESCRIPTION="Perl Net::Pcap - Perl binding to the LBL pcap"
SRC_URI="mirror://cpan/authors/id/S/SA/SAPER/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/${P}"
IUSE=""
DEPEND="net-libs/libpcap
	dev-perl/IO-Interface
	dev-lang/perl"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~sparc ~x86"
