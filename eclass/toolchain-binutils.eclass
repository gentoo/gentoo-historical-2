# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/toolchain-binutils.eclass,v 1.7 2004/11/23 20:07:52 vapier Exp $

# We install binutils into CTARGET-VERSION specific directories.  This lets 
# us easily merge multiple versions for multiple targets (if we wish) and 
# then switch the versions on the fly (with `binutils-config`).

inherit eutils libtool flag-o-matic gnuconfig
ECLASS=toolchain-binutils
INHERITED="$INHERITED $ECLASS"
EXPORT_FUNCTIONS src_unpack src_compile src_test src_install pkg_postinst

export CTARGET="${CTARGET:-${CHOST}}"

DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="http://sources.redhat.com/binutils/"
SRC_URI="mirror://kernel/linux/devel/binutils/${P}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/${P}.tar.bz2"
[ -n "${PATCHVER}" ] && \
	SRC_URI="${SRC_URI} mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"
[ -n "${UCLIBC_PATCHVER}" ] && \
	SRC_URI="${SRC_URI} mirror://gentoo/${P}-uclibc-patches-${UCLIBC_PATCHVER}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
IUSE="nls bootstrap build multitarget uclibc multislot"
use multislot \
	&& SLOT="${CTARGET}-${PV}" \
	|| SLOT="${CTARGET}"

DEPEND="virtual/libc
	nls? ( sys-devel/gettext )
	sys-devel/binutils-config
	!build? ( !bootstrap? ( dev-lang/perl ) )"

LIBPATH="/usr/lib/${PN}/${CTARGET}/${PV}"
INCPATH="${LIBPATH}/include"
BINPATH="/usr/${CTARGET}/binutils-bin/${PV}"
DATAPATH="/usr/share/${PN}-data/${CTARGET}/${PV}"
MY_BUILDDIR="${WORKDIR}/build"

is_cross() { [ "${CHOST}" != "${CTARGET}" ] ; }

toolchain-binutils_src_unpack() {
	unpack ${A}
	mkdir -p "${MY_BUILDDIR}"
}

apply_binutils_updates() {
	cd ${S}

	[ -n "${PATCHVER}" ] && epatch ${WORKDIR}/patch
	[ -n "${UCLIBC_PATCHVER}" ] && epatch ${WORKDIR}/uclibc-patches

	# Run misc portage update scripts
	gnuconfig_update
	elibtoolize --portage --no-uclibc

	strip-linguas -i */po
}

toolchain-binutils_src_compile() {
	filter-flags -fomit-frame-pointer -fssa #6730
	strip-flags && replace-flags -O3 -O2 #47581

	cd "${MY_BUILDDIR}"
	local myconf=""
	use nls \
		&& myconf="${myconf} --without-included-gettext" \
		|| myconf="${myconf} --disable-nls"
	use multitarget && myconf="${myconf} --enable-targets=all"
	[ -n "${CBUILD}" ] && myconf="${myconf} --build=${CBUILD}"
	${S}/configure \
		--prefix=/usr \
		--host=${CHOST} \
		--target=${CTARGET} \
		--datadir=${DATAPATH} \
		--infodir=${DATAPATH}/info \
		--mandir=${DATAPATH}/man \
		--bindir=${BINPATH} \
		--libdir=${LIBPATH} \
		--libexecdir=${LIBPATH} \
		--includedir=${INCPATH} \
		--enable-shared \
		--enable-64-bit-bfd \
		${myconf} ${EXTRA_ECONF} || die

	make configure-bfd || die "configure-bfd"
	make headers -C bfd || die "headers-bfd"
	emake all || die "emake"

	if ! use build ; then
		if ! has noinfo ${FEATURES} ; then
			# Make the info pages (makeinfo included with gcc is used)
			make info || die "info"
		fi
		if ! use bootstrap && ! has noman ${FEATURES} ; then
			cd "${S}"
			# Nuke the manpages to recreate them (only use this if we have perl)
			find . -name '*.1' -exec rm -f {} \; || :
		fi
	fi
}

toolchain-binutils_src_test() {
	emake check
}

toolchain-binutils_src_install() {
	local x d

	cd "${MY_BUILDDIR}"
	make DESTDIR="${D}" tooldir="${LIBPATH}" install || die
	rm -rf "${D}"/${LIBPATH}/bin

	# Now we collect everything intp the proper SLOT-ed dirs
	# When something is built to cross-compile, it installs into
	# /usr/$CHOST/ by default ... we have to 'fix' that :)
	if is_cross ; then
		cd "${D}"/${BINPATH}
		for x in * ; do
			mv ${x} ${x/${CTARGET}-}
		done

		mv "${D}"/usr/${CHOST}/${CTARGET}/include "${D}"/${INCPATH}
		mv "${D}"/usr/${CHOST}/${CTARGET}/lib/* "${D}"/${LIBPATH}/
		rm -r "${D}"/usr/${CHOST}
	else
		insinto ${INCPATH}
		doins "${S}/include/libiberty.h"
	fi
	mv "${D}"/${LIBPATH}/lib/* "${D}"/${LIBPATH}/
	rm -r "${D}"/${LIBPATH}/lib

	# Now we generate all the standard links to binaries ...
	# if this is a native package, we install the basic symlinks (ld,nm,as,etc...)
	# in addition to the ${CTARGET}-{ld,nm,as,etc...} symlinks
	cd "${D}"/${BINPATH}
	dodir /usr/bin
	for x in * ; do
		dosym ../${CTARGET}/bin/${x} /usr/bin/${CTARGET}-${x}
		is_cross || dosym ${CTARGET}-${x} /usr/bin/${x}
	done

	# Generate an env.d entry for this binutils
	cd ${S}
	insinto /etc/env.d/binutils
	cat << EOF > env.d
TARGET="${CTARGET}"
VER="${PV}"
EOF
	newins env.d ${CTARGET}-${PV}

	# Handle documentation
	if ! use build && ! is_cross ; then
		cd "${S}"
		dodoc README
		docinto bfd
		dodoc bfd/ChangeLog* bfd/README bfd/PORTING bfd/TODO
		docinto binutils
		dodoc binutils/ChangeLog binutils/NEWS binutils/README
		docinto gas
		dodoc gas/ChangeLog* gas/CONTRIBUTORS gas/NEWS gas/README*
		docinto gprof
		dodoc gprof/ChangeLog* gprof/TEST gprof/TODO gprof/bbconv.pl
		docinto ld
		dodoc ld/ChangeLog* ld/README ld/NEWS ld/TODO
		docinto libiberty
		dodoc libiberty/ChangeLog* libiberty/README
		docinto opcodes
		dodoc opcodes/ChangeLog*
	fi
}

toolchain-binutils_pkg_postinst() {
	binutils-config ${CTARGET}-${PV}
}
