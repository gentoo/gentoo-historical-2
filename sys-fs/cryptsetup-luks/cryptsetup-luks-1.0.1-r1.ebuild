# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cryptsetup-luks/cryptsetup-luks-1.0.1-r1.ebuild,v 1.4 2005/12/02 23:16:42 vapier Exp $

inherit linux-info eutils flag-o-matic

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="http://clemens.endorphin.org/LUKS/"
SRC_URI="http://luks.endorphin.org/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~mips ppc ~ppc64 sparc x86"

DEPEND=">=sys-fs/device-mapper-1.00.07-r1
		>=dev-libs/libgcrypt-1.1.42
		>=dev-libs/libgpg-error-1.0-r1
		!sys-fs/cryptsetup"

IUSE="dynamic nls"

dm-crypt_check() {
	ebegin "Checking for dm-crypt support"
	linux_chkconfig_present DM_CRYPT
	eend $?

	if [[ $? -ne 0 ]] ; then
		ewarn "cryptsetup requires dm-crypt support!"
		ewarn "Please enable dm-crypt support in your kernel config, found at:"
		ewarn "(for 2.6 kernels)"
		ewarn
		ewarn "  Device Drivers"
		ewarn "    Multi-Device Support"
		ewarn "      Device mapper support"
		ewarn "        [*] Crypt Target Support"
		ewarn
		ewarn "and recompile your kernel if you want this package to work with this kernel"
		epause 5
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	dm-crypt_check;
}

src_compile() {
	cd ${S}

	if use dynamic ; then
		ewarn "If you need cryptsetup for an initrd or initramfs then you"
		ewarn "should NOT use this USE flag"
		epause 5
		econf --sbindir=/bin --disable-static $(use_enable nls) || die
	else
		append-ldflags -static
		econf --sbindir=/bin --enable-static $(use_enable nls) || die
	fi

	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	rmdir "${D}/usr/lib/cryptsetup"
	insinto /lib/rcscripts/addons
	newconfd ${FILESDIR}/cryptfs.confd cryptfs
	doins "${FILESDIR}"/dm-crypt-{start,stop}.sh
}

pkg_postinst() {
	einfo "Please see the example for configuring a LUKS mountpoint"
	einfo "in /etc/conf.d/cryptfs"
}
