# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jasspa-microemacs/jasspa-microemacs-20060909-r1.ebuild,v 1.6 2007/12/06 19:15:27 opfer Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Jasspa Microemacs"
HOMEPAGE="http://www.jasspa.com/"
SRC_URI="http://www.jasspa.com/release_${PV}/jasspa-mesrc-${PV}-2.tar.gz
	!nanoemacs? (
		http://www.jasspa.com/release_${PV}/jasspa-memacros-${PV}-2.tar.gz
		http://www.jasspa.com/release_${PV}/jasspa-mehtml-${PV}.tar.gz
		http://www.jasspa.com/release_${PV}/meicons-extra.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nanoemacs X xpm"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11
		xpm? ( x11-libs/libXpm ) )
	nanoemacs? ( !app-editors/ne )"

DEPEND="${RDEPEND}
	X? ( x11-libs/libXt
		x11-proto/xproto )"

S="${WORKDIR}/me${PV:2}/src"

src_unpack() {
	unpack jasspa-mesrc-${PV}-2.tar.gz
	if ! use nanoemacs; then
		mkdir "${WORKDIR}/jasspa"
		cd "${WORKDIR}/jasspa"
		# everything except jasspa-mesrc
		unpack ${A/jasspa-mesrc-${PV}-2.tar.gz/}
	fi
	cd "${S}"
	epatch "${FILESDIR}/20050505-ncurses.patch"

	# allow for some variables to be passed to make
	sed -i '/make/s/\$OPTIONS/& CC="$CC" COPTIMISE="$CFLAGS" STRIP=true/' \
		build || die "sed failed"
}

src_compile() {
	local loadpath="~/.jasspa:/usr/share/jasspa/site:/usr/share/jasspa"
	local me="" type=c
	use nanoemacs && me="-ne"
	use X && type=cw
	use xpm || export XPM_INCLUDE=.		# prevent Xpm autodetection

	CC="$(tc-getCC)" ./build ${me} -t ${type} -p "${loadpath}" \
		|| die "build failed"
}

src_install() {
	local me=me type=c
	use nanoemacs && me=ne
	use X && type=cw
	newbin ${me}${type} ${me} || die "newbin failed"

	if ! use nanoemacs; then
		keepdir /usr/share/jasspa/site
		insinto /usr/share
		doins -r "${WORKDIR}/jasspa"
		make_desktop_entry me "Jasspa MicroEmacs" /usr/share/jasspa/icons/32x32/me.png Application
	fi

	dodoc ../faq.txt ../readme.txt ../change.log || die "dodoc failed"
}
