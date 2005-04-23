# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-6.3.ebuild,v 1.10 2005/04/23 04:48:57 vapier Exp $

inherit flag-o-matic eutils

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/"
SRC_URI="http://mirrors.rcn.net/pub/sourceware/gdb/releases/${P}.tar.bz2
	mirror://gentoo/gdb_init.txt.bz2"
#SRC_URI="${SRC_URI} mirror://gentoo/gdb-6.1-hppa-01.patch.bz2"

LICENSE="GPL-2 LGPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="nls test"

RDEPEND=">=sys-libs/ncurses-5.2-r2"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gdb-6.3-uclibc.patch
	epatch ${FILESDIR}/gdb-6.3-relative-paths.patch
	#epatch ${FILESDIR}/gdb-6.x-crash.patch
	epatch ${FILESDIR}/gdb-6.2.1-pass-libdir.patch
	epatch ${FILESDIR}/gdb-6.3-scanmem.patch

	cp ${WORKDIR}/gdb_init.txt ${S}/ || die

	strip-linguas -u bfd/po opcodes/po
}

src_compile() {
	replace-flags -O? -O2
	econf $(use_enable nls) || die
	make || die
}

src_install() {
	make \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		libdir="${D}"/nukeme includedir="${D}"/nukeme \
		install || die "install"
	# The includes and libs are in binutils already
	rm -r "${D}"/nukeme

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -r "${D}"/usr/share
		return 0
	fi

	dodoc README
	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
		gdb/NEWS gdb/ChangeLog* gdb/TODO
	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING
	docinto mmalloc
	dodoc mmalloc/MAINTAINERS mmalloc/ChangeLog mmalloc/TODO

	if use x86; then
		dodir /etc/skel/
		cp "${S}"/gdb_init.txt "${D}"/etc/skel/.gdbinit \
			|| die "install ${D}/etc/skel/.gdbinit"
	fi

	if ! has noinfo ${FEATURES} ; then
		make -C "${S}"/gdb/doc \
			infodir="${D}"/usr/share/info \
			install-info || die "install doc info"
		make -C "${S}"/bfd/doc \
			infodir="${D}"/usr/share/info \
			install-info || die "install bfd info"
	fi
}
