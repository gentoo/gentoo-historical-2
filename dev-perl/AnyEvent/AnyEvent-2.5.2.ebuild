# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AnyEvent/AnyEvent-2.5.2.ebuild,v 1.4 2007/05/05 17:29:07 dertobi123 Exp $

inherit perl-module versionator

MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="provide framework for multiple event loops"
SRC_URI="mirror://cpan/authors/id/M/ML/MLEHMANN/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mlehmann/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/Event
	dev-lang/perl"
