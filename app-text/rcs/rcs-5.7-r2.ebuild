# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rcs/rcs-5.7-r2.ebuild,v 1.22 2009/09/23 16:38:12 patrick Exp $

inherit eutils

DESCRIPTION="Revision Control System"
HOMEPAGE="http://www.gnu.org/software/rcs/"
SRC_URI="mirror://gnu/rcs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa ia64 amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/diffutils"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/conf.diff
}

src_compile() {
	# econf BREAKS this!
	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		--with-diffutils || die

	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		man1dir=${D}/usr/share/man/man1 \
		man3dir=${D}/usr/share/man/man3 \
		man5dir=${D}/usr/share/man/man5 \
		install || die

	dodoc ChangeLog CREDITS NEWS README REFS
}
