# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/kisdndial/kisdndial-0.1.6.ebuild,v 1.2 2006/09/23 09:07:18 mrness Exp $

inherit kde flag-o-matic

DESCRIPTION="KDE Kicker Applet to establish ISDN dial-up connections and to show the status"
HOMEPAGE="http://www.kisdndial.de/"
SRC_URI="http://www.kisdndial.de/dl_engine/files/${PN}3.2-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE="unicode"
DEPEND="net-dialup/isdn4k-utils"

need-kde 3

src_unpack() {
	kde_src_unpack

	# if specified, convert all relevant files from latin1 to UTF-8
	if use unicode; then
		for i in AUTHORS README NEWS TODO ChangeLog; do
			iconv -f latin1 -t utf8 -o "${i}~" "${i}" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		done
	fi
}

src_compile() {
	#The only way to avoid QA text relocation warning
	#is by appending -fPIC to CFLAGS
	append-flags -fPIC
	kde_src_compile
}

src_install() {
	kde_src_install make
	dodoc AUTHORS README NEWS TODO ChangeLog
}
