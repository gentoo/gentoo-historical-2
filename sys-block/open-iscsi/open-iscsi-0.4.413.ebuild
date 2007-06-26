# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/open-iscsi/open-iscsi-0.4.413.ebuild,v 1.3 2007/06/26 02:48:53 mr_bones_ Exp $

inherit versionator linux-mod eutils

DESCRIPTION="Open-iSCSI project is a high performance, transport independent, multi-platform implementation of RFC3720."
HOMEPAGE="http://www.open-iscsi.org/"
MY_PV="$(replace_version_separator 2 '-')"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="virtual/libc
		virtual/linux-sources"
RDEPEND="${DEPEND}
		virtual/modutils
		sys-apps/util-linux"
S="${WORKDIR}/${MY_P}"

MODULE_NAMES_ARG="kernel/drivers/scsi:${S}/kernel"
MODULE_NAMES="iscsi_tcp(${MODULE_NAMES_ARG}) scsi_transport_iscsi(${MODULE_NAMES_ARG})"
BUILD_TARGETS="all"
CONFIG_CHECK="CRYPTO_MD5 CRYPTO_CRC32C"
ERROR_CFG="open-iscsi needs both MD5 and CRC32C support in your kernel."

src_unpack() {
	unpack ${A}
	convert_to_m ${S}/kernel/Makefile
	export EPATCH_OPTS="-d${S}/kernel -p0"
	if [ $KV_PATCH -lt 11 ]; then
		die "Sorry, your kernel must be 2.6.11 or newer!"
	elif [ $KV_PATCH -eq 11 ]; then
		epatch ${S}/kernel/backward-compile-2.6.11.patch
	elif [ $KV_PATCH -eq 12 ]; then
		epatch ${S}/kernel/backward-compile-2.6.12.patch
	fi
	sed -i.orig  \
		-e '/^CFLAGS/s,-O2,,g' \
		-e '/^CFLAGS/s,-g,,g' \
		${S}/usr/Makefile || die "Failed to clean up CFLAGS"
}

src_compile() {
	einfo "Building kernel modules"
	export KSRC="${KERNEL_DIR}"
	#S=${S}/kernel
	linux-mod_src_compile || die "failed to build modules"
	einfo "Building userspace"
	cd ${S}/usr && emake || die "emake failed"
}

src_install() {
	einfo "Installing kernel modules"
	export KSRC="${KERNEL_DIR}"
	#S=${S}/kernel
	linux-mod_src_install

	einfo "Installing userspace"
	dosbin usr/iscsid usr/iscsiadm

	doman doc/*[1-8]
	dodoc README THANKS TODO
	docinto test
	dodoc test/*

	insinto /etc
	doins etc/iscsid.conf
	doins ${FILESDIR}/initiatorname.iscsi
	newinitd ${FILESDIR}/iscsid-init.d iscsid

	# security
	keepdir /var/db/iscsi
	fperms 700 /var/db/iscsi
	fperms 600 /etc/iscsid.conf
}

pkg_postinst() {
	linux-mod_pkg_postinst
	[ -d /var/db/iscsi ] && chmod 700 /var/db/iscsi
	[ -f /etc/iscsid.conf ] && chmod 600 /etc/iscsid.conf
}
