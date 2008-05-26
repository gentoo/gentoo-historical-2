# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/elogviewer/elogviewer-0.5.2-r2.ebuild,v 1.2 2008/05/26 16:13:11 opfer Exp $

inherit eutils

DESCRIPTION="GTK+ based utility to parse the contents of elogs created by Portage"
HOMEPAGE="http://sourceforge.net/projects/elogviewer/"

SRC_URI="mirror://sourceforge/elogviewer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1
	>=dev-python/pygtk-2.0"

src_unpack() {
	unpack ${A}
	# Allow proper sorting by year, bug #207220
	epatch "${FILESDIR}/${P}-timesort.patch"
	# Add a warning if all files are about to be cleared, bug #218978
	epatch "${FILESDIR}/${P}-clear_warning.patch"
}

src_install() {
	dobin "${WORKDIR}"/elogviewer || die "dobin failed"
	dodoc "${WORKDIR}"/CHANGELOG
	doman "${WORKDIR}"/elogviewer.1
	make_desktop_entry elogviewer Elogviewer "" "System" ||
		die "Couldn't make desktop entry"
}

pkg_postinst() {
	elog
	elog "In order to use this software, you need to activate"
	elog "Portage's elog features.  Required is"
	elog "		 PORTAGE_ELOG_SYSTEM=\"save\" "
	elog "and at least one out of "
	elog "		 PORTAGE_ELOG_CLASSES=\"warn error info log qa\""
	elog "More information on the elog system can be found"
	elog "in /etc/make.conf.example"
	elog
	elog "To operate properly this software needs the directory"
	elog "${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage."
	elog "To start the software as a user, add yourself to the portage"
	elog "group."
	elog
}
