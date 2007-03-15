# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pftpfxp/pftpfxp-0.11.4.6-r3.ebuild,v 1.2 2007/03/15 15:09:34 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="The powerful curses-based ftp/fxp client, mew edition"
HOMEPAGE="http://pftpmew.tanesha.net"
SRC_URI="http://tanesha.net/bigmess/pftpfxp-v0.11.4mew6.tgz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="ssl"
DEPEND="ssl? ( >=dev-libs/openssl-0.9.6c )"
S=${WORKDIR}/pftpfxp-mew

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gcc3.4.fix || die "patch failed"
	epatch "${FILESDIR}"/pftpfxp-v0.11.4mew6-pret.patch || die "patch failed"
	epatch "${FILESDIR}"/${PV}-correct_config_fix.patch || die "patch failed"
	epatch "${FILESDIR}"/${PV}-correct_bookmark_path.patch || die "patch failed"
	sed -i -e "s/^CPP=.*/CPP=$(tc-getCXX)/" \
		-e "s:^CPPF=.*:CPPF=\"-Wall -D_REENTRANT -I../include ${CFLAGS}\":" \
		configure
}

src_compile() {
	cd "${S}"
	#note: not a propper autoconf
	./configure || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dobin pftp
	dodoc .pftp/config .pftp/keymap README.MEW old/*
	cd "${WORKDIR}"
	mv irssi  mIRC-mew  pftpfxp-autoconnect "${D}"/usr/share/doc/${PF}
}

pkg_postinst() {
	einfo "In order to use pftp-mew you need to create these files:"
	einfo "    ~/.pftp/config"
	einfo "    ~/.pftp/keymap"
	einfo "Refer to the examples in /usr/share/doc/${PF} for more information."
}
