# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/proxyper/proxyper-333.ebuild,v 1.6 2004/06/02 02:15:23 agriffis Exp $

DESCRIPTION="distributed.net personal proxy"
HOMEPAGE="http://www.distributed.net"
SRC_URI="x86? ( http://http.distributed.net/pub/dcti/${PN}/${PN}${PV}-linux-x86.tar.gz )
		alpha? ( http://http.distributed.net/pub/dcti/${PN}/${PN}${PV}-linux-alpha.tar.gz )"
LICENSE="distributed.net"
SLOT="0"
KEYWORDS="x86 -ppc -sparc ~alpha"
IUSE=""
DEPEND=""
RDEPEND="net-misc/host"
if use x86; then
	S="${WORKDIR}/${PN}${PV}-linux-x86"
elif use ppc; then
	S="${WORKDIR}/${PN}${PV}-linux-ppc"
elif use sparc; then
	S="${WORKDIR}/${PN}${PV}-linux-sparc"
elif use alpha; then
	S="${WORKDIR}/${PN}${PV}-linux-alpha"
fi

RESTRICT="nomirror"

src_install() {
	exeinto /opt/proxyper ; doexe proxyper
	insinto /opt/proxyper ; doins proxyper.ini

	dodoc ChangeLog.txt
	dohtml manual.html

	exeinto /etc/init.d ; newexe ${FILESDIR}/proxyper.init proxyper
}

pkg_postinst() {
	einfo "Don't forget to modify the config file"
	einfo "located in /opt/proxyper/proxyper.ini"
	einfo "It's recommend to reading the manual first :-)"
}

pkg_postrm() {
	if [ -d /opt/proxyper ]; then
		einfo "All files has not been removed from /opt/proxyper"
	fi
}
