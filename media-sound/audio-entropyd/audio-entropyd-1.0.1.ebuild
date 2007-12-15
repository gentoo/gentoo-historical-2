# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audio-entropyd/audio-entropyd-1.0.1.ebuild,v 1.1 2007/12/15 12:48:26 angelos Exp $

inherit toolchain-funcs

DESCRIPTION="Audio-entropyd generates entropy-data for the /dev/random device."
HOMEPAGE="http://www.vanheusden.com/aed/"
SRC_URI="http://www.vanheusden.com/aed/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-audio-entropyd )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s:^OPT_FLAGS=.*:OPT_FLAGS=${CFLAGS}:" Makefile
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dosbin audio-entropyd

	dodoc README README.2 TODO

	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
}
