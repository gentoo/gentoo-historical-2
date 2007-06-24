# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkeyboard-config/xkeyboard-config-0.8-r1.ebuild,v 1.7 2007/06/24 22:25:49 vapier Exp $

inherit eutils multilib

DESCRIPTION="X keyboard configuration database"
KEYWORDS="~alpha amd64 arm hppa ia64 m68k mips ~ppc ppc64 s390 sh ~sparc x86 ~x86-fbsd"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/XKeyboardConfig"
SRC_URI="http://xlibs.freedesktop.org/xkbdesc/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"

RDEPEND="x11-apps/xkbcomp
	!x11-misc/xkbdata"
DEPEND="${RDEPEND}
	dev-perl/XML-Parser"

pkg_setup() {
	# (#130590) The old XKB directory can screw stuff up
	local DIR="${ROOT}usr/$(get_libdir)/X11/xkb"
	if [[ -d ${DIR} ]] ; then
		eerror "Directory ${DIR} should be"
		eerror "manually deleted/renamed/relocated before installing!"
		die "Manually remove ${DIR}"
	fi

	# The old xkbdata 'pc' directory can screw stuff up, because portage won't
	# let us overwrite a directory with a file
	local PC="${ROOT}usr/share/X11/xkb/symbols/pc"
	if [[ -d ${PC} ]] ; then
		eerror "Directory ${PC} should be"
		eerror "manually deleted/renamed/relocated before installing!"
		die "Manually remove ${PC}"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# bug #145097
	epatch "${FILESDIR}/add_missing_lsgt.patch"
}

src_compile() {
	econf \
		--with-xkb-base=/usr/share/X11/xkb \
		--enable-compat-rules \
		--disable-xkbcomp-symlink \
		--with-xkb-rules-symlink=xorg \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	echo "CONFIG_PROTECT=\"/usr/share/X11/xkb\"" > "${T}"/10xkeyboard-config
	doenvd "${T}"/10xkeyboard-config
}
