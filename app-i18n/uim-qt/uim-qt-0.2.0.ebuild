# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/uim-qt/uim-qt-0.2.0.ebuild,v 1.4 2005/05/29 05:26:38 usata Exp $

inherit eutils

DESCRIPTION="Qt immodules input method framework plugin for UIM"
HOMEPAGE="http://freedesktop.org/Software/UimQt"
SRC_URI="http://freedesktop.org/~kzk/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=app-i18n/uim-0.4.4
	>=x11-libs/qt-3.3.3-r1"

pkg_setup() {
	einfo
	einfo "UimQt is now part of uim distribution since uim-0.4.6. Please consider"
	einfo "switching to >=uim-0.4.6 (set immqt or immqt-bc in your USE)."
	einfo
}

src_compile() {
	addwrite /usr/qt/3/etc/settings

	econf || die "You need to rebuild >=x11-libs/qt-3.3.3-r1 with immqt-bc(recommended) or immqt USE flag enabled."
	emake -j1 || die "make failed."
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc COPYING ChangeLog README* TODO THANKS
}

src_test() {
	#cd edittest
	#qmake -project || die "qmake -project failed"
	#qmake || die "qmake failed"
	#emake || die "emake failed"
	#
	# This programme needs human interaction to test. (i.e. You need to
	# manually check whether quiminputcontextplugin is working or not
	# with GUI interface)
	#./edittest
	return
}

pkg_postinst() {
	einfo
	einfo "After you emerged ${PN}, use right click to switch immodules for Qt."
	einfo "If you would like to use ${PN} as default instead of XIM, set QT_IM_MODULE to uim-*."
	einfo "e.g.)"
	einfo "	% export QT_IM_MODULE=uim-anthy"
	einfo
	ewarn
	ewarn "qtconfig is no longer used for selecting input methods."
	ewarn
}
