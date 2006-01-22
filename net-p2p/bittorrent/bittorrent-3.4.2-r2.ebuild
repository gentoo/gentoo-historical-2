# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittorrent/bittorrent-3.4.2-r2.ebuild,v 1.11 2006/01/22 10:20:07 mkay Exp $

inherit distutils

MY_P="${P/bittorrent/BitTorrent}"
MY_P="${MY_P/\.0/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="tool for distributing files via a distributed network of nodes"
HOMEPAGE="http://bitconjurer.org/BitTorrent"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc sparc x86"
IUSE="gtk"

RDEPEND="gtk? ( <dev-python/wxpython-2.5 )
	>=dev-lang/python-2.1
	!virtual/bittorrent"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-apps/sed-4.0.5"
PROVIDE="virtual/bittorrent"

DOCS="credits.txt"
PYTHON_MODNAME="BitTorrent"

src_install() {
	distutils_src_install
	if ! use gtk; then
		rm ${D}/usr/bin/*gui.py
	fi
	dohtml redirdonate.html
	dodir etc
	cp -pPR /etc/mailcap ${D}/etc/

	MAILCAP_STRING="application/x-bittorrent; /usr/bin/btdownloadgui.py '%s'; test=test -n \"\$DISPLAY\""

	if use gtk; then
		if [ -n "`grep 'application/x-bittorrent' ${D}/etc/mailcap`" ]; then
			# replace bittorrent entry if it already exists
			einfo "updating bittorrent mime info"
			sed -i "s,application/x-bittorrent;.*,${MAILCAP_STRING}," ${D}/etc/mailcap
		else
			# add bittorrent entry if it doesn't exist
			einfo "adding bittorrent mime info"
			echo "${MAILCAP_STRING}" >> ${D}/etc/mailcap
		fi
	else
		# get rid of any reference to the not-installed gui version
		sed -i '/btdownloadgui/d' ${D}/etc/mailcap
	fi

	insinto /usr/share/bittorrent
	doins ${FILESDIR}/favicon.ico

	insinto /etc/conf.d
	newins ${FILESDIR}/bttrack.conf bttrack

	exeinto /etc/init.d
	newexe ${FILESDIR}/bttrack.rc bttrack
}

pkg_postinst() {
	einfo "unofficial feature additions. If you would like statistics, please"
	einfo "install net-p2p/bittorrent-stats."
	distutils_pkg_postinst
}
