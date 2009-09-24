# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xterm/xterm-248.ebuild,v 1.3 2009/09/24 08:32:06 ssuominen Exp $

EAPI=2
inherit multilib

DESCRIPTION="Terminal Emulator for X Windows"
HOMEPAGE="http://dickey.his.com/xterm/"
SRC_URI="ftp://invisible-island.net/${PN}/${P}.tgz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="toolbar truetype unicode Xaw3d"

RDEPEND="x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libxkbfile
	x11-libs/libXft
	x11-libs/libXaw
	x11-apps/xmessage
	unicode? ( x11-apps/luit )
	Xaw3d? ( x11-libs/Xaw3d )
	sys-libs/libutempter"
DEPEND="${RDEPEND}
	x11-proto/xproto"

pkg_setup() {
	DEFAULTS_DIR=/usr/share/X11/app-defaults
}

src_configure() {
	econf \
		--libdir=/etc \
		--x-libraries=/usr/$(get_libdir) \
		--disable-full-tgetent \
		--with-app-defaults=${DEFAULTS_DIR} \
		--disable-setuid \
		--disable-setgid \
		--with-utempter \
		--with-x \
		$(use_with Xaw3d) \
		--disable-imake \
		--enable-256-color \
		--enable-broken-osc \
		--enable-broken-st \
		$(use_enable truetype freetype) \
		--enable-i18n \
		--enable-load-vt-fonts \
		--enable-logging \
		$(use_enable toolbar) \
		$(use_enable unicode mini-luit) \
		$(use_enable unicode luit) \
		--enable-wide-chars \
		--enable-dabbrev \
		--enable-warnings
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README{,.i18n} ctlseqs.txt
	dohtml xterm.log.html

	# Fix permissions -- it grabs them from live system, and they can
	# be suid or sgid like they were in pre-unix98 pty or pre-utempter days,
	# respectively (#69510).
	# (info from Thomas Dickey) - Donnie Berkholz <spyderous@gentoo.org>
	fperms 0755 /usr/bin/xterm

	# restore the navy blue
	sed -i -e "s:blue2$:blue:" "${D}"${DEFAULTS_DIR}/XTerm-color

	# Fix for bug #91453 at Thomas Dickey's suggestion:
	echo "*allowWindowOps: 	false" >> "${D}"/${DEFAULTS_DIR}/XTerm
	echo "*allowWindowOps: 	false" >> "${D}"/${DEFAULTS_DIR}/UXTerm
}

pkg_postinst() {
	elog "bracketed paste mode requires the allowWindowOps resource to be true"
	elog "which is false by default for security reasons (see bug #91453)."
	elog "To be able to use it add 'allowWindowOps: true' to your resources"
}
