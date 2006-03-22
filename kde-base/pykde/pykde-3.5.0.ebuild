# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/pykde/pykde-3.5.0.ebuild,v 1.4 2006/03/22 20:15:47 danarmak Exp $

KMNAME=kdebindings
KMMODULE=python
KM_MAKEFILESREV=1
MAXKDEVER=3.5.2
KM_DEPRANGE="$PV $MAXKDEVER"

inherit kde-meta distutils

DESCRIPTION="PyKDE is a set of Python bindings for kdelibs."

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="debug doc examples"

DEPEND="~dev-python/sip-4.2.1
	=dev-python/PyQt-3.14.1-r1
	kde-base/kdelibs
	!dev-python/pykde"

src_unpack() {
	kde-meta_src_unpack
	cd ${S}/python/pykde
	epatch "${FILESDIR}/configure.py.diff"
}

src_compile() {
	cd ${S}/python/pykde
	distutils_python_version

	local myconf="-d ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages \
			-v ${ROOT}/usr/share/sip \
			-k $(kde-config --prefix) \
			-t ${S}/python/pykde"

	use debug && myconf="${myconf} -u"

	python configure.py ${myconf} || die "configure failed"
	emake || die
}

src_install() {
	cd ${S}/python/pykde
	make DESTDIR=${D} install || die
	find ${D}/usr/share/sip -not -type d -not -iname *.sip -exec rm '{}' \;

	dodoc AUTHORS ChangeLog NEWS README THANKS
	use doc && dohtml -r doc/*
	if use examples ; then
		cp -r examples ${D}/usr/share/doc/${PF}
		cp -r templates ${D}/usr/share/doc/${PF}
	fi
}
