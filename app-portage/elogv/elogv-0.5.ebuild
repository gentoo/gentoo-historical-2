# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/elogv/elogv-0.5.ebuild,v 1.1 2006/11/26 09:59:56 opfer Exp $

inherit eutils

DESCRIPTION="Curses based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://gechi-overlay.sourceforge.net/?page=elogv"
SRC_URI="mirror://sourceforge/gechi-overlay/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.4
	>=sys-apps/portage-2.1"

pkg_setup() {
	if ! built_with_use dev-lang/python ncurses; then
	   eerror
	   eerror "\t ${PN} requires ncurses support on python"
	   eerror "\t Please, compile python with use ncurses enabled then"
	   eerror "\t remerge this package"
	   eerror
	   die "dev-lang/python must have ncurses use turned on"
	fi
}

src_install() {
	 newbin ${PN}.py ${PN}
	 dodoc README AUTHORS ChangeLog
}

pkg_postinst() {
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "	     PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "	     PORTAGE_ELOG_CLASSES=\"warn error info log\""
	elog "More information on the elog system can be found"
	elog "in /etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "$PORT_LOGDIR/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
