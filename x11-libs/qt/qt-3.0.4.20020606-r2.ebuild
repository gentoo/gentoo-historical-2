# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt/qt-3.0.4.20020606-r2.ebuild,v 1.1 2002/07/06 14:16:40 danarmak Exp $

PV=3.0.4
S=${WORKDIR}/qt-copy-${PV}

DESCRIPTION="QT version ${PV}"
SLOT="3"

SRC_URI="ftp://ftp.kde.org/pub/kde/stable/3.0.1/src/qt-copy-${PV}.tar.bz2
	 ftp://ftp.nnongae.com/pub/gentoo/qt-copy-${PV}-onthespot.patch
         http://darkstar.net/~gerk/${P}-cvs.patch.tar.bz2"

HOMEPAGE="http://www.trolltech.com/"

DEPEND="virtual/x11
	media-libs/libpng
	media-libs/lcms
	>=media-libs/libmng-1.0.0
	gif? ( media-libs/giflib
		media-libs/libungif )
	nas? ( >=media-libs/nas-1.4.1 )
	odbc? ( >=dev-db/unixODBC-2.0 )
	mysql? ( >=dev-db/mysql-3.2.10 )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( =dev-db/postgresql-7.1.3* )"
	

QTBASE=/usr/qt/3
export QTDIR=${S}

src_unpack() {

	export QTDIR=${S}

	unpack qt-copy-${PV}.tar.bz2
	unpack ${P}-cvs.patch.tar.bz2

# qt patch - for ami, fixed on the spot bug. 
# If you have any problem with this patch , you can remove it except Korean
	patch -p0 < ${DISTDIR}/qt-copy-${PV}-onthespot.patch || die

	# patch for cvs update (ppc and other major fixes) - Gerk
	patch -p0 < ${WORKDIR}/qt-copy-${PV}-cvs.patch || die

	cd ${S}
	cp configure configure.orig
	sed -e 's:read acceptance:acceptance=yes:' \
	    -e 's:|-repeater|:|-nas-sound|-repeater|:' configure.orig > configure

}

src_compile() {

	# experimental: enable custom optimizations
	# i don't really trust this because the qt configure doesn't support them at all
	# and it might well have a good reason
	# see bug #
	
	# 1. for qmake itself
	# note: these regexp matches are loose and may match lots of stuff,
	# so it's important to work only the first match
	cd ${S}/qmake
	mv GNUmakefile.in GNUmakefile.in.orig
	sed -e "s:CFLAGS=:CFLAGS=${CFLAGS} :" \
	    -e "s:CXXFLAGS= \$(CFLAGS):CXXFLAGS= \$(CFLAGS) ${CXXFLAGS} :" GNUmakefile.in.orig > GNUmakefile.in
	
	# 2. for apps built by qmake, in this case qt
	cd ${S}/mkspecs/linux-g++
	mv qmake.conf qmake.conf.orig
	sed -e "s:QMAKE_CFLAGS		= -pipe:QMAKE_CFLAGS		= ${CFLAGS} -pipe:" \
	    -e "s:QMAKE_CXXFLAGS		=:QMAKE_CXXFLAGS		= ${CXXFLAGS} \#:" \
	    -e "s:QMAKE_CFLAGS_RELEASE	=:QMAKE_CFLAGS_RELEASE	= \#:" \
	qmake.conf.orig > qmake.conf

	cd ${S}
	export QTDIR=${S}
	
	export LDFLAGS="-ldl"

	use nas		&& myconf="${myconf} -nas-sound"
	use gif		&& myconf="${myconf} -qt-gif"
	use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/lib/mysql"
	use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql -I/usr/include/postgresql/libpq -L/usr/lib"
	use odbc	&& myconf="${myconf} -plugin-sql-odbc"
	[ -n "$DEBUG" ]	&& myconf="${myconf} -debug" 		|| myconf="${myconf} -release -no-g++-exceptions"
	
	# avoid wasting time building things we won't install
	rm -rf tutorial examples

	# added for cvs patch (gerk)
	export YACC='byacc -d'
	make -f Makefile.cvs
	
	./configure -sm -thread -stl -system-zlib -system-libjpeg -qt-imgfmt-{jpeg,mng,png} ${myconf} \
		-system-libmng -system-libpng -ldl -lpthread -xft || die
		
	emake src-qmake src-moc sub-src sub-tools || die

}

src_install() {


	export QTDIR=${S}

	cd ${S}

	# binaries
	into $QTBASE
	dobin bin/*

	# libraries
	dolib lib/libqt-mt.so.${PV} lib/libqui.so.1.0.0 lib/libeditor.so.1.0.0
	cd ${D}$QTBASE/lib
	for x in libqui.so libeditor.so
	do
	ln -s $x.1.0.0 $x.1.0
	ln -s $x.1.0 $x.1
	ln -s $x.1 $x
	done

	# version symlinks - 3.0.3->3.0->3->.so
	ln -s libqt-mt.so.${PV} libqt-mt.so.3.0
	ln -s libqt-mt.so.3.0 libqt-mt.so.3
	ln -s libqt-mt.so.3 libqt-mt.so

	# libqt -> libqt-mt symlinks
	ln -s libqt-mt.so.${PV} 	libqt.so.${PV}
	ln -s libqt-mt.so.3.0	libqt.so.3.0
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

	sed -e "s:${D}::g" \
		-e "s:qt-x11-free-3.0.1::g" \
	-e "s:${WORKDIR}:${QTBASE}:" \
	-e "s:/usr/local/qt:${QTBASE}:" \
	${S}/.qmake.cache > ${D}${QTBASE}/.qmake.cache

	# plugins
	cd ${S}
	plugins=`find plugins -name "lib*.so" -print`
	for x in $plugins; do
		insinto ${QTBASE}/`dirname $x`
	doins $x
	done
	
	# remove extra-optimization stuff from default qmake configuration
	cd ${D}/${QTBASE}/mkspecs/linux-g++
	mv qmake.conf.orig qmake.conf

}
