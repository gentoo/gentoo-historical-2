# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cpio/cpio-2.9-r1.ebuild,v 1.6 2007/10/30 19:34:35 dertobi123 Exp $

inherit eutils

DESCRIPTION="A file archival tool which can also read and write tar files"
HOMEPAGE="http://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="nls"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-CVE-2007-4476.patch #196978
}

src_compile() {
	econf \
		$(use_enable nls) \
		--bindir=/bin \
		--with-rmt=/usr/sbin/rmt \
		|| die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog NEWS README
	rm -f "${D}"/usr/share/man/man1/mt.1
	rmdir "${D}"/usr/libexec || die
}
