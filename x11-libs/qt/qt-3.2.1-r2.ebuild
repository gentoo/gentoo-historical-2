# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-3.2.1-r2.ebuild,v 1.2 2003/10/08 19:15:24 caleb Exp $

DESCRIPTION="QT version ${PV}"
HOMEPAGE="http://www.trolltech.com/"
SRC_URI="ftp://ftp.trolltech.com/qt/source/qt-x11-free-${PV}.tar.bz2"

LICENSE="QPL-1.0 | GPL-2"
SLOT="3"
KEYWORDS="~x86 ~ppc"
IUSE="cups nas postgres opengl mysql odbc gif doc"

DEPEND="virtual/x11
	media-libs/libpng
	media-libs/lcms
	media-libs/jpeg
	>=media-libs/libmng-1.0.0
	>=media-libs/freetype-2
	virtual/xft
	!<kde-base/kdelibs-3.1.4
	nas? ( >=media-libs/nas-1.4.1 )
	odbc? ( >=dev-db/unixODBC-2.0 )
	mysql? ( >=dev-db/mysql-3.2.10 )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( >=dev-db/postgresql-7.2 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/qt-x11-free-${PV}

QTBASE=/usr/qt/3
export QTDIR=${S}

src_unpack() {
	unpack ${A}

	export QTDIR=${S}
	cd ${S}

	cp configure configure.orig
	sed -e 's:read acceptance:acceptance=yes:' configure.orig > configure

	cd mkspecs/linux-g++
	# use env's $CC, $CXX
	if [ -n "$CXX" ]; then
		einfo 'Using environment definition of $CXX'
		cp qmake.conf qmake.conf.orig
		sed -e "s:= g++:= ${CXX}:" qmake.conf.orig > qmake.conf
	fi
	if [ -n "$CC" ]; then
		einfo 'Using environment definition of $CC'
		cp qmake.conf qmake.conf.orig
		sed -e "s:= gcc:= ${CC}:" qmake.conf.orig > qmake.conf
	fi

	# hppa and alpha people, please review the following

	# hppa need some additional flags
	if [ "${ARCH}" = "hppa" ]; then
		echo "QMAKE_CFLAGS += -fPIC -ffunction-sections" >> qmake.conf
		echo "QMAKE_CXXFLAGS += -fPIC -ffunction-sections" >> qmake.conf
		echo "QMAKE_LFLAGS += -ffunction-sections -Wl,--stub-group-size=25000" >> qmake.conf
	fi

	# on alpha we need to compile everything with -fPIC
	if [ ${ARCH} == "alpha" ]; then
		cp qmake.conf qmake.conf.orig
		sed -e "s:= -O2:= -O2 -fPIC:" qmake.conf.orig > qmake.conf
		cat >> ${S}/tools/designer/editor/editor.pro <<_EOF_
QMAKE_CFLAGS += -fPIC
QMAKE_CXXFLAGS += -fPIC
_EOF_
	fi

	cd ${S}
	epatch ${FILESDIR}/0001-dnd_optimization.patch
	epatch ${FILESDIR}/0002-dnd_active_window_fix.patch
	epatch ${FILESDIR}/0003-qmenubar_fitts_law.patch
	epatch ${FILESDIR}/0004-qiconview_etc_ctrl_selecting.patch
	epatch ${FILESDIR}/0009-window_group.patch
	epatch ${FILESDIR}/0011-listview_keys.patch
	epatch ${FILESDIR}/0013-qtabwidget-less_flicker.patch
	epatch ${FILESDIR}/0014-qiconview-autoscroll.patch
	epatch ${FILESDIR}/0015-qiconview-finditem.patch
	epatch ${FILESDIR}/0016-qiconview-rebuildcontainer.patch
	epatch ${FILESDIR}/0017-qiconview-ctrl_rubber.patch
	epatch ${FILESDIR}/0018-qlistview-paintcell.patch
	epatch ${FILESDIR}/0019-qlistview-adjustcolumn.patch
	epatch ${FILESDIR}/0020-designer-deletetabs.patch
	epatch ${FILESDIR}/0021-qiconview-dragalittle.patch
	epatch ${FILESDIR}/0022-qdragobject-hotspot.patch
	epatch ${FILESDIR}/0024-fix_enter_leave_notify.patch
}

src_compile() {
	export QTDIR=${S}
	export SYSCONF=${QTBASE}/etc/settings
	LD_LIBRARY_PATH_OLD=${LD_LIBRARY_PATH}
	export LD_LIBRARY_PATH=${S}/lib:${LD_LIBRARY_PATH}

	# fix #11144; qt wants to create lock files etc. in that directory
	[ -d "$QTBASE/etc/settings" ] && addwrite "$QTBASE/etc/settings"
	[ ! -d "$QTBASE/etc/settings" ] && dodir ${QTBASE}/etc/settings

	export LDFLAGS="-ldl"

	use cups	|| myconf="${myconf} -no-cups"
	use nas		&& myconf="${myconf} -system-nas-sound"
	use gif		&& myconf="${myconf} -qt-gif"
	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/lib/mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/server"
	use odbc	&& myconf="${myconf} -plugin-sql-odbc"
	use opengl	&& myconf="${myconf} -enable-module=opengl" || myconf="${myconf} -disable-opengl"
	use debug	&& myconf="${myconf} -debug" || myconf="${myconf} -release -no-g++-exceptions"
	use xinerama    && myconf="${myconf} -xinerama"

	export YACC='byacc -d'

	./configure -sm -thread -stl -system-zlib -system-libjpeg -verbose \
		-qt-imgfmt-{jpeg,mng,png} -tablet -system-libmng \
		-system-libpng -ldl -lpthread -xft -platform linux-g++ -xplatform \
		linux-g++ -xrender -prefix ${D}${QTBASE} -plugindir ${QTBASE}/plugins \
		-docdir ${QTBASE}/doc -translationdir ${QTBASE}/translations \
		-datadir ${QTBASE} -fast ${myconf} || die

	export QTDIR=${S}
	emake src-qmake src-moc sub-src sub-tools || die
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH_OLD}
}

