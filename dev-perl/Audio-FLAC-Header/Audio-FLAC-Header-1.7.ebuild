# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-FLAC-Header/Audio-FLAC-Header-1.7.ebuild,v 1.2 2007/04/08 21:33:30 mcummings Exp $

inherit perl-module

DESCRIPTION="Access to FLAC audio metadata"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/D/DA/DANIEL/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64"

DEPEND="media-libs/flac
	dev-lang/perl"

SRC_TEST="do"
