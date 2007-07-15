# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portage-mod_jabber/portage-mod_jabber-0.0.2.ebuild,v 1.2 2007/07/15 05:25:48 mr_bones_ Exp $

DESCRIPTION="A notification module for the portage elog-system to notify via the XMPP (Jabber) protocoll"
HOMEPAGE="http://usrportage.de/"
SRC_URI="http://software.usrportage.de/portage-mod_jabber/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1_pre1
	>=dev-python/xmpppy-0.2"

src_install() {
	insinto /usr/lib/portage/pym/elog_modules
	doins mod_jabber.py

	dodoc README ChangeLog
}
