# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.1.0_rc1.ebuild,v 1.7 2005/12/14 05:54:01 spyderous Exp $

inherit eutils flag-o-matic toolchain-funcs multilib

SRCTYPE="opensource-src"
DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework."
HOMEPAGE="http://www.trolltech.com/"

MY_PV=${PV/_rc1/-rc1}
SRC_URI="ftp://ftp.trolltech.com/pub/qt/source/qt-x11-${SRCTYPE}-${MY_PV}.tar.gz"
S=${WORKDIR}/qt-x11-${SRCTYPE}-${MY_PV}

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="-*"
IUSE="accessibility cups debug doc examples firebird gif jpeg mng mysql nas nis odbc opengl png postgres sqlite xinerama zlib"

DEPEND="|| ( ( x11-libs/libXrandr
			x11-libs/libXcursor
			x11-libs/libXi
			x11-libs/libXfont
			x11-proto/xextproto
			x11-proto/inputproto
			xinerama? ( x11-proto/xineramaproto x11-libs/libXinerama )
		)
		virtual/x11
	)
	virtual/xft
	>=media-libs/freetype-2
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mng? ( media-libs/libmng )
	nas? ( >=media-libs/nas-1.5 )
	odbc? ( dev-db/unixODBC )
	mysql? ( dev-db/mysql )
	firebird? ( dev-db/firebird )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/libpq )
	cups? ( net-print/cups )
	zlib? ( sys-libs/zlib )"

pkg_setup() {
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=/usr/$(get_libdir)/qt4
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QTDATADIR=/usr/share/doc/${PF}
	QTDOCDIR=${QTDATADIR}/doc
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=${QTLIBDIR}/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=${QTDATADIR}/translations
	QTEXAMPLESDIR=${QTDATADIR}/examples
	QTDEMOSDIR=${QTDATADIR}/demos

	PLATFORM=$(qt_mkspecs_dir)
}

qt_use() {
	useq ${1} && echo "-${1}" || echo "-no-${1}"
	return 0
}

qt_mkspecs_dir() {
	# Allows us to define which mkspecs dir we want to use.  Currently we only use
	# linux-g++ or linux-g++-64, but others could be used for various platforms.

	if [[ $(get_libdir) == "lib" ]]; then
		echo "linux-g++"
	else
		echo "linux-g++-64"
	fi
}

src_unpack() {

	unpack ${A}
	cd ${S}

	sed -i -e 's:read acceptance:acceptance=yes:' configure

	cd mkspecs/$(qt_mkspecs_dir)
	# set c/xxflags and ldflags

	# Don't let the user go too overboard with flags.  If you really want to, uncomment
	# out the line below and give 'er a whirl.
	strip-flags
	replace-flags -O3 -O2

	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		qmake.conf

	# Do not link with -rpath. See bug #75181.
	sed -i -e "s:QMAKE_RPATH.*=.*:QMAKE_RPATH=:" \
		qmake.conf

	# Replace X11R6/ directories, so /usr/X11R6/lib -> /usr/lib
	sed -i -e "s:X11R6/::" qmake.conf

	cd ${S}
	epatch ${FILESDIR}/qt4-nomkdir.patch
	epatch ${FILESDIR}/qt-4.1.0-configure-no-mysql.diff

	if [[ "$(gcc-major-version)" == "4" ]]; then
		einfo "Visibility support: auto"
	else
		einfo "Visibility support: disabled"
		sed -i -e "s:CFG_REDUCE_EXPORTS=auto:CFG_REDUCE_EXPORTS=no:" configure
	fi
}

src_compile() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	[ $(get_libdir) != "lib" ] && myconf="${myconf} -L/usr/$(get_libdir)"

	myconf="${myconf} $(qt_use accessibility) $(qt_use cups) $(qt_use xinerama)"
	myconf="${myconf} $(qt_use opengl) $(qt_use nis)"

	use nas		&& myconf="${myconf} -system-nas-sound"
	use gif		&& myconf="${myconf} -qt-gif" || myconf="${myconf} -no-gif"
	use png		&& myconf="${myconf} -system-libpng" || myconf="${myconf} -qt-libpng"
	use jpeg	&& myconf="${myconf} -system-libjpeg" || myconf="${myconf} -qt-libjpeg"
	use debug	&& myconf="${myconf} -debug-and-release" || myconf="${myconf} -release"
	use zlib	&& myconf="${myconf} -system-zlib" || myconf="${myconf} -qt-zlib"

	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/$(get_libdir)/mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/pgsql" || myconf="${myconf} -no-sql-psql"
	use firebird	&& myconf="${myconf} -plugin-sql-ibase" || myconf="${myconf} -no-sql-ibase"
	use sqlite	&& myconf="${myconf} -plugin-sql-sqlite" || myconf="${myconf} -no-sql-sqlite"
	use odbc	&& myconf="${myconf} -plugin-sql-odbc" || myconf="${myconf} -no-sql-odbc"

	myconf="${myconf} -tablet -xrender -xrandr -xkb -xshape -sm"

	./configure -stl -verbose -largefile \
		-platform ${PLATFORM} -xplatform ${PLATFORM} \
		-prefix ${QTPREFIXDIR} -bindir ${QTBINDIR} -libdir ${QTLIBDIR} -datadir ${QTDATADIR} \
		-docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR} -plugindir ${QTPLUGINDIR} \
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} \
		-examplesdir ${QTEXAMPLESDIR} -demosdir ${QTDEMOSDIR} ${myconf} || die

	emake sub-tools-all-ordered || die
	if use examples; then
		emake sub-examples-all-ordered || die
	fi
}

src_install() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	make INSTALL_ROOT=${D} sub-tools-install_subtargets-ordered || die

	if use examples; then
		make INSTALL_ROOT=${D} sub-examples-install_subtargets || die
		make INSTALL_ROOT=${D} sub-demos-install_subtargets || die
	fi

	make INSTALL_ROOT=${D} install_qmake || die
	make INSTALL_ROOT=${D} install_mkspecs || die

	if use doc; then
		make INSTALL_ROOT=${D} install_htmldocs || die
	fi

	# The QtAssistant header files aren't installed..not sure why
	cp -pPR ${S}/include/QtAssistant ${D}/${QTHEADERDIR}/QtAssistant

	keepdir "${QTSYSCONFDIR}"

	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/*.la
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/*.prl
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/*.pc

	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:/usr/${libdir}/qt4"
	done

	cat > "${T}/44qt4" << EOF
PATH=${QTBINDIR}
ROOTPATH=${QTBINDIR}
LDPATH=${libdirs:1}
QMAKESPEC=$(qt_mkspecs_dir)
EOF
	doenvd "${T}/44qt4"
}
