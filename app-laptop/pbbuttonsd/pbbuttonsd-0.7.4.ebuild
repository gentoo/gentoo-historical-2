# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/pbbuttonsd/pbbuttonsd-0.7.4.ebuild,v 1.9 2007/06/20 20:52:58 corsair Exp $

inherit eutils flag-o-matic

DESCRIPTION="Handles power management and special keys on laptops."
HOMEPAGE="http://pbbuttons.sf.net"
SRC_URI="mirror://sourceforge/pbbuttons/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ~x86"
IUSE="acpi debug alsa oss ibam"

DEPEND=">=sys-apps/baselayout-1.8.6.12-r1
		>=dev-libs/glib-2.6"
RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0 )
		 >=dev-libs/glib-2.6"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-laptopmode-noatime.patch
}

src_compile() {
	# Fix crash bug on some systems
	replace-flags -O? -O1

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
		$(use_with debug) \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with ibam) \
		|| die "Sorry, failed to configure pbbuttonsd"
	emake || die "Sorry, failed to compile pbbuttonsd"
}

src_install() {
	dodir /etc/power
	make DESTDIR=${D} install || die "failed to install"
	newinitd ${FILESDIR}/pbbuttonsd.rc6 pbbuttonsd
	dodoc README
}

pkg_postinst() {
	ewarn "Ensure that the evdev kernel module is loaded otherwise"
	ewarn "pbbuttonsd won't work."
	ewarn
	ewarn "If you need extra security, you can tell pbbuttonsd to only accept"
	ewarn "input from one user.  You can set the userallowed option in"
	ewarn "/etc/pbbuttonsd.conf to limit access."
	ewarn

	if use ppc ; then
		elog "It's recommended that you let pbbuttonsd act as the low level"
		elog "power manager instead of using pmud."
		elog
	fi
	if use ibam; then
		elog "To properly initialize the IBaM battery database, you will"
		elog "need to perform a full discharge/charge cycle.  For more"
		elog "details, please see the pbbuttonsd man page."
		elog
	fi
	ewarn "Warning: the NoTapTyping option is unstable, see bug #86768."
}
