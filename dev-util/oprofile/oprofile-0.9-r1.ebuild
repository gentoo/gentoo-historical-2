# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/oprofile/oprofile-0.9-r1.ebuild,v 1.1 2006/02/12 14:42:28 spock Exp $

inherit eutils qt3

DESCRIPTION="A transparent low-overhead system-wide profiler"
HOMEPAGE="http://oprofile.sourceforge.net"
SRC_URI="mirror://sourceforge/oprofile/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# IUSE: it also needs kernel sources but all gentoo users have them
IUSE="qt"
DEPEND=">=dev-libs/popt-1.7-r1
	>=sys-devel/binutils-2.14.90.0.6-r3
	>=sys-libs/glibc-2.3.2-r1
	qt? ( $(qt_min_version 3.3) )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/oprofile-0.8.2.patch
	epatch ${FILESDIR}/oprofile-0.9.1-opcontrol_path.diff
}

src_compile() {
	check_KV

	local myconf=""

	if use qt
	then
		REALHOME="$HOME"
		mkdir -p $T/fakehome/.kde
		mkdir -p $T/fakehome/.qt
		export HOME="$T/fakehome"
		addwrite "${QTDIR}/etc/settings"

		# things that should access the real homedir
		[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"
	else
		myconf="${myconf} --with-qt-dir=/void"
	fi

	myconf="${myconf} --with-x"

	case $KV in
	2.2.*|2.4.*) myconf="${myconf} --with-linux=/usr/src/linux";;
	2.5.*|2.6.*) myconf="${myconf} --with-kernel-support";;
	*) die "Kernel version '$KV' not supported";;
	esac
	econf ${myconf} || die "econf failed"

	local mymake=""

	sed -i -e "s,depmod -a,:,g" Makefile
	emake ${mymake} || die "emake failed"
}

src_install() {
	local myinst=""

	myinst="${myinst} MODINSTALLDIR=${D}/lib/modules/${KV}"
	make DESTDIR=${D} ${myinst} install || die "make install failed"

	dodoc ChangeLog* README TODO
}

pkg_postinst() {
	# media-video/nvidia-kernel does the following:
	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules

	echo
	einfo "Now load the oprofile module by running:"
	einfo "  # opcontrol --init"
	einfo "Then read manpages and this html doc:"
	einfo "  /usr/share/doc/oprofile/oprofile.html"
	echo
}
