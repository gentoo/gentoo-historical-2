# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/flexbackup/flexbackup-1.2.1-r6.ebuild,v 1.1 2007/07/24 07:10:12 genstef Exp $

inherit eutils versionator

DESCRIPTION="Flexible backup script using perl"
HOMEPAGE="http://flexbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="app-arch/mt-st"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-lzma.patch
	epatch "${FILESDIR}"/${P}-secure-tempfile.patch
	epatch "${FILESDIR}"/${P}-bash.patch
	epatch "${FILESDIR}"/${P}-mbuffer-switch.patch
	epatch "${FILESDIR}"/${P}-remote-bufftest.patch
	epatch "${FILESDIR}"/${P}-prune.patch
	epatch "${FILESDIR}"/${P}-spaces-in-filenames.patch

	sed -i \
		-e '/^\$type = /s:afio:tar:' \
		-e "/^\$buffer = /s:'buffer':'false':" \
		flexbackup.conf \
		|| die "Failed to set modified configuration defaults."

	MY_PV=$(replace_all_version_separators '_')
	sed -i \
		-e "/^[[:blank:]]*my \$ver = /s:${MY_PV}:&-${PR}:" \
		flexbackup \
		|| die "Failed to apply ebuild revision to internal version string."
}

src_install() {
	dodir /etc /usr/bin /usr/share/man/man{1,5}
	emake install \
		PREFIX="${D}"/usr \
		CONFFILE="${D}"/etc/flexbackup.conf \
		|| die "emake install failed"

	dodoc CHANGES CREDITS README TODO
	dohtml faq.html
}

pkg_postinst() {
	elog "Please edit your /etc/flexbackup.conf file to suit your"
	elog "needs.  If you are using devfs, the tape device should"
	elog "be set to /dev/tapes/tape0/mtn.  If you need to use any"
	elog "archiver other than tar, please emerge it separately."
}
