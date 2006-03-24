# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen-tools/xen-tools-3.0.1.ebuild,v 1.1 2006/03/24 23:55:01 agriffis Exp $

inherit mount-boot flag-o-matic

DESCRIPTION="Xend daemon and tools"
HOMEPAGE="http://xen.sourceforge.net"
if [[ ${PV} == *_p* ]]; then
	XEN_UNSTABLE="xen-unstable-${PV#*_p}"
	SRC_URI="mirror://gentoo/${XEN_UNSTABLE}.tar.bz2"
	S=${WORKDIR}/${XEN_UNSTABLE}
else
	SRC_URI="http://www.cl.cam.ac.uk/Research/SRG/netos/xen/downloads/xen-${PV}-src.tgz"
	S=${WORKDIR}/xen-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="doc debug screen custom-cflags"

DEPEND="sys-devel/gcc
	dev-lang/python"

RDEPEND="!<app-emulation/xen-3.0.1-r5
	dev-lang/python
	sys-apps/iproute2
	net-misc/bridge-utils
	sys-libs/zlib
	doc? (
		dev-tex/latex2html
		media-gfx/transfig
	)
	screen? (
		app-misc/screen
		app-admin/logrotate
	)
	|| ( sys-fs/udev sys-apps/hotplug )"

src_unpack() {
	unpack ${A}
	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find ${S} -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
		# odd fixes
		sed -e "s/int mode/int mode=-1/" -i ${S}/tools/misc/xc_shadow.c
	fi
}

src_compile() {
	local myopt
	use debug && myopt="${myopt} debug=y"

	if use custom-cflags; then
		filter-flags -fPIE -fstack-protector
	else
		unset CFLAGS
	fi

	emake -C tools ${myopt} || die "compile failed"

	if use doc; then
		sh ./docs/check_pkgs || die "package check failed"
		make -C docs ${myopt} || die "compiling docs failed"
	fi
}

src_install() {
	local myopt="XEN_PYTHON_NATIVE_INSTALL=1"

	make DESTDIR=${D} ${myopt} install-tools \
		|| die "install failed"

	if use doc; then
		make DESTDIR=${D} -C docs install || die "install docs failed"
		# Rename doc/xen to the Gentoo-style doc/xen-x.y
		mv ${D}/usr/share/doc/{${PN},${PF}}
	fi

	newinitd ${FILESDIR}/xend-init xend
	newconfd ${FILESDIR}/xend-conf xend
	newconfd ${FILESDIR}/xendomains-conf xendomains
	newinitd ${FILESDIR}/xendomains-init xendomains

	if use screen; then
		sed -i -e 's/SCREEN="no"/SCREEN="yes"/' ${D}/etc/init.d/xendomains
	fi

	# xend expects these to exist
	keepdir /var/run/xenstored /var/lib/xenstored /var/xen/dump

	# for upstream change tracking
	if [[ -n ${XEN_UNSTABLE} ]]; then 
		dodoc ${S}/XEN-VERSION
	fi
}

pkg_postinst() {
	einfo "Please visit the Xen and Gentoo wiki:"
	einfo "http://gentoo-wiki.com/HOWTO_Xen_and_Gentoo"

	if [[ -n ${XEN_UNSTABLE} ]]; then
		echo
		einfo "This is a snapshot of the xen-unstable tree."
		einfo "Please report bugs in xen itself (and not the packaging) to"
		einfo "bugzilla.xensource.com"
	fi
}
