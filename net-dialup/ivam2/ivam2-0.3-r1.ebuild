# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/ivam2/ivam2-0.3-r1.ebuild,v 1.2 2005/07/04 07:43:44 dholm Exp $

inherit eutils

DESCRIPTION="Automatic phone answering machine software for ISDN"
SRC_URI="http://0pointer.de/lennart/projects/ivam2/${P}.tar.gz"
HOMEPAGE="http://0pointer.de/lennart/projects/ivam2/"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

DEPEND="virtual/libc
	dev-libs/liboop
	>=dev-libs/libdaemon-0.4
	>=dev-lang/python-2.3
	net-dialup/isdn4k-utils"
RDEPEND="${DEPEND}
	media-sound/sox
	media-sound/vorbis-tools
	|| ( net-mail/metamail dev-libs/openssl )" #needed for base64 encoding

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-base64-enc.patch
}

src_compile() {
	local myconf="--disable-lynx --disable-xmltoman --disable-gengetopt"
	econf $myconf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	keepdir /var/spool/ivam2
	make install DESTDIR=${D} || die "make install failed"
	dodoc doc/{README,README.VoiceBox,TODO}
	dohtml doc/*.{html,css}
	exeinto /etc/init.d
	newexe ${FILESDIR}/ivam2.init ivam2
}

pkg_preinst() {
	enewgroup ivam || die "Problem adding ivam group"
	enewuser ivam -1 /bin/false /dev/null ivam || die "Problem adding ivam user"
}

pkg_postinst() {
	chown ivam:ivam /var/spool/ivam2
}
