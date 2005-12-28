# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-mips64/gcc-mips64-3.4.4.ebuild,v 1.4 2005/12/28 17:51:30 kumba Exp $

inherit eutils flag-o-matic

# Variables 
MYARCH="$(echo ${PN} | cut -d- -f2)"
TMP_P="${P/-${MYARCH}/}"
TMP_PN="${PN/-${MYARCH}/}"
I="/usr"
BRANCH_UPDATE=""

DESCRIPTION="Mips64 Kernel Compiler (Experimental)"
HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"

SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/${TMP_P}/${TMP_P}.tar.bz2"
#	mirror://gentoo/${TMP_P}-branch-update-${BRANCH_UPDATE}.patch.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE=""

KEYWORDS="mips"

DEPEND="virtual/libc
	>=sys-devel/binutils-2.14.90.0.7
	>=sys-devel/gcc-config-1.3.1"

RDEPEND="virtual/libc
	>=sys-devel/gcc-config-1.3.1
	>=sys-libs/zlib-1.1.4
	>=sys-apps/texinfo-4.2-r4
	!build? ( >=sys-libs/ncurses-5.2-r2 )"

# Ripped from toolchain.eclass
gcc_version_patch() {
	[ -z "$1" ] && die "no arguments to gcc_version_patch"

	sed -i -e 's~\(const char version_string\[\] = ".....\).*\(".*\)~\1 @GENTOO@\2~' ${S}/gcc/version.c || die "failed to add @GENTOO@"
	sed -i -e "s:@GENTOO@:$1:g" ${S}/gcc/version.c || die "failed to patch version"
	sed -i -e 's~http:\/\/gcc\.gnu\.org\/bugs\.html~http:\/\/bugs\.gentoo\.org\/~' ${S}/gcc/version.c || die "failed to update bugzilla URL"
}

pkg_setup() {
	# glibc or uclibc?
	if use elibc_glibc; then
		MYUSERLAND="gnu"
	elif use elibc_uclibc; then
		MYUSERLAND="uclibc"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	ln -s ${TMP_P} ${P}
	cd ${S}

	# Patch in Branch update
	if [ ! -z "${BRANCH_UPDATE}" ]; then
		epatch ${WORKDIR}/${TMP_P}-branch-update-${BRANCH_UPDATE}.patch
	fi

	# Adds -march=r10000 support to gcc
	epatch ${FILESDIR}/gcc-3.4.x-mips-add-march-r10k.patch

	# Allows building of kernels for IP28 systems (enable w/ -mip28-cache-barrier)
	epatch ${FILESDIR}/gcc-3.4.2-mips-ip28_cache_barriers-v2.patch

	# Make gcc's version info specific to Gentoo
	gcc_version_patch "(Gentoo Linux ${PVR})"
}

src_compile() {
	local userland
	cd ${WORKDIR}
	ln -s ${TMP_P} ${P}

	append-flags "-Dinhibit_libc"

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build

	einfo "Configuring GCC..."
	if [ "`uname -m | grep 64`" ]; then
		myconf="${myconf} --host=${MYARCH/64/}-unknown-linux-${MYUSERLAND}"
	fi

	addwrite "/dev/zero"
	${S}/configure --prefix=${I} \
		--disable-shared \
		--disable-multilib \
		--target=${MYARCH}-unknown-linux-${MYUSERLAND} \
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
	ln -s ${MYARCH}-unknown-linux-${MYUSERLAND}-gcc gcc64
	ln -s ${MYARCH}-unknown-linux-${MYUSERLAND}-gcc ${MYARCH}-linux-gcc
}

pkg_postinst() {
	einfo ""
	einfo "To facilitate an easier kernel build, you may wish to add the following line to your profile:"
	einfo ""
	einfo "For 2.4.x kernel builds:"
	einfo "alias ${MYARCH}make=\"make ARCH=${MYARCH} CROSS_COMPILE=${MYARCH}-unknown-linux-${MYUSERLAND}-\""
	einfo ""
	einfo "For 2.6.x kernel builds:"
	einfo "alias ${MYARCH}make=\"make ARCH=${MYARCH/64/} CROSS_COMPILE=${MYARCH}-unknown-linux-${MYUSERLAND}-\""
	einfo ""
	einfo "Then to compile a kernel, simply goto the kernel source directory, and issue:"
	einfo "${MYARCH}make <target>"
	einfo "Where <target> is one of the usual kernel targets"
	einfo ""
	epause 10
}
