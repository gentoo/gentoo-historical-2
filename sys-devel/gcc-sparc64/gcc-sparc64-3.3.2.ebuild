# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-sparc64/gcc-sparc64-3.3.2.ebuild,v 1.12 2005/01/11 13:31:56 gustavoz Exp $

inherit flag-o-matic eutils

# Variables
MYARCH="$(echo ${PN} | cut -d- -f2)"
TMP_P="${P/-${MYARCH}/}"
TMP_PN="${PN/-${MYARCH}/}"
I="/usr"


DESCRIPTION="Sparc64 Kernel Compiler (Experimental)"
HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${TMP_P}/${TMP_P}.tar.bz2"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

KEYWORDS="~sparc"
IUSE="build"

DEPEND="virtual/libc
	>=sys-devel/binutils-2.14.90.0.7
	>=sys-devel/gcc-config-1.3.1
	!sys-devel/egcs64-sparc"

RDEPEND="virtual/libc
	>=sys-devel/gcc-config-1.3.1
	>=sys-libs/zlib-1.1.4
	>=sys-apps/texinfo-4.2-r4
	!build? ( >=sys-libs/ncurses-5.2-r2 )"



version_patch() {
	[ ! -f "$1" ] && return 1
	[ -z "$2" ] && return 1

	sed -e "s:@GENTOO@:$2:g" ${1} > ${T}/${1##*/}
	epatch ${T}/${1##*/}
}

src_unpack() {
	unpack ${TMP_P}.tar.bz2
	cd ${WORKDIR}
	ln -s ${TMP_P} ${P}
	cd ${S}

	# Make gcc's version info specific to Gentoo
	if [ -z "${PP_VER}" ]; then
		version_patch ${FILESDIR}/${TMP_P}-gentoo-branding.patch \
			"(Gentoo Linux ${PVR})" || die "Failed Branding"
	fi
}

src_compile() {
	cd ${WORKDIR}
	ln -s ${TMP_P} ${P}

	append-flags "-Dinhibit_libc"

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build

	einfo "Configuring GCC..."
	if [ "`uname -m | grep 64`" ]; then
		myconf="${myconf} --host=${MYARCH/64/}-unknown-linux-gnu"
	fi

	addwrite "/dev/zero"
	${S}/configure --prefix=${I} \
		--disable-shared \
		--disable-multilib \
		--target=${MYARCH}-unknown-linux-gnu \
		--enable-languages=c \
		--enable-threads=single \
		${myconf} || die

	einfo "Building GCC..."
	S="${WORKDIR}/build" \
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	# Do allow symlinks in ${I}/lib/gcc-lib/${CHOST}/${PV}/include as
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
	make prefix=${D}${I} \
		FAKE_ROOT="${D}" \
		install || die

	cd ${D}${I}/bin
	ln -s ${MYARCH}-unknown-linux-gnu-gcc gcc64
	ln -s ${MYARCH}-unknown-linux-gnu-gcc ${MYARCH}-linux-gcc
}

pkg_postinst() {
	einfo ""
	einfo "To facilitate an easier kernel build, you may wish to add the following line to your profile:"
	einfo ""
	einfo "alias ${MYARCH}make=\"make ARCH=${MYARCH} CROSS_COMPILE=${MYARCH}-unknown-linux-gnu-\""
	einfo ""
	einfo "Then to compile a kernel, simply goto the kernel source directory, and issue:"
	einfo "${MYARCH}make <target>"
	einfo "Where <target> is one of the usual kernel targets"
	einfo ""
	epause 10
}
