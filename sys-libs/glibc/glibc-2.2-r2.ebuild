# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-2.2-r2.ebuild,v 1.5 2000/11/30 23:14:00 achim Exp $

A="$P.tar.gz glibc-linuxthreads-${PV}.tar.gz"
S=${WORKDIR}/${P}
DESCRIPTION="GNU libc6 (also called glibc2) C library"
SRC_URI="ftp://sourceware.cygnus.com/pub/glibc/releases/glibc-${PV}.tar.gz
	 ftp://sourceware.cygnus.com/pub/glibc/releases/glibc-linuxthreads-${PV}.tar.gz
	 ftp://ftp.unina.it/pub/Unix/cygnus/glibc/releases/glibc-${PV}.tar.gz
	 ftp://ftp.unina.it/pub/Unix/cygnus/glibc/releases/glibc-linuxthreads-${PV}.tar.gz
	 ftp://ftp.gnu.org/pub/gnu/glibc/glibc-${PV}.tar.gz
	 ftp://ftp.gnu.org/pub/gnu/glibc/glibc-linuxthreads-${PV}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/libc/libc.html"
DEPEND=""
RDEPEND="$DEPEND
	 >=sys-apps/bash-2.04
	 >=sys-devel/perl-5.6"

src_compile() {                           

        rm -rf buildhere
	mkdir buildhere
	cd buildhere
	try ../configure --host=${CHOST} --without-cvs \
		--enable-add-ons=linuxthreads \
		--disable-profile --prefix=/usr \
		--enable-kernel=2.2.17
	try make PARALLELMFLAGS=${MAKEOPTS}
#	make check
}

src_unpack() {
    unpack glibc-${PV}.tar.gz
    cd ${S}
    unpack glibc-linuxthreads-${PV}.tar.gz
    patch -p1 < ${FILESDIR}/glibc-2.2-ldconfig.patch
}

src_install() {
    cd ${S}
    rm -rf ${D}
    mkdir ${D}	
    dodir /etc/rc.d/init.d
    export LC_ALL=C
    try make PARALELLMFLAGS=${MAKEOPTS} install_root=${D} install -C buildhere
    try make PARALELLMFLAGS=${MAKEOPTS} install_root=${D} info -C buildhere
    try make PARALELLMFLAGS=${MAKEOPTS} install_root=${D} localedata/install-locales -C buildhere
    try make  PARALELLMFLAGS=${MAKEOPTS} -C linuxthreads/man
    mkdir -p ${D}/usr/man/man3
    install -m 0644 linuxthreads/man/*.3thr ${D}/usr/man/man3
    chmod 755 ${D}/usr/libexec/pt_chown
    install -m 644 nscd/nscd.conf ${D}/etc
    install -m 755 ${O}/files/nscd ${D}/etc/rc.d/init.d/nscd
    rm ${D}/lib/ld-linux.so.2
    rm ${D}/lib/libc.so.6

    dodoc BUGS ChangeLog* CONFORMANCE COPYING* FAQ INTERFACE NEWS NOTES \
	  PROJECTS README*
}

pkg_preinst()
{
  echo "Saving ld-linux and libc6"

  cp ${ROOT}lib/ld-linux.so.2 ${ROOT}tmp
  sln ${ROOT}tmp/ld-linux.so.2 ${ROOT}lib/ld-linux.so.2
  cp ${ROOT}lib/libc.so.6 ${ROOT}tmp
  sln ${ROOT}tmp/libc.so.6 ${ROOT}lib/libc.so.6

	if [ -e ${ROOT}etc/localtime ]
	then
		#keeping old timezone
		rm ${D}/etc/localtime
	else
		echo "Please remember to set your timezone using the zic command."
	fi
}

pkg_postinst()
{
  echo "Setting ld-linux and libc6"

  sln ${ROOT}lib/ld-2.2.so ${ROOT}lib/ld-linux.so.2
  sln ${ROOT}lib/libc-2.2.so ${ROOT}lib/libc.so.6
  rm  ${ROOT}tmp/ld-linux.so.2
  rm  ${ROOT}tmp/libc.so.6
  ldconfig -r ${ROOT}
}


