# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/pbbuttonsd/pbbuttonsd-0.7.2.ebuild,v 1.1 2005/10/05 17:46:10 josejx Exp $

inherit eutils linux-info flag-o-matic

DESCRIPTION="program to map special Powerbook/iBook keys"
HOMEPAGE="http://pbbuttons.sf.net"
SRC_URI="mirror://sourceforge/pbbuttons/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="acpi debug"

DEPEND="virtual/libc
	>=sys-apps/baselayout-1.8.6.12-r1"
RDEPEND=""

src_compile() {
	# Fix crash bug on some systems
	replace-flags -O? -O1

	if ! linux_chkconfig_present INPUT_EVDEV ; then
		eerror "Please enable CONFIG_INPUT_EVDEV in your kernel"
		eerror "pbbuttonsd will not work without it."
		die "Kernel not compiled with CONFIG_INPUT_EVDEV support"
	fi

	if use x86; then
		if use acpi; then
			laptop=acpi
		else
			laptop=i386
		fi
	else
		laptop=powerbook
	fi

	econf laptop=$laptop \
		$(use_enable debug) || die "Sorry, failed to configure pbbuttonsd"
	emake || die "Sorry, failed to compile pbbuttonsd"
}

src_install() {
	dodir /etc/power
	make DESTDIR=${D} install || die "failed to install"
	exeinto /etc/init.d
	newexe ${FILESDIR}/pbbuttonsd.rc6 pbbuttonsd
	dodoc README
}

pkg_postinst() {
	if linux_chkconfig_module INPUT_EVDEV ; then
		ewarn "Ensure that the evdev kernel module is loaded otherwise"
		ewarn "pbbuttonsd won't work."
	fi

	if use ppc; then
	einfo
	einfo "This version of pbbuttonsd can replace PMUD functionality."
	einfo "If you want PMUD installed and running, you should set"
	einfo "replace_pmud=no in /etc/pbbuttonsd.conf. Otherwise you can"
	einfo "try setting replace_pmud=yes in /etc/pbbuttonsd.conf and"
	einfo "disabling PMUD"
	ewarn "Warning: the NoTapTyping option is unstable, see bug #86768."
	fi
}
