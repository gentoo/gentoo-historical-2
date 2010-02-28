# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/miniupnpd/miniupnpd-1.5_pre20091222.ebuild,v 1.1 2010/02/28 19:36:07 gurligebis Exp $

EAPI=2
inherit eutils linux-info toolchain-funcs

MY_PV=1.4.20091222
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="MiniUPnP IGD Daemon"
SRC_URI="http://miniupnp.free.fr/files/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=net-firewall/iptables-1.4.3
	sys-apps/lsb-release
	>=sys-kernel/linux-headers-2.6.31"
DEPEND="${RDEPEND}"

src_prepare() {
	mv Makefile.linux Makefile
	epatch "${FILESDIR}/${PN}-1.3-iptables_path.diff"
	epatch "${FILESDIR}/${PN}-1.3-Makefile_fix.diff"
	epatch "${FILESDIR}/${PN}-1.5-iptcrdr.diff"
	sed -i -e "s#^CFLAGS = #CFLAGS = -I${KV_OUT_DIR}/include #" Makefile
	sed -i "s/LIBS = -liptc/LIBS = -lip4tc/g" Makefile
	emake config.h
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install () {
	einstall PREFIX="${D}" STRIP="true" || die "einstall failed"

	newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	newconfd "${FILESDIR}"/${PN}-conf.d ${PN}
}

pkg_postinst() {
	elog "Please correct the external interface in the top of the two"
	elog "scripts in /etc/miniupnpd and edit the config file in there too"
}
