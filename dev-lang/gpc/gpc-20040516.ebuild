# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gpc/gpc-20040516.ebuild,v 1.4 2004/06/24 22:49:46 agriffis Exp $

inherit eutils flag-o-matic

strip-flags
filter-flags "-pipe"

#due to cache requirements we cannot dynamically match gcc version
#so sticking to a particular (and working) one
GCC_PV="3.3.3"

DESCRIPTION="Gnu Pascal Compiler"
HOMEPAGE="http://gnu-pascal.de"
SRC_URI="http://gnu-pascal.de/beta/${P}.tar.gz
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.bz2"
#only need gcc-core (smaller download), but user will likely have this one already

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64"
IUSE="nls"

DEPEND="virtual/glibc
		=sys-devel/gcc-${GCC_PV}*"

S="${WORKDIR}/gcc-${GCC_PV}"

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

LOC="/usr"
#GCC_PVR=$(emerge -s gcc|grep "installed: 3.2"|cut -d ':' -f 2)
LIBPATH="${LOC}/lib/gcc-lib/${CCHOST}/${GCC_PV}"
#BINPATH="${LOC}/${CCHOST}/gcc-bin/${GCC_PV}"
DATAPATH="${LOC}/share"
# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++-v${MY_PV/\.*/}"

src_unpack() {
	unpack ${A}
#	unpack "${P}.tar.gz"
#	unpack "gcc-${GCC_PV}.tar.bz2"

	cd "${WORKDIR}/${P}/p"

	#comment out read to let ebuild continue 
	sed -i -e "s:read:#read:"  config-lang.in || die "seding autoreplies failed"
	#and remove that P var (it doesn't seem to do much but to fail inside the ebuild)
	sed -i -e "s:\$(P)::" Make-lang.in || die "seding Make-lan.in failed"

	cd "${WORKDIR}/${P}"
	mv p "${S}/gcc/"

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
}

src_compile() {
	local myconf

	if ! use nls
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls --without-included-gettext"
	fi

	#Makefiles seems to use ${P} internally, need to wrap around
#	SAVEP="${P}"
#	unset P

	cd ${WORKDIR}/build

	einfo "Configuring GCC for GPC build..."
	addwrite "/dev/zero"
	${S}/configure --prefix=${LOC} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--enable-shared \
		--host=${CHOST} \
		--target=${CCHOST} \
		--with-system-zlib \
		--enable-languages=pascal \
		--enable-threads=posix \
		--enable-long-long \
		--disable-checking \
		--disable-libunwind-exceptions \
		--enable-cstdio=stdio \
		--enable-clocale=generic \
		--enable-__cxa_atexit \
		--enable-version-specific-runtime-libs \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--with-local-prefix=${LOC}/local \
		${myconf} || die "configure failed"

	touch ${S}/gcc/c-gperf.h

	einfo "Building GPC..."
	# Fix for our libtool-portage.patc
	S="${WORKDIR}/build" emake -j1 LIBPATH="${LIBPATH}" || die "make failed"

#	P="${SAVEP}"
}

src_install () {
	# Do not allow symlinks in ${LOC}/lib/gcc-lib/${CHOST}/${PV}/include as
	# this can break the build.
	for x in cd ${S}/gcc/include/*
	do
	if [ -L ${x} ]
	then
		rm -f ${x}
	fi
	done

	einfo "Installing GPC..."

#	SAVEP="${P}"
#	unset P

	cd ${WORKDIR}/build

	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		FAKE_ROOT="${D}" \
		install || die

	#now for the true magic :)
	#gpc is based on gcc and therefore rebuilds gcc backend when compiled
	#we do not want to overwrite it, do we? (even though the binaries are supposed to be the same)
	#so do a dirty hack:
	#go in to the image dir and delete everything inappropriate

	cd ${D}/usr/

	mv bin bin.orig
	mkdir bin
	mv bin.orig/gpc* bin
	rm -rf bin.orig

	#now lib
	cd ${D}/usr/lib/
	rm libiberty.a

	cd ${D}/usr/lib/gcc-lib/${CHOST}/
	mv ${GCC_PV} ${GCC_PV}.orig
	mkdir ${GCC_PV}
	mv ${GCC_PV}.orig/{gpc1,gpcpp,libgpc.a,units} ${GCC_PV}
	mkdir ${GCC_PV}/include
	#mv ${GCC_PV}.orig/include/{gpc-in-c.h,curses.h,mm.h,ncurses.h} ${GCC_PV}/include/
	mv ${GCC_PV}.orig/include/gpc-in-c.h ${GCC_PV}/include/
	rm -rf ${GCC_PV}.orig


	# Install documentation.
	#gpc wants to install some files and a lot of demos under /usr/doc
	#lets move it under /usr/share/doc
	#(Ok, this is not the most buitiful way to do it, but it seems to be the easiest here :))
	cd ${D}/usr/doc
	mkdir -p ${D}/usr/share/doc/${PF}
	mv gpc/* ${D}/usr/share/doc/${PF}
	cd ${D}/usr/share/doc/${PF}
	for fn in *; do [ -f $fn ] && gzip $fn; done

	#clean-up info pages
	cd ${D}/usr/share/info
	rm -rf cpp* gcc*

	#final clean up
	cd ${D}/usr/
	rm -rf doc
	rmdir include
	rm -rf share/locale

}
