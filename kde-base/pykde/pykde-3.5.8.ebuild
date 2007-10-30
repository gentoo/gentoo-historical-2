# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/pykde/pykde-3.5.8.ebuild,v 1.4 2007/10/30 06:02:14 philantrop Exp $

KMNAME=kdebindings
KMMODULE=python
KM_MAKEFILESREV=1
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"

inherit kde-meta distutils

DESCRIPTION="PyKDE is a set of Python bindings for kdelibs."

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug doc examples"

DEPEND="~dev-python/sip-4.6
		~dev-python/PyQt-3.17.2
		kde-base/kdelibs
		|| ( kde-base/kdebase kde-base/konsole )
		!dev-python/pykde"

src_unpack() {
	kde-meta_src_unpack
	cd "${S}/python/pykde"
	epatch "${FILESDIR}/${P}-python-2.5-compat.diff"

	mkdir -p kparts
	ln -s "${PREFIX}"/$(get_libdir)/kde3/libkonsolepart* ./kparts/
}

src_compile() {
	cd "${S}/python/pykde"
	distutils_python_version

	local myconf="-d /usr/$(get_libdir)/python${PYVER}/site-packages \
			-v /usr/share/sip \
			-k $(kde-config --prefix)"

	use debug && myconf="${myconf} -u"
	myconf="${myconf} -i"

	python configure.py ${myconf} || die "configure failed"
	emake || die
}

src_install() {
	cd "${S}/python/pykde"
	dodir "${PREFIX}"/$(get_libdir)
	sed -i -e "s:/lib/:/$(get_libdir)/:g" Makefile

	for X in dcop kdecore kdefx kdeui kio kresources kabc kutils kfile kparts khtml kspell kdeprint kmdi ; do
		sed -i -e '/strip $(DESTDIR).*/d' ${X}/Makefile
	done

	make DESTDIR="${D}" install || die
	find "${D}/usr/share/sip" -not -type d -not -iname *.sip -exec rm '{}' \;

	dodoc AUTHORS ChangeLog NEWS README THANKS
	use doc && dohtml -r doc/*
	if use examples ; then
		cp -r examples "${D}/usr/share/doc/${PF}"
		cp -r templates "${D}/usr/share/doc/${PF}"
	fi
}
