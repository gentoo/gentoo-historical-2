# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-2.95.3-r8.ebuild,v 1.10 2002/12/23 17:49:58 azarah Exp $

IUSE="static nls bootstrap java build"

inherit eutils flag-o-matic gcc

# Compile problems with these (bug #6641 among others)...
filter-flags "-fno-exceptions -fomit-frame-pointer"

# Recently there has been a lot of stability problem in Gentoo-land.  Many
# things can be the cause to this, but I believe that it is due to gcc3
# still having issues with optimizations, or with it not filtering bad
# combinations (protecting the user maybe from himeself) yet.
#
# This can clearly be seen in large builds like glibc, where too aggressive
# CFLAGS cause the tests to fail miserbly.
#
# Quote from Nick Jones <carpaski@gentoo.org>, who in my opinion
# knows what he is talking about:
#
#   People really shouldn't force code-specific options on... It's a
#   bad idea. The -march options aren't just to look pretty. They enable
#   options that are sensible (and include sse,mmx,3dnow when apropriate).
#
# The next command strips CFLAGS and CXXFLAGS from nearly all flags.  If
# you do not like it, comment it, but do not bugreport if you run into
# problems.
#
# <azarah@gentoo.org> (13 Oct 2002)
strip-flags

# Are we trying to compile with gcc3 ?  CFLAGS and CXXFLAGS needs to be
# valid for gcc-2.95.3 ...
gcc2_flags

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

LOC="/usr"
MY_PV="`echo ${PV} | awk -F. '{ gsub(/_pre.*|_alpha.*/, ""); print $1 "." $2 }'`"
MY_PV_FULL="`echo ${PV} | awk '{ gsub(/_pre.*|_alpha.*/, ""); print $0 }'`"

LIBPATH="${LOC}/lib/gcc-lib/${CCHOST}/${MY_PV_FULL}"
BINPATH="${LOC}/${CCHOST}/gcc-bin/${MY_PV}"
DATAPATH="${LOC}/share/gcc-data/${CCHOST}/${MY_PV}"
# Dont install in /usr/include/g++/, but in gcc internal directory.
# We will handle /usr/include/g++/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++"

S="${WORKDIR}/${P}"
DESCRIPTION="Modern C/C++ compiler written by the GNU people"
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${P}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

# Ok, this is a hairy one again, but lets assume that we
# are not cross compiling, than we want SLOT to only contain
# $PV, as people upgrading to new gcc layout will not have
# their old gcc unmerged ...
if [ "${CHOST}" == "${CCHOST}" ]
then
	SLOT="${MY_PV}"
else
	SLOT="${CCHOST}-${MY_PV}"
fi

DEPEND="virtual/glibc
	>=sys-devel/gcc-config-1.2
	!build? ( >=sys-libs/ncurses-5.2-r2
	          nls? ( sys-devel/gettext ) )"
			  
RDEPEND="virtual/glibc
	>=sys-devel/gcc-config-1.2.3
	>=sys-libs/zlib-1.1.4
	>=sys-apps/texinfo-4.2-r4
	!build? ( >=sys-libs/ncurses-5.2-r2 )"


# Hack used to patch Makefiles to install into the build dir
FAKE_ROOT=""

pkg_setup() {
	echo
	eerror "This is a very alpha ebuild and changes in here"
	eerror "are not yet set in stone!  Please do NOT merge"
	eerror "this if you are not a developer!"
#	die
}

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	# Fixup libtool to correctly generate .la files with portage
	libtoolize --copy --force &> /dev/null

	# This new patch for the atexit problem occured with glibc-2.2.3 should
	# work with glibc-2.2.4.  This closes bug #3987 and #4004.
	#
	# Azarah - 29 Jun 2002
	#
	# http://archive.linuxfromscratch.org/mail-archives/lfs-dev/2001/08/0476.html
	# http://archive.linuxfromscratch.org/mail-archives/lfs-dev/2001/08/0589.html
	#
	#
	# Something to note, is that this patch makes gcc crash if its given
	# the "-mno-ieee-fp" flag ... libvorbis is an good example of this.
	# This however is on of those which one we want fixed most cases :/
	#
	# Azarah - 30 Jun 2002
	#
	epatch ${FILESDIR}/${P}-new-atexit.diff

	# Currently if any path is changed via the configure script, it breaks
	# installing into ${D}.  We should not patch it in src_install() with
	# absolute paths, as some modules then gets rebuild with the wrong
	# paths.  Thus we use $FAKE_ROOT.
	cd ${S}
	for x in $(find . -name Makefile.in)
	do
		# Fix --datadir=
		cp ${x} ${x}.orig
		sed -e 's:datadir = @datadir@:datadir = $(FAKE_ROOT)@datadir@:' \
			${x}.orig > ${x}
		
		# Fix --bindir=
		cp ${x} ${x}.orig
		sed -e 's:bindir = @bindir@:bindir = $(FAKE_ROOT)@bindir@:' \
			${x}.orig > ${x}
		
		# Fix --with-gxx-include-dir=
		cp ${x} ${x}.orig
		sed -e 's:gxx_include_dir=${includedir}:gxx_include_dir=$(FAKE_ROOT)${includedir}:' \
			${x}.orig > ${x}
		
		rm -f ${x}.orig
	done
}

