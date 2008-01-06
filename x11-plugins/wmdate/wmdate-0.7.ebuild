# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmdate/wmdate-0.7.ebuild,v 1.10 2008/01/06 21:01:19 drac Exp $

inherit eutils toolchain-funcs

DESCRIPTION="yet another date-display dock application"
HOMEPAGE="http://solfertje.student.utwente.nl/~dalroi/applications.php"
SRC_URI="http://solfertje.student.utwente.nl/~dalroi/${PN}/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libdockapp
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch
}

src_compile() {
	xmkmf || die "xmkmf failed."
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		|| die "emake failed."
}

src_install() {
	dobin ${PN}
	dodoc Changelog README
}
