# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dahdi-tools/dahdi-tools-2.5.0.ebuild,v 1.1 2011/09/02 09:38:44 chainsaw Exp $

EAPI=3

inherit base

DESCRIPTION="Userspace tools to configure the kernel modules from net-misc/dahdi"
HOMEPAGE="http://www.asterisk.org"
SRC_URI="http://downloads.digium.com/pub/telephony/dahdi-tools/releases/${P}.tar.gz
	mirror://gentoo/gentoo-dahdi-tools-patchset-0.2.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ppp"

DEPEND="dev-libs/newt
	ppp? ( net-dialup/ppp )
	net-misc/dahdi
	!net-misc/zaptel
	>=sys-kernel/linux-headers-2.6.35
	virtual/libusb:0"
RDEPEND="${DEPEND}"

EPATCH_SUFFIX="diff"
PATCHES=( "${WORKDIR}/dahdi-tools-patchset" )

src_compile() {
	default_src_compile
	emake tests || die "Failed compiling test utilities"
	if use ppp; then
		emake -C ppp || die "Failed compiling ppp plugin"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install binaries"
	if use ppp; then
		emake DESTDIR="${D}" -C ppp install || die "Failed to install ppp plugin"
	fi
	emake DESTDIR="${D}" config || die "Failed to install configuration files"

	dosbin patgen pattest patlooptest hdlcstress hdlctest hdlcgen
	dosbin hdlcverify timertest

	# install init scripts
	newinitd "${FILESDIR}"/dahdi.init2 dahdi
	newinitd "${FILESDIR}"/dahdi-autoconf.init2 dahdi-autoconf
	newconfd "${FILESDIR}"/dahdi-autoconf.conf2 dahdi-autoconf
}
