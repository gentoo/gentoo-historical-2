# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/disc-cover/disc-cover-1.3.1.ebuild,v 1.13 2004/02/22 18:02:05 agriffis Exp $

DESCRIPTION="Creates CD-Covers via Latex by fetching cd-info from freedb.org or local file"
HOMEPAGE="http://www.liacs.nl/~jvhemert/disc-cover/"
SRC_URI="http://www.liacs.nl/~jvhemert/disc-cover/download/unstable/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"
SLOT="0"

DEPEND=">=dev-perl/Audio-CD-disc-cover-0.04
	>=app-text/tetex-1.0.7-r7"

src_compile() {
	pod2man disc-cover > disc-cover.1 || die
}

src_install() {
	dobin disc-cover
	doman disc-cover.1

	dodoc AUTHORS CHANGELOG COPYING TODO
	docinto freedb
	dodoc freedb/*
	docinto docs
	docinto docs/english
	dodoc docs/english/*
	docinto docs/dutch
	dodoc docs/dutch/*
	docinto docs/german
	dodoc docs/german/*
	docinto docs/spanish
	dodoc docs/spanish/*
}
