# Copyright 2000-2003 Gentoo Technologies, Inc., Okrain Genady, and Luke-Jr
# Distributed under the GPL v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittorrent-mxs/bittorrent-mxs-3.2.1b.ebuild,v 1.2 2003/08/21 13:41:46 luke-jr Exp $
inherit distutils

MY_P="${P/bittorrent-mxs/BitTorrent-experimental}-2"
S=${WORKDIR}/${MY_P}
DESCRIPTION="BitTorrent is a tool for distributing files via a distributed network of nodes"
SRC_URI="http://ei.kefro.st/projects/btclient/${MY_P}.tar.gz"
HOMEPAGE="http://ei.kefro.st/projects/btclient/"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

IUSE="X"

RDEPEND="X? ( >=dev-python/wxPython-2.2 )
	>=dev-lang/python-2.1
	!net-p2p/bittorrent
	!virtual/bittorrent"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0.5"

PROVIDE="virtual/bittorrent"

mydoc="FAQ.txt README.txt LICENSE.txt"


src_unpack() {
	unpack ${A}
	cd ${S}
}

src_install() {
	distutils_src_install
	if ! use X; then
		rm ${D}/usr/bin/*gui.py
	fi
	dodir etc
	cp -a /etc/mailcap ${D}/etc/

	MAILCAP_STRING="application/x-bittorrent; /usr/bin/btdownloadgui.py '%s'; test=test -n \"\$DISPLAY\""

	if use X; then
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
}

