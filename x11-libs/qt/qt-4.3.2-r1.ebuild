# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-4.3.2-r1.ebuild,v 1.8 2008/03/05 16:40:05 ingmar Exp $

inherit eutils flag-o-matic toolchain-funcs multilib

SRCTYPE="opensource-src"
DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework."
HOMEPAGE="http://www.trolltech.com/"

SRC_URI="ftp://ftp.trolltech.com/pub/qt/source/qt-x11-${SRCTYPE}-${PV}.tar.gz"
S=${WORKDIR}/qt-x11-${SRCTYPE}-${PV}

LICENSE="|| ( QPL-1.0 GPL-2 )"
SLOT="4"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

IUSE_INPUT_DEVICES="input_devices_wacom"

IUSE="accessibility cups dbus debug doc examples firebird gif glib jpeg mng mysql nas nis odbc opengl pch png postgres qt3support sqlite sqlite3 ssl tiff xinerama zlib ${IUSE_INPUT_DEVICES}"

RDEPEND="x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXfont
	x11-libs/libSM
	!x11-libs/qt-core
	xinerama? ( x11-libs/libXinerama )
	media-libs/fontconfig
	>=media-libs/freetype-2
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mng? ( >=media-libs/libmng-1.0.9 )
	tiff? ( media-libs/tiff )
	nas? ( >=media-libs/nas-1.5 )
	odbc? ( dev-db/unixODBC )
	mysql? ( virtual/mysql )
	firebird? ( dev-db/firebird )
	sqlite3? ( =dev-db/sqlite-3* )
	sqlite? ( =dev-db/sqlite-2* )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/libpq )
	cups? ( net-print/cups )
	zlib? ( sys-libs/zlib )
	glib? ( dev-libs/glib )
	dbus? ( >=sys-apps/dbus-1.0.2 )
	ssl? ( dev-libs/openssl )
	input_devices_wacom? ( x11-libs/libXi x11-drivers/linuxwacom )"

DEPEND="${RDEPEND}
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/inputproto
	dev-util/pkgconfig"

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

	PLATFORM=$(qt_mkspecs_dir)

}

qt_use() {
	local flag="$1"
	local feature="$1"
	local enableval=

	[[ -n $2 ]] && feature=$2
	[[ -n $3 ]] && enableval="-$3"

	useq $flag && echo "${enableval}-${feature}" || echo "-no-${feature}"
	return 0
}

qt_mkspecs_dir() {
	 # Allows us to define which mkspecs dir we want to use.
	local spec

	case ${CHOST} in
		*-freebsd*|*-dragonfly*)
			spec="freebsd" ;;
		*-openbsd*)
			spec="openbsd" ;;
		*-netbsd*)
			spec="netbsd" ;;
		*-darwin*)
			spec="darwin" ;;
		*-linux-*|*-linux)
			spec="linux" ;;
		*)
			die "Unknown CHOST, no platform choosed."
	esac

	CXX=$(tc-getCXX)
	if [[ ${CXX/g++/} != ${CXX} ]]; then
		spec="${spec}-g++"
	elif [[ ${CXX/icpc/} != ${CXX} ]]; then
		spec="${spec}-icc"
	else
		die "Unknown compiler ${CXX}."
	fi

	echo "${spec}"
}

