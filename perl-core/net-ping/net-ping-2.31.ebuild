# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/net-ping/net-ping-2.31.ebuild,v 1.10 2009/12/16 21:54:32 abcd Exp $

inherit perl-module

MY_P=Net-Ping-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="check a remote host for reachability"
SRC_URI="mirror://cpan/authors/id/B/BB/BBB/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~bbb/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="dev-lang/perl"
