# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpri/libpri-1.2.4-r2.ebuild,v 1.1 2007/04/26 19:40:02 gustavoz Exp $

inherit eutils

IUSE="bri"

MY_P="${P/_/-}"

BRI_VERSION="0.3.0-PRE-1y-d"

DESCRIPTION="Primary Rate ISDN (PRI) library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://ftp.digium.com/pub/libpri/${MY_P}.tar.gz
	bri? ( http://www.junghanns.net/downloads/bristuff-${BRI_VERSION}.tar.gz )"
#	bri? ( http://www.netdomination.org/pub/asterisk/libpri-${PV}-bristuff-${BRI_VERSION}.diff.gz )"

S="${WORKDIR}/${MY_P}"

S_BRI="${WORKDIR}/bristuff-${BRI_VERSION}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-1.2.3-gentoo.diff

	if use bri; then
		einfo "Patching libpri w/ BRI stuff (${BRI_VERSION})"

		# fix a small clash in patches
		sed -i -e "s:CFLAGS=:CFLAGS+=:" \
			${S_BRI}/patches/libpri.patch
#			${WORKDIR}/libpri-${PV}-bristuff-${BRI_VERSION}.diff

		epatch ${S_BRI}/patches/libpri.patch
#		epatch ${WORKDIR}/libpri-${PV}-bristuff-${BRI_VERSION}.diff
	fi
}

src_compile() {
	emake || die
}

src_install() {
	make INSTALL_PREFIX=${D} install || die

	dodoc ChangeLog README TODO LICENSE
}
