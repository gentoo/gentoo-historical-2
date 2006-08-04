# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/net-ping/net-ping-2.31.ebuild,v 1.7 2006/08/04 13:39:38 mcummings Exp $

inherit perl-module

MY_P=Net-Ping-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="check a remote host for reachability"
SRC_URI="mirror://cpan/authors/id/B/BB/BBB/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/BBB/${MY_P}/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
