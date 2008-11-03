# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/otpcalc/otpcalc-0.97-r4.ebuild,v 1.4 2008/11/03 11:21:50 armin76 Exp $

inherit eutils

DESCRIPTION="A One Time Password and S/Key calculator for X"
HOMEPAGE="http://killa.net/infosec/otpCalc/"
SRC_URI="http://killa.net/infosec/otpCalc/otpCalc-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/otpCalc-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-man-table-format.diff"
	epatch "${FILESDIR}/${P}-badindex.diff"
	epatch "${FILESDIR}/${PN}-crypto-proto.diff"

	# make it work with GTK+ 2
	epatch "${FILESDIR}/${P}-gtk2-gentoo.patch"

	# change default s/key hash to MD5 (same as sys-auth/skey)
	epatch "${FILESDIR}/${P}-skey-md5.patch"

	# fix SHA1 byte-order issue for conformance with RFC 2289
	epatch "${FILESDIR}/${P}-sha1-byteorder.patch"

	# print correct version in manpage
	sed -i -e "s/VERSION/${PV}/g" otpCalc.man

	# override hardcoded CFLAGS
	sed -i -e "s#-s -O3#${CFLAGS}#g" Makefile.in
}

src_install() {
	dobin otpCalc || die
	newman otpCalc.man otpCalc.1 || die
	dodoc BUGS ChangeLog TODO || die

	cat <<-EOF >"${T}"/${PN}.desktop
	[Desktop Entry]
	Type=Application
	Version=1.0
	Name=otpCalc
	Comment=One Time Password and S/Key calculator
	Exec=otpCalc
	Categories=Utility;GTK;Security;
	EOF
	domenu "${T}"/${PN}.desktop || die
}
