# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/kerneloops/kerneloops-0.10.ebuild,v 1.1 2008/01/11 16:40:09 gregkh Exp $

inherit eutils

DESCRIPTION="Tool to automatically collect and submit Linux kernel crash signatures"
HOMEPAGE="http://www.kerneloops.org/"
SRC_URI="http://www.kerneloops.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk"

DEPEND="net-misc/curl
		sys-apps/dbus
		gtk? ( x11-libs/gtk+ x11-libs/libnotify )
		"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	epatch ${FILESDIR}/makefile-standalone-0.10.patch
}

src_compile() {
	emake kerneloops || die "Compile deamon failed"
	if use gtk ; then
		emake kerneloops-applet || die "Compile applet failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install-system || die "Install of system failed"
	emake DESTDIR="${D}" install-kerneloops || die "Install of deamon failed"
	if use gtk ; then
		emake DESTDIR="${D}" install-applet || die "Install of applet failed"
	fi

	doinitd "${FILESDIR}"/kerneloops || die "doinitd failed"

}

pkg_postinst() {
	ewarn "PRIVACY NOTE"
	ewarn "You must allow the kerneloops program to send the oops messages"
	ewarn "by either editing the /etc/kerneloops.conf file, or by running the"
	ewarn "kerneloops-applet program first."
	ewarn "Enabling this option will cause your system to submit certain kernel"
	ewarn "output to the kerneloops.org website, where it will be available via"
	ewarn "this website to developers and everyone else."
	ewarn "The submitted info are so-called \"oopses\", kernel crash signature."
	ewarn "However, due to the nature of oopses, it may happen that a few"
	ewarn "surrounding lines of the oops in the \"dmesg\" are being sent together"
	ewarn "with the oops."
}
