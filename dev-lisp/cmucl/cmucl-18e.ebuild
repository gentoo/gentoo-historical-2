# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cmucl/cmucl-18e.ebuild,v 1.2 2004/04/25 20:56:45 vapier Exp $

inherit eutils

# This package is a port of the Debian package of the same name.
DEB_PV=7

DESCRIPTION="CMUCL Lisp. This conforms to the ANSI Common Lisp Standard"
HOMEPAGE="http://www.cons.org/cmucl/ http://packages.debian.org/unstable/devel/cmucl.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cmucl/cmucl_${PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/c/cmucl/cmucl_${PV}-${DEB_PV}.diff.gz
	http://cmucl.cons.org/ftp-area/cmucl/release/18e/cmucl-${PV}-x86-linux.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc X"

DEPEND="dev-lisp/common-lisp-controller
	x11-libs/lesstif
	doc? ( app-text/tetex )"
#	X? ( x11-libs/lesstif )" 
PROVIDE="virtual/commonlisp"

S=${WORKDIR}/${P}.orig

src_unpack() {
	unpack ${A}
	epatch cmucl_${PV}-${DEB_PV}.diff
	epatch ${FILESDIR}/${PV}/herald-save.lisp-gentoo.patch
}

src_compile() {
	PATH=${WORKDIR}/bin:$PATH CMUCLCORE=${WORKDIR}/lib/cmucl/lib/lisp.core make || die
	if use doc; then
		make -C src/docs
	fi
}

src_install() {
	insinto /usr/lib/cmucl/include
	doins src/lisp/*.h target/lisp/*.h target/lisp/*.map target/lisp/*.nm
	insinto /usr/lib/cmucl
	cp target/lisp/lisp.core lisp-dist.core
	doins lisp-dist.core

	dodoc target/lisp/lisp.{nm,map}
	doman src/general-info/{cmucl,lisp}.1

	dobin target/lisp/lisp
	dobin own-work/Demos/lisp-start

	insinto /usr/lib/cmucl
	doins own-work/install-clc.lisp
	exeinto /usr/lib/common-lisp/bin
	cp own-work/cmucl-script.sh cmucl.sh
	doexe cmucl.sh

	insinto /etc/common-lisp/cmucl
	sed "s,@PF@,${PF},g" <${FILESDIR}/${PV}/site-init.lisp.in >site-init.lisp
	doins site-init.lisp
	dosym /etc/common-lisp/cmucl/site-init.lisp /usr/lib/cmucl/site-init.lisp

	dodir /etc/env.d
	cat >${D}/etc/env.d/50cmucl <<EOF
# CMUCLLIB=/usr/lib/cmucl
EOF
	[ -f /etc/lisp-config.lisp ] || touch ${D}/etc/lisp-config.lisp

	insinto /usr/share/doc/${P}/html/Basic-tutorial
	doins own-work/tutorials/Basic-tutorial/*
	insinto /usr/share/doc/${P}/html/Clos
	doins own-work/tutorials/Clos/*
	docinto notes
	dodoc own-work/tutorials/notes/*

	insinto /usr/lib/cmucl
	doins own-work/hemlock11.*

	if use doc; then
		dodoc src/docs/*/*.{ps,pdf}
	fi

	if use X; then
		exeinto /usr/lib/cmucl
		doexe target/motif/server/motifd
		insinto /usr/lib/cmucl/subsystems/
		doins target/interface/clm-library.x86f
	fi
}

pkg_postinst() {
	/usr/sbin/register-common-lisp-implementation cmucl
}

pkg_prerm() {
	/usr/sbin/unregister-common-lisp-implementation cmucl
}
