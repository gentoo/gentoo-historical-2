# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/shared-mime-info/shared-mime-info-0.7.ebuild,v 1.1 2002/07/13 13:43:11 stroke Exp $

DESCRIPTION="The Shared MIME-info Database specification."
HOMEPAGE="http://www.freedesktop.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND=">=sys-apps/gawk-3.1.0"
RDEPEND="${DEPEND}"

SRC_URI="http://www.freedesktop.org/standards/shared-mime-info/${P}.tar.gz"

S=${WORKDIR}/${P}

src_compile() {
	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
}

src_install () {
	make DESTDIR=${D} install || die
}
