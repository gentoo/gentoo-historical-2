# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-embedded/qt-embedded-3.0.5.ebuild,v 1.6 2002/10/17 16:22:06 aliz Exp $

IUSE="gif build opengl mysql odbc postgres"

S=${WORKDIR}/qt-embedded-free-${PV}

DESCRIPTION="QT version ${PV}"
SLOT="3"
LICENSE="QPL-1.0 | GPL-2"
KEYWORDS="x86"

SRC_URI="ftp://ftp.trolltech.com/qt/source/qt-embedded-free-${PV}.tar.bz2"

HOMEPAGE="http://www.trolltech.com/"

if [ -z "`use build`" ]; then
	DEPEND="media-libs/libpng
		media-libs/lcms
		media-libs/jpeg
		>=media-libs/libmng-1.0.0
		>=media-libs/freetype-2
		odbc? ( >=dev-db/unixODBC-2.0 )
		mysql? ( >=dev-db/mysql-3.2.10 )
		opengl? ( virtual/opengl virtual/glu )
		postgres? ( >=dev-db/postgresql-7.2 )"
else
	DEPEND="media-libs/lcms
		>=media-libs/freetype-2"
fi
	

QTBASE=/usr/qt/3-embedded
export QTDIR=${S}

src_unpack() {
    
	[ -z "`use build`" ] && einfo "
Note: this will build a rather bloated qt/e, with all features enabled.
It may be suitable for testing, but definitely not for real embedded systems
where memory is precious. I advise you select your own featureset (e.g. by
editing this ebuild) if building for such a system.
"

	export QTDIR=${S}

	unpack $A

	cd ${S}
	cp configure configure.orig
	sed -e 's:read acceptance:acceptance=yes:' configure.orig > configure

	# avoid wasting time building things we won't install
	rm -rf tutorial examples

}

src_compile() {

	export QTDIR=${S}
	export YACC='byacc -d'	
	export LDFLAGS="-ldl"
	export QTDIR=${S}

	if [ -z "`use build`" ]; then
	    # ordinary setup, rather bloated
	    use gif		&& myconf="${myconf} -qt-gif"
	    use mysql	&& myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/lib/mysql"
	    use postgres	&& myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/server"
	    use odbc	&& myconf="${myconf} -plugin-sql-odbc"
	    [ -n "$DEBUG" ]	&& myconf="${myconf} -debug" 	|| myconf="${myconf} -release -no-g++-exceptions"

	    if [ "`use x86`" ]; then
		myconf="$myconf  -embedded x86" # -xplatform linux-g++ -platform linux-g++"
	    else
		# and i've no idea if it'll work
		myconf="$myconf -xplatform generic -embedded generic"
	    fi
	
	    # -accel-{voodoo3,mach64,matrox} -vnc -depths v,4,8,16,24,32 # this stuff miscompiles :-(
	
    	    ./configure $myconf -depths 8,16 -system-zlib -thread -stl -freetype -qvfb \
    		-plugin-imgfmt-{jpeg,mng,png} -system-lib{png,jpeg,mng} || die
		

	else
	    # use build == we're building for the gentoo isntaller project
	    # and know exactly which features we'll need
	    
	    # not all of these features are as yet reflected in the configure call below
	    
	    #png only, builtin. also zlib, system.
	    #no sql or other fancy stuff.
	    #no debug
	    #thread support
	    #freetype2 support
	    #vnc
	    #all styles as plugins
	    ./configure -depths 8,16 -no-gif -no-lib{jpeg,mng} -qt-libpng -system-zlib -release \
		-no-g++-exceptions -no-qvfb -thread -freetype -vnc  || die
	fi

	cp $FILESDIR/tools-Makefile $S/tools/Makefile
	
	cd $S/tools/designer/designer
	mv Makefile Makefile.orig
	sed -e 's:lqt-mt:lqte-mt:g' Makefile.orig > Makefile
	rm Makefile.orig
	
	cd $S
	emake src-qmake src-moc sub-src sub-tools || die

}

src_install() {


	export QTDIR=${S}

	cd ${S}

	# binaries
	into $QTBASE
	dobin bin/*

	# libraries
	dolib lib/libqte-mt.so.${PV} lib/libqui.so.1.0.0 lib/libeditor.so.1.0.0
	cd ${D}$QTBASE/lib
	for x in libqui.so libeditor.so
	do
	ln -s $x.1.0.0 $x.1.0
	ln -s $x.1.0 $x.1
	ln -s $x.1 $x
	done

	# version symlinks - 3.0.3->3.0->3->.so
	ln -s libqte-mt.so.${PV} libqte-mt.so.3.0
	ln -s libqte-mt.so.3.0 libqte-mt.so.3
	ln -s libqte-mt.so.3 libqte-mt.so

	# libqt -> libqt-mt symlinks
	ln -s libqte-mt.so.${PV} 	libqte.so.${PV}
	ln -s libqte-mt.so.3.0		libqte.so.3.0
	ln -s libqte-mt.so.3		libqte.so.3
	ln -s libqte-mt.so		libqte.so
	
	# fonts
	cp -r $S/lib/fonts $D/$QTBASE/lib

	# includes
	cd ${S}
	dodir ${QTBASE}/include/private
	cp include/* ${D}/${QTBASE}/include/
	cp include/private/* ${D}/${QTBASE}/include/private/

	# misc
	insinto /etc/env.d
	doins ${FILESDIR}/47qt-embedded3

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

}


