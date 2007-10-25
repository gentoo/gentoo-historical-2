# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/antiword/antiword-0.37.ebuild,v 1.9 2007/10/25 20:22:19 grobian Exp $

inherit eutils

IUSE="kde"
PATCHVER=0.1
DESCRIPTION="free MS Word reader"
HOMEPAGE="http://www.winfield.demon.nl"
SRC_URI="http://www.winfield.demon.nl/linux/${P}.tar.gz
	mirror://gentoo/${P}-gentoo-${PATCHVER}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 sparc x86"

PATCHDIR=${WORKDIR}/gentoo-antiword/patches

src_unpack() {
	unpack ${A} ; cd ${S}
	EPATCH_SUFFIX="diff" \
		epatch ${PATCHDIR}
}

src_compile() {
	emake OPT="${CFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} global_install || die

	use kde || rm -f ${D}/usr/bin/kantiword

	insinto /usr/share/${PN}/examples
	doins Docs/testdoc.doc Docs/antiword.php

	cd Docs
	doman antiword.1
	dodoc COPYING ChangeLog Exmh Emacs FAQ History Netscape \
	QandA ReadMe Mozilla Mutt
}
