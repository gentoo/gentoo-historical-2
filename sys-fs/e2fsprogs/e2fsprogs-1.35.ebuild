# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/e2fsprogs/e2fsprogs-1.35.ebuild,v 1.16 2004/09/07 22:55:01 vapier Exp $

inherit eutils flag-o-matic gnuconfig

DESCRIPTION="Standard EXT2 and EXT3 filesystem utilities"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ~ia64 ~ppc64 s390"
IUSE="nls static"

DEPEND="virtual/libc
	nls? ( sys-devel/gettext )
	sys-apps/texinfo"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	# Fix a cosmetic error in mk_cmds's help output.
	cd ${S}; epatch ${FILESDIR}/e2fsprogs-1.32-mk_cmds-cosmetic.patch
	# Userpriv fix. Closes #27348
	chmod u+w po/*.po
	# Patch to make the configure and sed scripts more friendly to, 
	# for example, the Estonian locale
	epatch ${FILESDIR}/${PN}-sed-locale.patch

	gnuconfig_update
}

src_compile() {
	local myconf

	# building e2fsprogs on sparc results in silo breaking
	[ "${ARCH}" = "sparc" ] && filter-flags "-fstack-protector"

	use static \
		&& myconf="${myconf} --with-ldopts=-static" \
		|| myconf="${myconf} --enable-dynamic-e2fsck --enable-elf-shlibs"

	econf \
		`use_enable nls` \
		${myconf} || die

	# Parallel make sometimes fails
	emake -j1 || die
}

src_install() {
	einstall libdir=zapme || die
	#evil e2fsprogs makefile -- I'll get you!
	rm -rf ${D}/zapme

	make DESTDIR=${D} install-libs || die

	#There is .po file b0rkage with 1.33; commenting this out (drobbins, 21 Apr 2003)
	#if use nls; then
	#	make -C po DESTDIR=${D} install || die
	#fi

	dodoc ChangeLog README RELEASE-NOTES SHLIBS
	docinto e2fsck
	dodoc e2fsck/ChangeLog e2fsck/CHANGES

	dodir /lib /bin /sbin
	cd ${D}/usr/lib
	mv * ../../lib
	cd ${D}/lib
	mv *.a ../usr/lib
	local mylib=""
	local x=""
	#install ldscripts to fix bug #4411
	cd ${D}/usr/lib
	for x in *.a
	do
		[ ! -f ${x} ] && continue
		gen_usr_ldscript ${x/a}so
	done
	#normalize evil symlinks
	cd ${D}/lib
	for x in *
	do
		[ ! -L ${x} ] && continue
		mylib="`readlink ${x}`"
		mylib="`basename ${mylib}`"
		ln -sf ${mylib} ${x}
	done

	mv ${D}/usr/sbin/* ${D}/sbin
	cd ${D}/usr/bin
	mv lsattr chattr uuidgen ../../bin
	cd ${D}/sbin
	mv mklost+found ../usr/sbin
	#time to convert hard links/duplicates to symbolic links
	cd ${D}/sbin
	rm fsck.*
	ln -sf e2fsck fsck.ext2
	ln -sf e2fsck fsck.ext3
	rm mkfs.*
	ln -sf mke2fs mkfs.ext2
	ln -sf mke2fs mkfs.ext3

	# 03 Aug 2002 <raker@gentoo.org>
	# There are awk files that don't get installed when doing
	# a 'make install'.  They are the template files for
	# /bin/compile_et.

	cd ${S}/lib/et
	insinto /usr/share/et
	doins et_c.awk et_h.awk
	cd ${S}/lib/ss
	insinto /usr/share/ss
	doins ct_c.awk
}
