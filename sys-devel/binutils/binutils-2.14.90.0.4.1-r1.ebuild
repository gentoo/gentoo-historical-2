# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.14.90.0.4.1-r1.ebuild,v 1.9 2004/04/16 03:33:04 kumba Exp $

IUSE="nls bootstrap build"

# NOTE to Maintainer:  ChangeLog states that it no longer use perl to build
#                      the manpages, but seems this is incorrect ....

inherit eutils libtool flag-o-matic

# Generate borked binaries.  Bug #6730
filter-flags "-fomit-frame-pointer -fssa"

S="${WORKDIR}/${P}"
DESCRIPTION="Tools necessary to build programs"
SRC_URI="mirror://kernel/linux/devel/binutils/${P}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/${P}.tar.bz2"
HOMEPAGE="http://sources.redhat.com/binutils/"

SLOT="0"
LICENSE="GPL-2 | LGPL-2"
KEYWORDS="~amd64 -x86 -ppc -alpha -sparc mips -hppa "

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )
	|| ( dev-lang/perl
	     ( !build?     ( dev-lang/perl ) )
	     ( !bootstrap? ( dev-lang/perl ) )
	    )"
# This is a hairy one.  Basically depend on dev-lang/perl
# if "build" or "bootstrap" not in USE.


# filter CFLAGS=".. -O2 .." on arm
if [ "${ARCH}" = "arm" ]; then
	CFLAGS="$(echo "${CFLAGS}" | sed -e 's,-O[2-9] ,-O1 ,')"
fi

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.10-glibc21.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-sparc-nonpic.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-eh-frame-ro.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-ltconfig-multilib.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-cfi.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-pie.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-ppc-bigplt.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-pt-gnu-stack.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-gas-execstack.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-cfi2.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-pie2.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-ppc64-ctors.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-ppc64-prelink.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-cfi3.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-cfi4.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-gas-pred.patch
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.4-pni.patch
	epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.10-x86_64-testsuite.patch
	epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.10-x86_64-gotpcrel.patch
	epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.18-s390-file-loc.patch
	epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.18-testsuite-Wall-fixes.patch
	# There is a bug in binutils 2.14.* which causes a segfault in certain
	# circumstances when linking. This bug does not exist in binutils 2.11.*.
	#
	# More details on the bug can be found here:
	#  http://sources.redhat.com/ml/bug-binutils/2003-q3/msg00559.html
	#  http://sources.redhat.com/ml/bug-binutils/2003-q3/msg00735.html
	#
	# Bug #27492, thanks to Adam Chodorowski <adam@chodorowski.com> for
	# reporting.
	epatch ${FILESDIR}/2.14/${PN}-2.14.90.0.6-dont-crash-on-null-owner.patch

	use x86 &> /dev/null \
		&& epatch ${FILESDIR}/2.13/${PN}-2.13.90.0.20-array-sects-compat.patch

	# Fixes a MIPS issue in which the dynamic relocation table in OpenSSL libs
	# gets broken because the GOT entry count is too low
	if [ "${ARCH}" = "mips" ]; then
		epatch ${FILESDIR}/2.14/${PN}-mips-openssl-got-fix.patch
	fi

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
}

src_compile() {
	local myconf=

	use nls && \
		myconf="${myconf} --without-included-gettext" || \
		myconf="${myconf} --disable-nls"

	# Fix /usr/lib/libbfd.la
	elibtoolize --portage

	./configure --enable-shared \
		--enable-64-bit-bfd \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--host=${CHOST} \
		${myconf} || die

	make configure-bfd || die
	make headers -C bfd || die
	emake tooldir="${ROOT}/usr/bin" \
		all || die

	if [ -z "`use build`" ]
	then
		if [ -z "`use bootstrap`" ]
		then
			# Nuke the manpages to recreate them (only use this if we have perl)
			find . -name '*.1' -exec rm -f {} \; || :
		fi
		# Make the info pages (makeinfo included with gcc is used)
		make info || die
	fi
}

src_install() {

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
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

	if [ -n "${PROFILE_ARCH}" ] && \
	   [ "${PROFILE_ARCH/64}" != "${PROFILE_ARCH}" ]
	then
		dosym ${CHOST} /usr/${CHOST/-/64-}

		for x in `ls ${D}/usr/${CHOST}/bin/`
		do
			[ ! -e "${D}/usr/bin/${CHOST}-${x}" ] && \
				dosym ../${CHOST}/bin/${x} /usr/bin/${CHOST}-${x}
			dosym ../${CHOST}/bin/${x} /usr/bin/${CHOST/-/64-}-${x}
		done
	fi

	cd ${S}
	if [ -z "`use build`" ]
	then
		make prefix=${D}/usr \
			mandir=${D}/usr/share/man \
			infodir=${D}/usr/share/info \
			install-info || die

		dodoc COPYING* README
		docinto bfd
		dodoc bfd/ChangeLog* bfd/COPYING bfd/README bfd/PORTING bfd/TODO
		docinto binutils
		dodoc binutils/ChangeLog binutils/NEWS binutils/README
		docinto gas
		dodoc gas/ChangeLog* gas/CONTRIBUTORS gas/COPYING gas/NEWS gas/README*
		docinto gprof
		dodoc gprof/ChangeLog* gprof/TEST gprof/TODO
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
}