src_compile() {
	local myconf=""
	if [ -z "`use build`" ]
	then
		myconf="${myconf} --enable-shared"
	else
		myconf="${myconf} --enable-languages=c"
	fi
	if [ -z "`use nls`" ] || [ "`use build`" ]
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls --without-included-gettext"
	fi

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.
	export CFLAGS="${CFLAGS//-O?}"
	export CXXFLAGS="${CXXFLAGS//-O?}"

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build

	einfo "Configuring GCC..."
	addwrite "/dev/zero"
	${S}/configure --prefix=${LOC} \
		--bindir=${BINPATH} \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--enable-shared \
		--host=${CHOST} \
		--target=${CCHOST} \
		--with-system-zlib \
		--enable-threads=posix \
		--enable-long-long \
		--enable-version-specific-runtime-libs \
		--with-local-prefix=${LOC}/local \
		${myconf} || die

	touch ${S}/gcc/c-gperf.h
	
	# Setup -j in MAKEOPTS
	get_number_of_jobs

	einfo "Building GCC..."
	if [ -z "`use static`" ]
	then
		# Fix for our libtool-portage.patch
		S="${WORKDIR}/build" \
		emake bootstrap-lean \
			LIBPATH="${LIBPATH}" STAGE1_CFLAGS="-O" || die
		# Above FLAGS optimize and speedup build, thanks
		# to Jeff Garzik <jgarzik@mandrakesoft.com>
	else
		S="${WORKDIR}/build" \
		emake LDFLAGS=-static bootstrap \
			LIBPATH="${LIBPATH}" STAGE1_CFLAGS="-O" || die
	fi
}

src_install() {
	# Do allow symlinks in ${LOC}/lib/gcc-lib/${CHOST}/${PV}/include as
	# this can break the build.
	for x in cd ${WORKDIR}/build/gcc/include/*
	do
		if [ -L ${x} ]
		then
			rm -f ${x}
		fi
	done

	einfo "Installing GCC..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build
	S="${WORKDIR}/build" \
	make prefix=${D}${LOC} \
		bindir=${D}${BINPATH} \
		datadir=${D}${DATAPATH} \
		mandir=${D}${DATAPATH}/man \
		infodir=${D}${DATAPATH}/info \
		LIBPATH="${LIBPATH}" \
		FAKE_ROOT="${D}" \
		install || die
	
	[ -r ${D}${BINPATH}/gcc ] || die "gcc not found in ${D}"
	
	dodir /lib /usr/bin
	dodir /etc/env.d/gcc
	echo "PATH=\"${BINPATH}\"" > ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "ROOTPATH=\"${BINPATH}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "LDPATH=\"${LIBPATH}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "MANPATH=\"${DATAPATH}/man\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "INFOPATH=\"${DATAPATH}/info\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "STDCXX_INCDIR=\"${STDCXX_INCDIR##*/}\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	# Also set CC and CXX
	echo "CC=\"gcc\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	echo "CXX=\"g++\"" >> ${D}/etc/env.d/gcc/${CCHOST}-${MY_PV_FULL}
	
	# Install wrappers
	exeinto /lib
	doexe ${FILESDIR}/cpp
	exeinto /usr/bin
	doexe ${FILESDIR}/cc
	
	# Make sure we dont have stuff lying around that
	# can nuke multiple versions of gcc
	if [ -z "`use build`" ]
	then
		cd ${D}${LIBPATH}

		# Tell libtool files where real libraries are
		for LA in ${D}${LOC}/lib/*.la ${D}${LIBPATH}/../*.la
		do
			if [ -f ${LA} ]
			then
				sed -e "s:/usr/lib:${LIBPATH}:" ${LA} > ${LA}.hacked
				mv ${LA}.hacked ${LA}
				mv ${LA} ${D}${LIBPATH}
			fi
		done

		# Move all the libraries to version specific libdir.
		for x in ${D}${LOC}/lib/*.{so,a}* ${D}${LIBPATH}/../*.{so,a}*
		do
			[ -f ${x} ] && mv -f ${x} ${D}${LIBPATH}
		done

		# These should be symlinks
		cd ${D}${BINPATH}
		rm -f ${CCHOST}-{gcc,g++,c++,g77}
		[ -f gcc ] && ln -sf gcc ${CCHOST}-gcc
		[ -f g++ ] && ln -sf g++ ${CCHOST}-g++
		[ -f g++ ] && ln -sf g++ ${CCHOST}-c++
		[ -f g77 ] && ln -sf g77 ${CCHOST}-g77
	fi

	# This one comes with binutils
	if [ -f ${D}${LOC}/lib/libiberty.a ]
	then
		rm -f ${D}${LOC}/lib/libiberty.a
	fi

	cd ${S}
    if [ -z "`use build`" ]
    then
		cd ${S}
		docinto /       
		dodoc COPYING COPYING.LIB README* FAQ MAINTAINERS
		docinto html
		dodoc faq.html
		docinto gcc
		cd ${S}/gcc
		dodoc BUGS ChangeLog* COPYING* FSFChangeLog* LANGUAGES NEWS PROBLEMS README* SERVICE TESTS.FLUNK
		cd ${S}/libchill
		docinto libchill
		dodoc ChangeLog
		cd ${S}/libf2c
		docinto libf2c
		dodoc ChangeLog changes.netlib README TODO
		cd ${S}/libio
		docinto libio
		dodoc ChangeLog NEWS README
		cd dbz
		docinto libio/dbz
		dodoc README
		cd ../stdio
		docinto libio/stdio
		dodoc ChangeLog*
		cd ${S}/libobjc
		docinto libobjc
		dodoc ChangeLog README* THREADS*
		cd ${S}/libstdc++
		docinto libstdc++
		dodoc ChangeLog NEWS
    else
        rm -rf ${D}/usr/share/{man,info}
	fi
}

pkg_postinst() {

	if [ "${ROOT}" = "/" -a "${COMPILER}" != "gcc3" -a "${CHOST}" == "${CCHOST}" ]
	then
		gcc-config --use-portage-chost ${CCHOST}-${MY_PV_FULL}
	fi
}

