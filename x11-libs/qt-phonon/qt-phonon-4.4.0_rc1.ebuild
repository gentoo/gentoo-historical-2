# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-phonon/qt-phonon-4.4.0_rc1.ebuild,v 1.1 2007/12/20 12:26:40 caleb Exp $

inherit eutils flag-o-matic toolchain-funcs multilib

SRCTYPE="preview-opensource-src"
DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework."
HOMEPAGE="http://www.trolltech.com/"

MY_PV=${PV/_rc/-tp}

SRC_URI="ftp://ftp.trolltech.com/pub/qt/source/qt-x11-${SRCTYPE}-${MY_PV}.tar.gz"
S=${WORKDIR}/qt-x11-${SRCTYPE}-${MY_PV}

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="~x86"

IUSE="debug"

RDEPEND="=x11-libs/qt-4.4.0_rc1
	media-libs/gstreamer
	media-libs/gst-plugins-base"

DEPEND="${RDEPEND}"

pkg_setup() {
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=/usr
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QTPCDIR=/usr/$(get_libdir)/pkgconfig
	QTDATADIR=/usr/share/qt4
	QTDOCDIR=/usr/share/doc/${PF}
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos
}

src_unpack() {

	unpack ${A}
	cd "${S}"
	# epatch "${FILESDIR}"/qt-4.2.3-hppa-ldcw-fix.patch

	epatch "${FILESDIR}"/abstractaudiooutput.cpp.diff

	# Don't let the user go too overboard with flags.  If you really want to, uncomment
	# out the line below and give 'er a whirl.
	strip-flags
	replace-flags -O3 -O2

	if [[ $( gcc-fullversion ) == "3.4.6" && gcc-specs-ssp ]] ; then
		ewarn "Appending -fno-stack-protector to CFLAGS/CXXFLAGS"
		append-flags -fno-stack-protector
	fi


}

src_compile() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	[ $(get_libdir) != "lib" ] && myconf="${myconf} -L/usr/$(get_libdir)"

	# Disable visibility explicitly if gcc version isn't 4
	if [[ "$(gcc-major-version)" != "4" ]]; then
		myconf="${myconf} -no-reduce-exports"
	fi

	# Add a switch that will attempt to use recent binutils to reduce relocations.  Should be harmless for other
	# cases.  From bug #178535
	myconf="${myconf} -fast -reduce-relocations -phonon"
	use debug	&& myconf="${myconf} -debug -no-separate-debug-info" || myconf="${myconf} -release -no-separate-debug-info"

	myconf="${myconf} -nomake examples -nomake demos"

	myconf="-stl -verbose -largefile -confirm-license \
		-no-rpath \
		-prefix ${QTPREFIXDIR} -bindir ${QTBINDIR} -libdir ${QTLIBDIR} -datadir ${QTDATADIR} \
		-docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR} -plugindir ${QTPLUGINDIR} \
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} \
		-examplesdir ${QTEXAMPLESDIR} -demosdir ${QTDEMOSDIR} ${myconf}"

	echo ./configure ${myconf}
	./configure ${myconf} || die

	# Edit the .qmake.cache file
	sed -i -e "s:QMAKE_MOC:\#QMAKE_MOC:g" "${S}"/.qmake.cache
	sed -i -e "s:QMAKE_UIC:\#QMAKE_UIC:g" "${S}"/.qmake.cache
	sed -i -e "s:QMAKE_RCC:\#QMAKE_RCC:g" "${S}"/.qmake.cache

	cd "${S}"/src/phonon
	qmake "LIBS+=-L${QTLIBDIR}" && emake || die
}

src_install() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	cd "${S}"/src/phonon
	emake INSTALL_ROOT="${D}" install || die

	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/*.la
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/*.prl
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/pkgconfig/*.pc

	# pkgconfig files refer to WORKDIR/bin as the moc and uic locations.  Fix:
	sed -i -e "s:${S}/bin:${QTBINDIR}:g" "${D}"/${QTLIBDIR}/pkgconfig/*.pc

	# Move .pc files into the pkgconfig directory
	dodir ${QTPCDIR}
	mv "${D}"/${QTLIBDIR}/pkgconfig/*.pc "${D}"/${QTPCDIR}
}
