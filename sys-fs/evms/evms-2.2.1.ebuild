# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/evms/evms-2.2.1.ebuild,v 1.6 2004/02/25 20:12:42 iggy Exp $

IUSE="ncurses gtk"

inherit eutils

DESCRIPTION="Utilities for the IBM Enterprise Volume Management System"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://www.sourceforge.net/projects/evms"

KEYWORDS="x86 -amd64 -ppc -sparc -alpha -hppa -mips"
LICENSE="GPL-2"
SLOT="0"

#EVMS uses libuuid from e2fsprogs
DEPEND="virtual/glibc
	sys-fs/e2fsprogs
	gtk? ( =x11-libs/gtk+-1* )
	ncurses? ( sys-libs/ncurses )"

src_compile() {
	local excluded_interfaces=""
	use ncurses || excluded_interfaces="--disable-text-mode"
	use gtk || excluded_interfaces="${excluded_interfaces} --disable-gui"

	econf \
		--libdir=/lib \
		--sbindir=/sbin \
		--includedir=/usr/include \
		${excluded_interfaces} || die "Failed configure"
	emake || die "Failed emake"
}

src_install() {
	make DESTDIR=${D} install || die "Make install died"
	dodoc ChangeLog COPYING TERMINOLOGY PLUGIN.IDS INSTALL*

	# move static libraries to /usr/lib
	dodir /usr/lib
	mv -f ${D}/lib/*.a ${D}/usr/lib

	# Create linker scripts for dynamic libs in /lib, else gcc
	# links to the static ones in /usr/lib first.  Bug #4411.
	for x in ${D}/usr/lib/*.a
	do
		if [ -f ${x} ]
		then
			local lib="${x##*/}"
			gen_usr_ldscript ${lib/\.a/\.so}
		fi
	done

	# the gtk+ frontend should live in /usr/sbin
	if [ -n "`use gtk`" ]
	then
		dodir /usr/sbin
		mv -f ${D}/sbin/evmsgui ${D}/usr/sbin
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/evms2-init evms
}

pkg_postinst() {

	ewarn "Presently gentoo-sources-2.4.22 has basic support for evms2,"
	ewarn "but does NOT support some of the more advanced features."
}
