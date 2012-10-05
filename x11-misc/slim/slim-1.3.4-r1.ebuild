# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/slim/slim-1.3.4-r1.ebuild,v 1.2 2012/10/05 19:22:14 axs Exp $

EAPI=4

CMAKE_MIN_VERSION="2.8.8"
inherit cmake-utils pam eutils

DESCRIPTION="Simple Login Manager"
HOMEPAGE="http://slim.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="branding pam consolekit"
REQUIRED_USE="consolekit? ( pam )"

RDEPEND="x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXft
	media-libs/libpng
	virtual/jpeg
	x11-apps/sessreg
	consolekit? ( sys-auth/consolekit
		sys-apps/dbus )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"
PDEPEND="branding? ( >=x11-themes/slim-themes-1.2.3a-r3 )"

src_prepare() {
	# Our Gentoo-specific config changes
	epatch "${FILESDIR}"/${P}-config.diff
	epatch "${FILESDIR}"/${P}-libpng.patch
	epatch "${FILESDIR}"/${P}-pam-end.patch
	epatch "${FILESDIR}"/${P}-arm.patch

	if use elibc_FreeBSD; then
		sed -i -e 's/"-DHAVE_SHADOW"/"-DNEEDS_BASENAME"/' CMakeLists.txt \
			|| die
	fi

	if use branding; then
		sed -i -e 's/  default/  slim-gentoo-simple/' slim.conf || die
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use pam USE_PAM)
		$(cmake-utils_use consolekit USE_CONSOLEKIT)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use pam ; then
		pamd_mimic system-local-login slim auth account session
	fi

	insinto /usr/share/slim
	newins "${FILESDIR}/Xsession-r3" Xsession

	insinto /etc/logrotate.d
	newins "${FILESDIR}/slim.logrotate" slim

	dodoc xinitrc.sample ChangeLog README TODO THEMES
}

pkg_postinst() {
	elog
	elog "The configuration file is located at /etc/slim.conf."
	elog
	elog "If you wish ${PN} to start automatically, set DISPLAYMANAGER=\"${PN}\" "
	elog "in /etc/conf.d/xdm and run \"rc-update add xdm default\"."
	elog
	elog "By default, ${PN} now does proper X session selection, including ~/.xsession"
	elog "support, as well as selection between sessions available in"
	elog "/etc/X11/Sessions/ at login by pressing [F1]."
	elog
	elog "The XSESSION environment variable is still supported as a default"
	elog "if no session has been specified by the user."
	elog
	elog "If you want to use .xinitrc in the user's home directory for session"
	elog "management instead, see README and xinitrc.sample in"
	elog "/usr/share/doc/${PF} and change your login_cmd in /etc/slim.conf"
	elog "accordingly."
	elog
	ewarn "Please note that slim now supports consolekit directly.  Please remove any "
	ewarn "existing work-arounds (including all calls to 'ck-launch-session' in "
	ewarn "xinitrc scripts) and enable USE=\"consolekit\""
	elog
	if ! use pam; then
		elog "You have merged ${PN} without USE=pam, this will cause ${PN} to fall back to"
		elog "the console when restarting your window manager. If this is not"
		elog "desired, then please remerge ${PN} with USE=pam"
		elog
	fi
}
