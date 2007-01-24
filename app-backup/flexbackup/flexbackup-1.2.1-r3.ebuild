# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/flexbackup/flexbackup-1.2.1-r3.ebuild,v 1.2 2007/01/24 04:17:10 genone Exp $

inherit eutils

DESCRIPTION="Flexible backup script using perl"
HOMEPAGE="http://flexbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	sys-apps/findutils
	app-arch/tar
	app-arch/mt-st"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/flexbackup-1.2.1-lzma.patch
	#Substituting out this patch for bug #116510
#	epatch "${FILESDIR}"/${P}-CAN-2005-2965.patch
	epatch "${FILESDIR}"/flexbackup-1.2.1-secure-tempfile.patch
	epatch ${FILESDIR}/flexbackup-1.2.1-bash.patch

	sed -i \
		-e '/^\$type = /s:afio:tar:' \
		-e "/^\$buffer = /s:'buffer':'false':" \
		flexbackup.conf || die
}

src_install() {
	dodir /etc /usr/bin /usr/share/man/man{1,5}
	make install \
		PREFIX="${D}"/usr \
		CONFFILE="${D}"/etc/flexbackup.conf \
		|| die

	dodoc CHANGES CREDITS INSTALL README TODO
	dohtml faq.html
}

pkg_postinst() {
	elog "Please edit your /etc/flexbackup.conf file to suit your"
	elog "needs.  If you are using devfs, the tape device should"
	elog "be set to /dev/tapes/tape0/mtn.  If you need to use any"
	elog "archiver other than tar, please emerge it separately."
}
