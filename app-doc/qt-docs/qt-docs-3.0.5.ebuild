# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/qt-docs/qt-docs-3.0.5.ebuild,v 1.6 2002/10/04 04:03:44 vapier Exp $

S=${WORKDIR}/qt-x11-free-$PV
SRC_URI="ftp://ftp.trolltech.com/qt/source/qt-x11-free-${PV}.tar.gz"
HOMEPAGE="http://www.trolltech.com/"
DESCRIPTION="Documentation for the QT ${PV} API"
KEYWORDS="x86 sparc sparc64 ppc"
SLOT="3"
LICENSE="QPL-1.0"

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	QTBASE=/usr/qt/3
	export QTDIR=${S}
	cd ${S}
	# misc
	insinto /etc/env.d
	doins ${FILESDIR}/45qt-docs3

	# docs
	cd ${S}/doc
	dodir ${QTBASE}/doc
	for x in html flyers; do
		cp -r $x ${D}/${QTBASE}/doc
	done

	# manpages
	cp -r ${S}/doc/man ${D}/${QTBASE}
	# examples
	cp -r ${S}/examples ${D}/${QTBASE}
	# tutorials
	cp -r ${S}/tutorial ${D}/${QTBASE}

}
