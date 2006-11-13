# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/keytouch-editor/keytouch-editor-3.1.0.ebuild,v 1.1 2006/11/13 10:54:47 nyhm Exp $

inherit eutils linux-info

DOC_V=3.0
DESCRIPTION="Generates keyboard files for use by keyTouch"
HOMEPAGE="http://keytouch.sourceforge.net/"
SRC_URI="mirror://sourceforge/keytouch/${P}.tar.gz
	doc? ( mirror://sourceforge/keytouch/keytouch_editor_${DOC_V}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc kde"

RDEPEND=">=x11-libs/gtk+-2
	kde? ( || (
		kde-base/kdesu
		kde-base/kdebase ) )
	!kde? ( x11-libs/gksu )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	make_desktop_entry ${PN} "keyTouch editor" ${PN}.png System
	newicon pixmaps/icon.png ${PN}.png

	dodoc AUTHORS ChangeLog
	use doc && dodoc "${DISTDIR}"/*.pdf
}

pkg_postinst() {
	if ! linux_chkconfig_present INPUT_EVDEV ; then
		ewarn "To use ${PN}, CONFIG_INPUT_EVDEV must"
		ewarn "be enabled in your kernel config."
		ewarn
		ewarn "  Device Drivers"
		ewarn "    Input device support"
		ewarn "      <*>/<M> Event interface"
	fi
}
