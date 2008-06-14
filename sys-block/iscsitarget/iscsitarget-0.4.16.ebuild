# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/iscsitarget/iscsitarget-0.4.16.ebuild,v 1.1 2008/06/14 08:18:53 flameeyes Exp $

inherit linux-mod eutils flag-o-matic

DESCRIPTION="Open Source iSCSI target with professional features"
HOMEPAGE="http://iscsitarget.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-libs/openssl"

MODULE_NAMES="iscsi_trgt(kernel/iscsi:${S}/kernel)"
CONFIG_CHECK="CRYPTO_CRC32C"
ERROR_CFG="iscsitarget needs support for CRC32C in your kernel."

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.4.15-isns-set-scn-flag.patch #180619
	epatch "${FILESDIR}"/${PN}-0.4.15-build.patch
	epatch "${FILESDIR}"/${P}+glibc-2.8-lists.patch
	convert_to_m "${S}"/Makefile
}

src_compile() {
	local save_CFLAGS="${CFLAGS}"
	append-flags -D_GNU_SOURCE
	emake usr || die "failed to build userspace"
	CFLAGS="${save_CFLAGS}"

	unset ARCH
	emake KSRC="${KERNEL_DIR}" kernel || die "failed to build module"
}

src_install() {
	einfo "Installing userspace"
	dosbin usr/ietd usr/ietadm || die "dosbin failed"
	insinto /etc
	doins etc/ietd.conf etc/initiators.{allow,deny} || die "doins failed"
	# Upstream's provided Gentoo init script is out of date compared to
	# their Debian init script. And isn't that nice.
	#newinitd etc/initd/initd.gentoo ietd || die
	newinitd "${FILESDIR}"/ietd-init.d ietd || die "newinitd failed"
	newconfd "${FILESDIR}"/ietd-conf.d ietd || die "newconfd failed"

	# Lock down perms, per bug 198209
	fperms 0640 /etc/ietd.conf /etc/initiators.{allow,deny}

	doman doc/manpages/*.[1-9] || die "manpages failed"
	dodoc ChangeLog README || die "docs failed"

	einfo "Installing kernel module"
	unset ARCH
	linux-mod_src_install || die "modules failed"
}
