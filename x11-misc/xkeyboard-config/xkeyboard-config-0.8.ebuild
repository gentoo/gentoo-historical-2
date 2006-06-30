# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkeyboard-config/xkeyboard-config-0.8.ebuild,v 1.5 2006/06/30 23:50:52 spyderous Exp $

inherit eutils multilib

DESCRIPTION="X keyboard configuration database"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 mips ppc ~s390 sh sparc x86 ~x86-fbsd"
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
	echo "CONFIG_PROTECT=\"/usr/share/X11/xkb\"" > ${T}/10xkeyboard-config
	doenvd ${T}/10xkeyboard-config
}
