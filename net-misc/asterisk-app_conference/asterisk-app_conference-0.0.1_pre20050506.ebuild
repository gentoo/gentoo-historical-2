# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk-app_conference/asterisk-app_conference-0.0.1_pre20050506.ebuild,v 1.1 2005/05/07 13:26:05 stkn Exp $

inherit eutils

MY_PN="app_conference"
MY_P="${MY_PN}-${PV/0.0.1_pre/}"

DESCRIPTION="Asterisk application plugin for conferences"
HOMEPAGE="http://iaxclient.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

# depends on glibc's iconv support
DEPEND="sys-libs/glibc
	>=net-misc/asterisk-1.0.5-r1"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unpack ${A}

	cd ${S}
	# use asterisk-config...
	epatch ${FILESDIR}/${MY_P}-astcfg.diff

	# compile fixes for asterisk-stable
	epatch ${FILESDIR}/${MY_P}-compile.patch
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README LICENSE
}
