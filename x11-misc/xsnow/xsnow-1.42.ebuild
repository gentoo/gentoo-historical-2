# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsnow/xsnow-1.42.ebuild,v 1.22 2010/06/06 15:10:45 ssuominen Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="snow, reindeer, and santa on the root window"
HOMEPAGE="http://dropmix.xs4all.nl/rick/Xsnow/"
SRC_URI="http://dropmix.xs4all.nl/rick/Xsnow/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-misc/imake
	x11-misc/gccmakedep
	x11-proto/xextproto
	x11-proto/xproto"

src_compile() {
	xmkmf || die
	make depend || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin xsnow || die
	rman -f HTML < xsnow._man > xsnow.1-html && \
		mv -f xsnow.1-html xsnow.1.html && \
		mv -f xsnow._man xsnow.1
	doman xsnow.1
	dodoc xsnow.1.html README
}
