# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-3.4.2.ebuild,v 1.3 2001/10/27 14:18:30 agriffis Exp $

P=Mesa-${PV}
S=${WORKDIR}/${P}
DESCRIPTION="OpenGL like graphic library for Linux"
SRC_URI="http://download.sourceforge.net/mesa3d/MesaLib-${PV}.tar.bz2
         http://download.sourceforge.net/mesa3d/MesaDemos-${PV}.tar.bz2"
HOMEPAGE="http://mesa3d.sourceforge.net/"

DEPEND="virtual/glibc
        X? ( virtual/x11 )
        ggi? ( >=media-libs/libggi-2.0_beta3 )
        svga? ( >=media-libs/svgalib-1.4.2-r1 )"

if [ "`use X`" ]
then
	PROVIDE="virtual/opengl virtual/glu virtual/glut"
else
	PROVIDE="virtual/opengl"
fi

src_compile() {
	local myconf

	if [ "`use mmx`" ]
	then
		myconf="--enable-mmx"
	else
		myconf="--disable-mmx"
	fi

	if [ "`use 3dnow`" ]
	then
		myconf="${myconf} --enable-3dnow"
	else
		myconf="${myconf} --disable-3dnow"
	fi

	if [ "`use sse`" ]
	then
		myconf="${myconf} --enable-sse"
	else
		myconf="${myconf} --disable-sse"
	fi

	if [ "`use X`" ]
	then
		myconf="${myconf} --with-x --without-glut"
		# --without-glut means that mesa is forced to use and install
		# his own version of glut.
	else
		myconf="${myconf} --without-x"
		rm -rf src-glut
	fi

	if [ -z "`use ggi`" ] || [ -z "`use fbcon`" ]
	then
		myconf="${myconf} --disable-ggi-fbdev --without-ggi"
	fi

	if [ -z "`use svga`" ]
	then
		myconf="${myconf} --without-svga"
	fi

	cp configure configure.orig
	sed -e "s:^ggi_confdir.*:ggi_confdir=/etc/ggi:" \
		-e "s:^ggi_libdir.*:ggi_libdir=\$prefix/lib:" \
		configure.orig > configure

	./configure --prefix=/usr --sysconfdir=/etc/mesa --host=${CHOST} $myconf \
		|| die

	if [ "`use ggi`" ] && [ "`use fbcon`" ]
	then
		cd ${S}/src/GGI
		cp Makefile Makefile.orig
		sed -e "s:^ggimesaconfdatadir.*:ggimesaconfdatadir = \${ggi_confdir}:" \
			Makefile.orig > Makefile

		cd ${S}/src/GGI/default
		cp stubs.c stubs.c.orig
		sed -e "s:Texture.Enabled:Texture.ReallyEnabled:" stubs.c.orig > stubs.c

		cd ${S}/src/GGI/include/ggi/mesa
		cp display_fbdev.h display_fbdev.h.orig
		sed -e "s:fbdev_hook:ggi_fbdev_priv:" display_fbdev.h.orig > display_fbdev.h

		cd ${S}
		mkdir gg
		ln -s /usr/lib/libgg*.so .
	fi

	make || die
	# Don't worry about errors or failures in making the demos
	cd ${S}/demos; for f in *.c; do make "${f%.c}"; done
	cd ${S}/xdemos; for f in *.c; do make "${f%.c}"; done

	if [ "`use ggi`" ]
	then
		cd ${S}/ggi/ggiglut
		make libglut_la_LIBADD="-lggi -lgg -L${S}/src/.libs -lGL" \
			|| die
	fi
}

src_install () {
	if [ "`use ggi`" ]
	then
	  cd ggi/ggiglut
	  make DESTDIR=${D} install || die
	  cd ${D}/usr/lib
	  cp libglut.la libglut.orig
	  sed -e "s:-L${S}/src/.libs::g" libglut.orig > libglut.la
	  rm libglut.orig
	fi
	cd ${S}
	make DESTDIR=${D} install || die
	cd ${D}/usr/lib
	if [ "$PN" = "mesa-glu" ]
	then
		rm -f libGL.*
		rm -f ../include/GL/gl.h
		rm -f ../include/GL/glx.h
		rm -f ../include/GL/osmesa.h
	else
		ln -s libGL.so.2.1.030402 libMesaGL.so.3
	fi
	ln -s libGLU.so.1.1.030402 libMesaGLU.so.3

	cd ${S}
	dodoc docs/*

	# Install any demos that successfully built
	for d in demos xdemos; do
		exeinto /usr/lib/mesa-$PV/$d
		cd ${S}/$d
		for f in *.c; do [ -f "${f%.c}" ] && doexe "${f%.c}"; done
	done
}
