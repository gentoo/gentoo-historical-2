# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Kakasi/Text-Kakasi-2.04.ebuild,v 1.11 2005/04/12 02:24:58 gustavoz Exp $

inherit perl-module eutils

DESCRIPTION="This module provides libkakasi interface for Perl."
HOMEPAGE="http://search.cpan.org/dist/Text-Kakasi/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DA/DANKOGAI/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ppc64 ~sparc"
IUSE=""

DEPEND=">=app-i18n/kakasi-2.3.4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/Text-Kakasi-1.05-gentoo.diff
}
