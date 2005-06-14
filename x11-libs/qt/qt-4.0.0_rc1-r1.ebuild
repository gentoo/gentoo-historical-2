# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.0.0_rc1-r1.ebuild,v 1.2 2005/06/14 20:28:40 swegener Exp $

inherit eutils flag-o-matic

SRCTYPE="opensource-desktop"
SNAPSHOT="20050614"
#SNAPSHOT=""
DESCRIPTION="QT version ${PV}"
HOMEPAGE="http://www.trolltech.com/"

SRC_URI="ftp://ftp.trolltech.com/qt/snapshots/qt-x11-${SRCTYPE}-${PV/_rc1/}-snapshot-${SNAPSHOT}.tar.bz2"
#SRC_URI="ftp://ftp.trolltech.com/qt/source/qt-x11-${SRCTYPE}-${PV/_rc1/-rc1}.tar.bz2"
#S=${WORKDIR}/qt-x11-${SRCTYPE}-${PV/_rc1/-rc1}
S=${WORKDIR}/qt-x11-${SRCTYPE}-${PV/_rc1/}-snapshot-${SNAPSHOT}

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="-*"
IUSE="accessibility cups debug doc examples firebird gif ipv6 jpeg mng mysql nas nis odbc opengl postgres png sqlite xinerama zlib"

DEPEND="virtual/x11 virtual/xft >=media-libs/freetype-2
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mng? ( media-libs/libmng )
	nas? ( >=media-libs/nas-1.5 )
	odbc? ( dev-db/unixODBC )
	mysql? ( dev-db/mysql )
	firebird? ( dev-db/firebird )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/postgresql )
	cups? ( net-print/cups )
	zlib? ( sys-libs/zlib )"

pkg_setup() {
	QTBASEDIR=/usr/$(get_libdir)/qt4
	QTPREFIXDIR=${S}
	QTBINDIR=/usr/bin
	QTLIBDIR=/usr/$(get_libdir)/qt4
	QTDOCDIR=/usr/share/qt4/doc
	QTDATADIR=/usr/share/qt4
	QTHEADERDIR=/usr/include/qt4
	QTPLUGINDIR=/usr/$(get_libdir)/qt4/plugins
	QTSYSCONFDIR=/etc/qt4
	QTTRANSDIR=/usr/share/qt4/translations

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

	cp configure configure.orig
	sed -e 's:read acceptance:acceptance=yes:' configure.orig > configure

	cd mkspecs/$(qt_mkspecs_dir)
	# set c/xxflags and ldflags

	# Don't let the user go too overboard with flags.  If you really want to, uncomment
	# out the line below and give 'er a whirl.
	strip-flags

	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		qmake.conf
	cd ${S}

	epatch ${FILESDIR}/qt4-rpath.patch
	epatch ${FILESDIR}/qt4rc1_nomkdir.patch

	sed -i -e "s:CFG_REDUCE_EXPORTS=auto:CFG_REDUCE_EXPORTS=no:" configure
}

src_compile() {
	export SYSCONF=${D}${QTPREFIXDIR}/etc/settings
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	# Fixes for 89704
	export LC_ALL=C
	export LANG=C

	# Let's just allow writing to these directories during Qt emerge
	# as it makes Qt much happier.
	# addwrite "${QTBASE}/etc/settings"
	# addwrite "$HOME/.qt"

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
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} ${myconf} || die

	emake sub-tools-all-ordered || die
}

src_install() {
	export SYSCONF=${D}${QTPREFIXDIR}/etc/settings
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	# make INSTALL_ROOT=${D} sub-demos-install_subtargets-ordered sub-examples-install_subtargets-ordered || die
	# make INSTALL_ROOT=${D} install_qmake sub-tools-install_subtargets-ordered || die
	# Using install_qmake forces lots of other things to build.  Bypass it for now.

	make INSTALL_ROOT=${D} sub-tools-install_subtargets-ordered || die
	if use examples; then
		dodir ${QTDATADIR}/examples
		cp -a ${S}/examples/* ${D}/${QTDATADIR}/examples
		dodir ${QTDATADIR}/demos
		cp -a ${S}/demos/* ${D}/${QTDATADIR}/demos
	fi

	make INSTALL_ROOT=${D} install_qmake || die
	make INSTALL_ROOT=${D} install_mkspecs || die

	# The QtDesigner and QtAssistant header files aren't installed..not sure why
	cp -a ${S}/include/QtDesigner ${D}/${QTHEADERDIR}/QtDesigner
	rm -rf ${D}/${QTHEADERDIR}/QtDesigner/private

	cp -a ${S}/include/QtAssistant ${D}/${QTHEADERDIR}/QtAssistant

	# Fix symlink
	cd ${D}/${QTDATADIR}/mkspecs
	rm default
	ln -s $(qt_mkspecs_dir) default
	cd ${S}

	mkdir -p ${D}/${QTSYSCONFDIR}

	if use doc; then
		make INSTALL_ROOT=${D} install_htmldocs || die
	fi

	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/*.la
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/*.prl
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" ${D}/${QTLIBDIR}/pkgconfig/*.pc
	sed -i -e "s:${S}:${QTBASEDIR}:g" ${D}/${QTLIBDIR}/pkgconfig/*.pc

	# Don't need to install stray linguist files
	rm -rf ${D}/${DATADIR}/phrasebooks/linguist

	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:/usr/${libdir}/qt4"
	done

	mkdir -p ${D}/etc/env.d

	cat > ${D}/etc/env.d/44qt4 << EOF
PATH=${QTBINDIR}
ROOTPATH=${QTBINDIR}
LDPATH=${libdirs:1}
QMAKESPEC=$(qt_mkspecs_dir)
EOF
}
