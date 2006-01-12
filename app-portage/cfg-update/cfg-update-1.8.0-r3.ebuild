# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/cfg-update/cfg-update-1.8.0-r3.ebuild,v 1.1 2006/01/12 20:09:43 truedfx Exp $

DESCRIPTION="Easy to use GUI & CLI alternative for etc-update with safe automatic updating functionality"
HOMEPAGE="http://people.zeelandnet.nl/xentric/"
SRC_URI="http://people.zeelandnet.nl/xentric/${PF}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="kde gnome"
KEYWORDS="~amd64 ~x86"
RDEPEND="kde? ( >=x11-misc/sux-1.0
		|| ( >=dev-util/xxdiff-2.9
			>=kde-misc/kdiff3-0.9 ) )
	gnome? ( >=x11-misc/sux-1.0
		>=dev-util/meld-0.9 )"

S=${WORKDIR}/${PF}

pkg_postrm() {
	ewarn
	ewarn "If you want to permanently remove cfg-update from your system"
	ewarn "you should manually remove the alias for emerge from /root/.bashrc"
	ewarn "followed by running: unalias emerge"
	ewarn "and remove the index file /usr/lib/cfg-update/checksum-index"
	ewarn
	ewarn "If you are just updating to a newer version you should read the"
	ewarn "installation instructions on http://people.zeelandnet.nl/xentric"
	ewarn
}

src_install() {
	exeinto /usr/bin
	doexe cfg-update emerge_with_indexing_for_cfg-update emerge_with_indexing_for_cfg-update_phphelper cfg-update_phphelper emerge_with_indexing_for_cfg-update_bashhelper
	insinto /usr/lib/cfg-update
	doins .bashrc ChangeLog cfg-update
	doman *.8
	insinto /etc
	doins cfg-update.conf
}

pkg_postinst() {
	einfo
	einfo "Converting old backups to new filename format..."
	cfg-update --convert-old-backups &>/dev/null
	einfo "Trying to remove old emerge alias from /etc/profile..."
	cfg-update --remove-old-alias &>/dev/null
	ewarn "Please read the installation instructions on http://people.zeelandnet.nl/xentric"
	ewarn "You need to run cfg-update --on after installation!"
}
