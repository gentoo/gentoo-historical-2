# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/dbskkd-cdb/dbskkd-cdb-1.01-r1.ebuild,v 1.8 2004/08/28 14:31:58 usata Exp $

inherit gcc

DESCRIPTION="Yet another Dictionary server for the SKK Japanese-input software"
HOMEPAGE="http://www.ne.jp/asahi/bdx/info/software/jp-dbskkd.html"
SRC_URI="http://www.ne.jp/asahi/bdx/info/software/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64"
IUSE=""

DEPEND="dev-db/freecdb"
RDEPEND="app-i18n/skk-jisyo-cdb
	virtual/inetd"
PROVIDE="virtual/skkserv"

src_compile() {
	emake \
		SERVERDIR=/usr/sbin \
		COMPAT="-DJISHO_FILE=\\\"/usr/share/skk/SKK-JISYO.L.cdb\\\"" \
		LDFLAGS="-lutil -lfreecdb" \
		CC="$(gcc-getCC) ${CFLAGS}" || die
}

src_install() {
	dosbin dbskkd-cdb

	einfo "Checking for xinetd..."
	if test -f /usr/sbin/xinetd; then
		einfo "copying xinetd configuration file for ${PN}"
		insinto /etc/xinetd.d
		newins ${FILESDIR}/dbskkd-cdb.xinetd dbskkd-cdb
	else
		einfo "No xinetd found. Config example for inetd is in /etc/inetd.skkserv"
		dodir /etc/
		echo > ${D}/etc/inetd.skkserv "skkserv stream tcp nowait nobody /usr/sbin/dbskkd-cdb /usr/sbin/dbskkd-cdb"
	fi
	dodoc LICENSE Release-Notes.{English,Japanese}
}

pkg_postinst() {
	ewarn "The skk server is disabled by default."
	if test -f ${ROOT}/usr/sbin/xinetd; then
		ewarn  "Please check /etc/xinetd.d/dbskkd-cdb"
	else
		ewarn "Please see /etc/inetd.skkserv for an example inetd configuration line"
	fi
}
