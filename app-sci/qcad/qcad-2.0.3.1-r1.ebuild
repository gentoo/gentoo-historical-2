# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/qcad/qcad-2.0.3.1-r1.ebuild,v 1.2 2004/05/26 08:30:36 phosphan Exp $

inherit kde-functions eutils

MY_P=${P}-1.src
S=${WORKDIR}/${MY_P}
DESCRIPTION="A 2D CAD package based upon Qt."
SRC_URI="http://www.ribbonsoft.com/archives/qcad/${MY_P}.tar.gz"
HOMEPAGE="http://www.ribbonsoft.com/qcad.html"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86"

need-qt 3.3

DEPEND="${DEPEND}
		>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	echo >> defs.pro "DEFINES += _REENTRANT QT_THREAD_SUPPORT"
	echo >> defs.pro "CONFIG += thread release"
	echo >> defs.pro "QMAKE_CFLAGS_RELEASE += ${CFLAGS}"
	echo >> defs.pro "QMAKE_CXXFLAGS_RELEASE += ${CXXFLAGS}"
	epatch ${FILESDIR}/${MY_P}-gentoo.patch
	epatch ${FILESDIR}/manual.patch
	cd ${S}/scripts
	sed -i -e 's/^make/make ${MAKEOPTS}/' build_qcad.sh || \
		die "unable to add MAKEOPTS"
	sed -i -e 's/^\.\/configure/.\/configure --host=${CHOST}/' build_qcad.sh \
		|| die "unable to set CHOST"
	cd ${S}/qcad/src
	sed -i -e "s:FULLASSISTANTPATH:${QTDIR}/bin:" qc_applicationwindow.cpp \
		|| die "sed failed on assistant path"
	sed -i -e "s:QCADDOCPATH:/usr/share/doc/${PF}/html:" \
		qc_applicationwindow.cpp  || die "sed failed on manual path"
}


src_compile() {
	### borrowed from kde.eclass #
	#
	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox, so that the build process
	# can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"
	cd scripts
	sh build_qcad.sh || die "build failed"
	if ! test -f ${S}/qcad/qcad; then
		die "no binary created, build failed"
	fi
}

src_install () {
	cd qcad
	mv qcad qcad.bin
	dobin qcad.bin
	echo -e "#!/bin/sh\ncd /usr/share/${P}\nqcad.bin" > qcad
	chmod ugo+rx qcad
	dobin qcad
	dodir /usr/share/${P}
	cp -a patterns examples fonts scripts qm ${D}/usr/share/${P}
	cd ..
	dodoc README
	dohtml -r qcad/doc/.
	insinto /usr/share/doc/${PF}/html
	doins qcad/doc/qcaddoc.adp
}

pkg_postinst () {
	if ! has_version "app-sci/qcad-parts"; then
	einfo
	einfo "The QCad parts library is available as a seperate package."
	einfo "emerge app-sci/qcad-parts to get it."
	einfo
	fi
}
