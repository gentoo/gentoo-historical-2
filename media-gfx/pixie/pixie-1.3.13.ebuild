# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pixie/pixie-1.3.13.ebuild,v 1.4 2004/12/29 06:07:58 mr_bones_ Exp $

inherit eutils

IUSE="X"

MY_PN="Pixie"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="RenderMan like photorealistic renderer."
HOMEPAGE="http://pixie.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-src-${PV}.tgz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc sparc -amd64"

RDEPEND="media-libs/jpeg
	 sys-libs/zlib
	 media-libs/tiff
	 X? ( virtual/x11 )"

DEPEND="${RDEPEND}
	sys-devel/libtool
	>=sys-devel/automake-1.8"

src_unpack() {
	unpack ${A}

	cd ${S}
	# These have been sent upstream
	epatch ${FILESDIR}/${PN}-1.3.11-math.patch

	# Gentoo-specific stuff
	epatch ${FILESDIR}/${PN}-1.3.11-gentoo.patch

	export WANT_AUTOMAKE=1.8
	export WANT_AUTOCONF=2.5
	aclocal
	libtoolize --force --copy
	automake -a -f -c
	autoconf
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