src_install() {
	export QTDIR=${S}

	# binaries
	into $QTBASE
	dobin bin/*

	# libraries
	dolib lib/libqt-mt.so.3.2.1 lib/libqui.so.1.0.0 lib/lib{editor,qassistantclient,designercore}.a
	cd ${D}/$QTBASE/lib
	for x in libqui.so ; do
		ln -s $x.1.0.0 $x.1.0
		ln -s $x.1.0 $x.1
		ln -s $x.1 $x
	done

	# version symlinks - 3.2.1->3.2->3->.so
	ln -s libqt-mt.so.3.2.1 libqt-mt.so.3.2
	ln -s libqt-mt.so.3.2 libqt-mt.so.3
	ln -s libqt-mt.so.3 libqt-mt.so

	# libqt -> libqt-mt symlinks
	ln -s libqt-mt.so.3.2.1 libqt.so.3.2.1
	ln -s libqt-mt.so.3.2 libqt.so.3.2
	ln -s libqt-mt.so.3 libqt.so.3
	ln -s libqt-mt.so libqt.so

	# includes
	cd ${S}
	dodir ${QTBASE}/include/private
	cp include/* ${D}/${QTBASE}/include/
	cp include/private/* ${D}/${QTBASE}/include/private/

	# misc
	insinto /etc/env.d
	doins ${FILESDIR}/{45qt3,50qtdir3}

	dodir ${QTBASE}/tools/designer/templates
	cd ${S}
	cp tools/designer/templates/* ${D}/${QTBASE}/tools/designer/templates

	dodir ${QTBASE}/translations
	cd ${S}
	cp translations/* ${D}/${QTBASE}/translations

	dodir ${QTBASE}/doc

	if [ `use doc` ]; then
		cd ${S}/doc
		for x in html flyers; do
			cp -r $x ${D}/${QTBASE}/doc
		done

		cp -r ${S}/doc/man ${D}/${QTBASE}
		cp -r ${S}/examples ${D}/${QTBASE}
		cp -r ${S}/tutorial ${D}/${QTBASE}
	fi

	# misc build reqs
	dodir ${QTBASE}/mkspecs
	cp -R ${S}/mkspecs/linux-g++ ${D}/${QTBASE}/mkspecs/

	sed -e "s:${S}:${QTBASE}:g" \
		${S}/.qmake.cache > ${D}${QTBASE}/.qmake.cache

	# plugins
	cd ${S}
	plugins=`find plugins -name "lib*.so" -print`
	for x in $plugins; do
		insinto ${QTBASE}/`dirname $x`
		doins $x
	done
}
