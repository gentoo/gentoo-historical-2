# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-3.1.0_pre20021104.ebuild,v 1.1 2002/11/05 00:06:29 hannes Exp $

# the qt-copy snapshotfrfom 20021104 distibuted with kde 3.1 rc2

S=${WORKDIR}/qt-copy-3.1_20021104

DESCRIPTION="QT: a snapshot of the qt-copy module distributed with KDE 3.1_rc2"
SLOT="3"
LICENSE="QPL-1.0"
KEYWORDS="x86"

IUSE="gif nas odbc mysql opengl postgres cups"
# for the cvs ebuilds
QPV="3.1"

SRC_URI="mirror://kde/unstable/kde-3.1-rc2/src/qt-copy-3.1_20021104.tar.bz2"

HOMEPAGE="http://www.trolltech.com/"

COMMONDEPEND="virtual/x11
	media-libs/libpng
	media-libs/lcms
	>=media-libs/libmng-1.0.0
	>=media-libs/freetype-2
	gif? ( media-libs/giflib
		media-libs/libungif )
	nas? ( >=media-libs/nas-1.4.1 )
	odbc? ( >=dev-db/unixODBC-2.0 )
	mysql? ( >=dev-db/mysql-3.2.10 )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( >=dev-db/postgresql-7.2 )
	cups? ( >=net-print/cups-1.1.14 )"
	
DEPEND="$DEPEND $COMMONDEPEND"
RDEPEND="$RDEPEND $COMMONDEPEND"

QTBASE=/usr/qt/3
export QTDIR=${S}

src_unpack() {

	export QTDIR=${S}
	
	unpack $A

	cd ${S}

	make -f Makefile.cvs

	# qt patch - for ami, fixed on the spot bug. 
	#use nls && patch -p1 < ${FILESDIR}/qt-x11-free-3.0.5-ko_input.patch
	
	cp configure configure.orig
	sed -e 's:read acceptance:acceptance=yes:' configure.orig > configure

}

src_compile() {

	export QTDIR=${S}
	
	export LDFLAGS="-ldl"

	use nas		&& myconf="${myconf} -system-nas-sound"
	use gif		&& myconf="${myconf} -qt-gif"
	use cups        && myconf="${myconf} -cups"		|| myconf="${myconf} -no-cups"
	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/lib/mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/server"
	use odbc	&& myconf="${myconf} -plugin-sql-odbc"
	[ -n "$DEBUG" ]	&& myconf="${myconf} -debug" 		|| myconf="${myconf} -release -no-g++-exceptions"
	
	# avoid wasting time building things we won't install
	rm -rf tutorial examples

	export YACC='byacc -d'
	
	./configure -sm -thread -stl -system-zlib -system-libjpeg -qt-imgfmt-{jpeg,mng,png}\
		-tablet -system-libmng -system-libpng -ldl -lpthread -xft -largefile \
		-platform linux-g++ -xplatform linux-g++ -fast -L/usr/lib $myconf || die

	emake sub-tools || die

}

src_install() {


	export QTDIR=${S}

	cd ${S}

	# binaries
	into $QTBASE
	dobin bin/*

	# libraries
	dolib lib/libqt-mt.so.${QPV} lib/libqui.so.1.0.0 lib/lib{editor,qassistantclient,designer}.a
	cd ${D}$QTBASE/lib
	for x in libqui.so
	do
	    ln -s $x.1.0.0 $x.1.0
	    ln -s $x.1.0 $x.1
	    ln -s $x.1 $x
	done
	
	

	# version symlinks - 3.0.3->3.0->3->.so
	ln -s libqt-mt.so.${QPV} libqt-mt.so.3.1
	ln -s libqt-mt.so.3.1 libqt-mt.so.3
	ln -s libqt-mt.so.3 libqt-mt.so

	# libqt -> libqt-mt symlinks
	ln -s libqt-mt.so.${QPV} 	libqt.so.${QPV}
	ln -s libqt-mt.so.3.1		libqt.so.3.1
	ln -s libqt-mt.so.3		libqt.so.3
	ln -s libqt-mt.so		libqt.so

	# includes
	cd ${S}
	dodir ${QTBASE}/include/private
	cp include/* ${D}/${QTBASE}/include/
	cp include/private/* ${D}/${QTBASE}/include/private/

	# misc
	insinto /etc/env.d
	doins ${FILESDIR}/{45qt3,50qtdir3}

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
