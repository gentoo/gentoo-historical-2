# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pixie/pixie-1.3.5-r1.ebuild,v 1.1 2004/05/02 01:38:00 eradicator Exp $

inherit eutils

IUSE=""

MY_PN="Pixie"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="RenderMan like photorealistic renderer."
HOMEPAGE="http://pixie.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-src-${PV}.tgz"
RESTRICT="nomirror"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc"

RDEPEND=""
DEPEND="sys-devel/automake"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-math.patch
	epatch ${FILESDIR}/${P}-Makefile.patch
	WANT_AUTOMAKE=1.4 automake
}

src_compile() {
	./configure --prefix=/opt/pixie || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog DEVNOTES NEWS README

	insinto /etc/env.d
	doins ${FILESDIR}/50pixie

	edos2unix ${D}/opt/pixie/shaders/*

	mv ${D}/opt/pixie/doc ${D}/usr/share/doc/${PF}/html
}
