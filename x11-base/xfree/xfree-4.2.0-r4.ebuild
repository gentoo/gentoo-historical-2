# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Achim Gottinger <achim@gentoo.org>, Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-base/xfree/xfree-4.2.0-r4.ebuild,v 1.1 2002/01/23 22:22:57 azarah Exp $

MY_V="`echo ${PV} |sed -e 's:\.::g'`"
S=${WORKDIR}/xc
DESCRIPTION="Xfree86: famouse and free X server"
SRC_PATH0="ftp://ftp.xfree.org/pub/XFree86/${PV}/source"
SRC_PATH1="ftp://ftp1.sourceforge.net/pub/mirrors/XFree86/${PV}/source"

SRC_URI="$SRC_PATH0/X${MY_V}src-1.tgz
	 $SRC_PATH0/X${MY_V}src-2.tgz
	 $SRC_PATH0/X${MY_V}src-3.tgz
	 $SRC_PATH1/X${MY_V}src-1.tgz
	 $SRC_PATH1/X${MY_V}src-2.tgz
	 $SRC_PATH1/X${MY_V}src-3.tgz
       	 http://www.ibiblio.org/gentoo/gentoo-sources/truetype.tar.gz"

HOMEPAGE="http://www.xfree.org"

DEPEND=">=sys-libs/ncurses-5.1
        >=sys-libs/zlib-1.1.3-r2
        sys-devel/flex
        sys-devel/perl"
	
RDEPEND=">=sys-libs/ncurses-5.1"

PROVIDE="virtual/x11
	virtual/opengl
	virtual/glu"	

src_unpack () {

	unpack X${MY_V}src-{1,2,3}.tgz
	
	cd ${S}
	cp ${FILESDIR}/${PVR}/site.def config/cf/host.def
	echo "#define DefaultGcc2i386Opt ${CFLAGS}" >>  config/cf/host.def
	echo "#define GccWarningOptions -Wno" >>  config/cf/host.def
	echo "#define DefaultCCOptions -ansi" >>  config/cf/host.def

	# fix build problem (XFree86 server among others, was not
	#                    linked against libXau)
	cp ${S}/programs/Xserver/Imakefile \
		${S}/programs/Xserver/Imakefile.orig
	sed -e '2i CCLINK = $(CC) -L../../lib/Xau -lXau' \
		${S}/programs/Xserver/Imakefile.orig \
		> ${S}/programs/Xserver/Imakefile
}

src_compile() {

	emake World || die

	if [ "`use nls`" ]
	then
		cd ${S}/nls
		make || die
		cd ${s}
	fi
}

src_install() {

	make install DESTDIR=${D} || die
	make install.man DESTDIR=${D} || die

	if [ "`use nls`" ]
	then
		cd ${S}/nls
		make DESTDIR=${D} install || die
		cd ${S}
	fi

	#we zap the host.def file which gets hard-coded with our CFLAGS, messing up other things that use xmkmf
	echo > ${D}/usr/X11R6/lib/X11/config/host.def
	#theoretically, /usr/X11R6/lib/X11/config is a possible candidate for config file management.
	#If we find that people really worry about imake stuff, we may add it.  But for now, we leave
	#the dir unprotected.

	insinto /etc/X11
	doins ${FILESDIR}/${PVR}/XftConfig
	dosym ../../../.././etc/X11/XftConfig /usr/X11R6/lib/X11/XftConfig
	cd ${D}/usr/X11R6/lib/X11/fonts
	tar -xz --no-same-owner -f ${DISTDIR}/truetype.tar.gz
	dodir /usr/bin
	dosym /usr/X11R6/bin /usr/bin/X11

	dosym /usr/X11R6/lib/libGL.so.1.2 /usr/X11R6/lib/libMesaGL.so
	dosym /usr/X11R6/lib/libGLU.so.1.3 /usr/lib/libMesaGLU.so

	exeinto /etc/X11
	doexe ${FILESDIR}/${PVR}/chooser.sh
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/${PVR}/Sessions/*
	insinto /etc/env.d
	doins ${FILESDIR}/${PVR}/10xfree
	insinto /etc/X11/xinit
	doins ${FILESDIR}/${PVR}/xinitrc
	exeinto /etc/X11/xdm
	doexe ${FILESDIR}/${PVR}/Xsession ${FILESDIR}/${PVR}/Xsetup_0
	insinto /etc/X11/fs
	newins ${FILESDIR}/${PVR}/xfs.config config
	insinto /etc/pam.d
	doins ${FILESDIR}/${PVR}/xdm
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PVR}/xdm.start xdm
	newexe ${FILESDIR}/${PVR}/xfs.start xfs
}

pkg_preinst() {
	#this changed from a file to a symlink
	rm -rf /usr/X11R6/lib/X11/XftConfig
}