src_unpack() {

	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/qt-4.2.3-hppa-ldcw-fix.patch

	epatch "${FILESDIR}"/qsslsocket-fix.patch

	cd "${S}"/mkspecs/$(qt_mkspecs_dir)
	# set c/xxflags and ldflags

	# Don't let the user go too overboard with flags.  If you really want to, uncomment
	# out the line below and give 'er a whirl.
	strip-flags
	replace-flags -O3 -O2

	if [[ $( gcc-fullversion ) == "3.4.6" && gcc-specs-ssp ]] ; then
		ewarn "Appending -fno-stack-protector to CFLAGS/CXXFLAGS"
		append-flags -fno-stack-protector
	fi

	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		-e "/CONFIG/s:$: nostrip:" \
		qmake.conf

	# Do not link with -rpath. See bug #75181.
	sed -i -e "s:QMAKE_RPATH.*=.*:QMAKE_RPATH=:" qmake.conf

	# Replace X11R6/ directories, so /usr/X11R6/lib -> /usr/lib
	sed -i -e "s:X11R6/::" qmake.conf

	# The trolls moved the definitions of the above stuff for g++, so we need to edit those files
	# separately as well.
	cd "${S}"/mkspecs/common

	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CPPFLAGS} ${CFLAGS} ${ASFLAGS}:" \
		-e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CPPFLAGS} ${CXXFLAGS} ${ASFLAGS}:" \
		-e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		g++.conf

	# Do not link with -rpath. See bug #75181.
	sed -i -e "s:QMAKE_RPATH.*=.*:QMAKE_RPATH=:" g++.conf

	# Replace X11R6/ directories, so /usr/X11R6/lib -> /usr/lib
	sed -i -e "s:X11R6/::" linux.conf

	cd "${S}"/qmake

	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CPPFLAGS} ${CXXFLAGS} ${ASFLAGS} :" \
	-e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" Makefile.unix

	cd "${S}"

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
	myconf="${myconf} -reduce-relocations"

	myconf="${myconf} $(qt_use accessibility) $(qt_use cups) $(qt_use xinerama)"
	myconf="${myconf} $(qt_use opengl) $(qt_use nis)"

	use nas		&& myconf="${myconf} -system-nas-sound"

	myconf="${myconf} $(qt_use gif gif qt) $(qt_use png libpng system)"
	myconf="${myconf} $(qt_use jpeg libjpeg system) $(qt_use tiff libtiff system)"
	myconf="${myconf} $(qt_use zlib zlib system) $(qt_use mng libmng system)"

	use debug	&& myconf="${myconf} -debug -no-separate-debug-info" || myconf="${myconf} -release -no-separate-debug-info"

	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/$(get_libdir)/mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/pgsql" || myconf="${myconf} -no-sql-psql"
	use firebird	&& myconf="${myconf} -plugin-sql-ibase -I/opt/firebird/include" || myconf="${myconf} -no-sql-ibase"
	use sqlite3	&& myconf="${myconf} -plugin-sql-sqlite -system-sqlite" || myconf="${myconf} -no-sql-sqlite"
	use sqlite	&& myconf="${myconf} -plugin-sql-sqlite2" || myconf="${myconf} -no-sql-sqlite2"
	use odbc	&& myconf="${myconf} -plugin-sql-odbc" || myconf="${myconf} -no-sql-odbc"

	use dbus	&& myconf="${myconf} -qdbus" || myconf="${myconf} -no-qdbus"
	use glib	&& myconf="${myconf} -glib" || myconf="${myconf} -no-glib"
	use qt3support		&& myconf="${myconf} -qt3support" || myconf="${myconf} -no-qt3support"
	use ssl		&& myconf="${myconf} -openssl" || myconf="${myconf} -no-openssl"

	use pch		&& myconf="${myconf} -pch" || myconf="${myconf} -no-pch"

	use input_devices_wacom	&& myconf="${myconf} -tablet" || myconf="${myconf} -no-tablet"

	myconf="${myconf} -xrender -xrandr -xkb -xshape -sm"

	if ! use examples; then
		myconf="${myconf} -nomake examples"
	fi

	myconf="-stl -verbose -largefile -confirm-license \
		-platform ${PLATFORM} -xplatform ${PLATFORM} -no-rpath \
		-prefix ${QTPREFIXDIR} -bindir ${QTBINDIR} -libdir ${QTLIBDIR} -datadir ${QTDATADIR} \
		-docdir ${QTDOCDIR} -headerdir ${QTHEADERDIR} -plugindir ${QTPLUGINDIR} \
		-sysconfdir ${QTSYSCONFDIR} -translationdir ${QTTRANSDIR} \
		-examplesdir ${QTEXAMPLESDIR} -demosdir ${QTDEMOSDIR} ${myconf}"

	echo ./configure ${myconf}
	./configure ${myconf} || die

	emake all || die
}

src_install() {
	export PATH="${S}/bin:${PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	emake INSTALL_ROOT="${D}" install_subtargets || die
	emake INSTALL_ROOT="${D}" install_qmake || die
	emake INSTALL_ROOT="${D}" install_mkspecs || die

	if use doc; then
		emake INSTALL_ROOT="${D}" install_htmldocs || die
	fi

	# Install the translations.	 This may get use flagged later somehow
	emake INSTALL_ROOT="${D}" install_translations || die

	keepdir "${QTSYSCONFDIR}"

	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/*.la
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/*.prl
	sed -i -e "s:${S}/lib:${QTLIBDIR}:g" "${D}"/${QTLIBDIR}/pkgconfig/*.pc

	# pkgconfig files refer to WORKDIR/bin as the moc and uic locations.  Fix:
	sed -i -e "s:${S}/bin:${QTBINDIR}:g" "${D}"/${QTLIBDIR}/pkgconfig/*.pc

	# Move .pc files into the pkgconfig directory
	dodir ${QTPCDIR}
	mv "${D}"/${QTLIBDIR}/pkgconfig/*.pc "${D}"/${QTPCDIR}

	# Install .desktop files, from bug #174033
	insinto /usr/share/applications
	doins "${FILESDIR}"/qt4/*.desktop

	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${libdirs}:/usr/${libdir}/qt4"
	done

	cat > "${T}/44qt4" << EOF
LDPATH=${libdirs:1}
QMAKESPEC=$(qt_mkspecs_dir)
EOF
	doenvd "${T}/44qt4"
}
