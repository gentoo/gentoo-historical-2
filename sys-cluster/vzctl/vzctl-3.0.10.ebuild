# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/vzctl/vzctl-3.0.10.ebuild,v 1.2 2006/06/22 04:28:44 hollow Exp $

inherit eutils

DESCRIPTION="OpenVZ VPS control utility"
HOMEPAGE="http://openvz.org/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/logrotate
	sys-apps/ed
	net-firewall/iptables
	sys-fs/vzquota
	sys-apps/iproute2"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_install() {
	make DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)/vzctl" install || die "make install failed"

	# Install gentoo specific init script
	newinitd "${FILESDIR}"/vz.initd vz
}

pkg_postinst() {
	if has_version "<3.0.10"; then
		ewarn
		ewarn "The location of some vzctl files have changed. Most notably,"
		ewarn "VE configuration files and samples directory has changed from"
		ewarn "/etc/vz to /etc/vz/conf. In order to be able to work with"
		ewarn "your VEs, please do the following:"
		ewarn
		ewarn "bash# mv /etc/vz/[0-9]*.conf /etc/vz/conf/"
		ewarn
	fi
}
