# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.15.92.0.2-r1.ebuild,v 1.20 2004/12/14 07:51:12 eradicator Exp $

inherit eutils libtool flag-o-matic gnuconfig

PATCHVER="1.2"
UCLIBC_PATCHVER="1.0"
DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="http://sources.redhat.com/binutils/"
SRC_URI="mirror://kernel/linux/devel/binutils/${P}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/${P}.tar.bz2
	mirror://gentoo/${PN}-${PV:0:4}-uclibc-patches-${UCLIBC_PATCHVER}.tar.bz2
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm hppa ~ia64 ~x86 ~sparc"
IUSE="nls bootstrap build multitarget uclibc"

DEPEND="virtual/libc
	nls? ( sys-devel/gettext )
	!build? ( !bootstrap? ( dev-lang/perl ) )"

src_unpack() {
	unpack ${A}

	cd ${S}

	mkdir -p ${WORKDIR}/patch/skip
	mv ${WORKDIR}/patch/*no_rel_ro* ${WORKDIR}/patch/20_* ${WORKDIR}/patch/*ldsoconf* ${WORKDIR}/patch/skip/

	epatch ${WORKDIR}/patch
	epatch ${WORKDIR}/uclibc-patches

	# Libtool is broken (Redhat).
	for x in ${S}/opcodes/Makefile.{am,in}
	do
		cp ${x} ${x}.orig
		gawk '
			{
				if ($0 ~ /LIBADD/)
					gsub("../bfd/libbfd.la", "-L../bfd/.libs ../bfd/libbfd.la")
					print
			}' ${x}.orig > ${x}
		rm -rf ${x}.orig
	done

	gnuconfig_update
}

src_compile() {
	strip-linguas -i */po #42033

	# Generate borked binaries.  Bug #6730
	filter-flags -fomit-frame-pointer -fssa
	# Filter CFLAGS=".. -O2 .." on arm
	use arm && replace-flags -O? -O
	# GCC 3.4 miscompiles binutils unless CFLAGS are conservative #47581
	strip-flags && replace-flags -O3 -O2

	local myconf=
	[ ! -z "${CBUILD}" ] && myconf="--build=${CBUILD}"
	use nls \
		&& myconf="${myconf} --without-included-gettext" \
		|| myconf="${myconf} --disable-nls"
	use multitarget && myconf="${myconf} --enable-targets=all"

	# Fix /usr/lib/libbfd.la
	elibtoolize --portage --no-uclibc

	./configure \
		--enable-shared \
		--enable-64-bit-bfd \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--host=${CHOST} \
		${myconf} \
		|| die

	make configure-bfd || die
	make headers -C bfd || die
	emake tooldir="${ROOT}/usr/bin" all || die

	if ! use build
	then
		if ! use bootstrap
		then
			# Nuke the manpages to recreate them (only use this if we have perl)
			find . -name '*.1' -exec rm -f {} \; || :
		fi
		# Make the info pages (makeinfo included with gcc is used)
		make info || die
	fi
}

src_test() {
	emake check
}

src_install() {
	make DESTDIR=${D} \
		install || die

	insinto /usr/include
	doins include/libiberty.h

	# c++filt is included with gcc -- what are these GNU people thinking?
	# but not the manpage, so leave that!
# We install it now, as gcc-3.3 do not have it any longer ...
#	rm -f ${D}/usr/bin/c++filt #${D}/usr/share/man/man1/c++filt*

	# By default strip has a symlink going from /usr/${CHOST}/bin/strip to
	# /usr/bin/strip we should reverse it:

	rm ${D}/usr/${CHOST}/bin/strip; mv ${D}/usr/bin/strip ${D}/usr/${CHOST}/bin/strip
	# The strip symlink gets created in the loop below

	# By default ar, as, ld, nm, ranlib and strip are in two places; create
	# symlinks.  This will reduce the size of the tbz2 significantly.  We also
	# move all the stuff in /usr/bin to /usr/${CHOST}/bin and create the
	# appropriate symlinks.  Things are cleaner that way.
	cd ${D}/usr/bin
	local x=
	for x in * strip
	do
	if [ ! -e ../${CHOST}/bin/${x} ]
		then
			mv ${x} ../${CHOST}/bin/${x}
		else
			rm -f ${x}
		fi
		ln -s ../${CHOST}/bin/${x} ${x}
	done

	if [ -n "${PROFILE_ARCH}" ]; then
		if [ "${PROFILE_ARCH}" = "sparc64-multilib" ]; then
			for CH in ${MULTILIB_CHOSTS}; do
				if [ "${CH}" = "${CHOST}" ]; then
					for x in `ls ${D}/usr/${CHOST}/bin/`; do
						[ ! -e "${D}/usr/bin/${CHOST}-${x}" ] && \
							dosym ../${CHOST}/bin/${x} /usr/bin/${CHOST}-${x}
					done
				else
					dodir /usr/${CH}/bin

					for x in `ls ${D}/usr/${CHOST}/bin/`; do
						dosym ../../${CHOST}/bin/${x} /usr/${CH}/bin/${x}
						[ ! -e "${D}/usr/bin/${CH}-${x}" ] && \
							dosym ../${CH}/bin/${x} /usr/bin/${CH}-${x}
					done
				fi
			done
		elif [ "${PROFILE_ARCH/64}" != "${PROFILE_ARCH}" ]; then
			dosym ${CHOST} /usr/${CHOST/-/64-}

			for x in `ls ${D}/usr/${CHOST}/bin/`
			do
				[ ! -e "${D}/usr/bin/${CHOST}-${x}" ] && \
					dosym ../${CHOST}/bin/${x} /usr/bin/${CHOST}-${x}
				dosym ../${CHOST}/bin/${x} /usr/bin/${CHOST/-/64-}-${x}
			done
		fi
	fi

	cd ${S}
	if ! use build
	then
		make DESTDIR=${D} install-info || die

		dodoc COPYING* README
		docinto bfd
		dodoc bfd/ChangeLog* bfd/COPYING bfd/README bfd/PORTING bfd/TODO
		docinto binutils
		dodoc binutils/ChangeLog binutils/NEWS binutils/README
		docinto gas
		dodoc gas/ChangeLog* gas/CONTRIBUTORS gas/COPYING gas/NEWS gas/README*
		docinto gprof
		dodoc gprof/ChangeLog* gprof/TEST gprof/TODO gprof/bbconv.pl
		docinto ld
		dodoc ld/ChangeLog* ld/README ld/NEWS ld/TODO
		docinto libiberty
		dodoc libiberty/ChangeLog* libiberty/COPYING.LIB libiberty/README
		docinto opcodes
		dodoc opcodes/ChangeLog*
		# Install pre-generated manpages .. currently we do not ...
	else
		rm -rf ${D}/usr/share/man
	fi

	use uclibc && rm -rf ${D}/usr/lib/ldscripts

	# remove shared libs' links (.so) to build all apps against the static versions
	use uclibc && rm -f ${D}/usr/lib/lib{bfd,opcodes}.so ${D}/usr/lib/lib*.la
}
