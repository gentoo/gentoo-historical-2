# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/evms/evms-1.0.0-r1.ebuild,v 1.2 2002/07/11 06:30:54 drobbins Exp $

# You need to have an evms-patched kernel source tree in /usr/src/linux
# to build this.  Either take care of that yourself or do these steps :
#
#   o get a vanilla 2.4.18 kernel and unpack it in /usr/src/linux
#   o ebuild evms-1.0.0-r1.ebuild clean unpack
#   o cd /usr/src/linux
#   o patch -p1 < /tmp/portage/evms-1.0.0-r1/work/evms-1.0.0/kernel/evms-1.0.0-linux-2.4.patch
#   o patch -p1 < /tmp/portage/evms-1.0.0-r1/work/evms-1.0.0/kernel/evms-linux-2.4.18-common-files.patch
#   o patch -p1 < /tmp/portage/evms-1.0.0-r1/work/evms-1.0.0/kernel/linux-2.4.18-VFS-lock.patch
#
# The third patch isn't totally required.  Now configure your kernel
# and select the evms features that you want.  If you plan on using
# an evms volume on your /boot partition then you'll need to use the
# included patch against lilo-22.2 in the same directory as above.
# Please see their homepage for further information and details.

DESCRIPTION="Utilities for the IBM Enterprise Volume Management System"
HOMEPAGE="http://www.sourceforge.net/projects/evms"

S=${WORKDIR}/${P}
SRC_URI="ftp://ftp.sourceforge.net/pub/sourceforge/${PN}/${P}.tar.gz"

DEPEND="virtual/glibc gtk? ( =x11-libs/gtk+-1* ) ncurses? ( sys-libs/ncurses )"

LICENSE="GPL"
SLOT="0"

pkg_setup() {
	if [ ! -f /usr/src/linux/include/linux/evms/evms.h ]
	then
		eerror "You dont appear to have an evms-patched kernel source"
		eerror "tree in /usr/src/linux. Please fix that and try again"
		return 1
	fi
}

src_compile() {
	local interfaces="CommandLine,LvmUtils,utilities"
	use ncurses && interfaces="ncurses,${interfaces}"
	use gtk && interfaces="evmsgui,${interfaces}"

	cd engine
	./configure \
		--prefix=/usr \
		--sbindir=/sbin \
		--with-plugins=all \
		--mandir=/usr/share/man \
		--with-evmslib_dir=/lib \
		--with-kernel=/usr/src/linux \
		--with-interfaces=${interfaces} \
		--host=${CHOST} || die "bad ./configure"

	emake || die "compile problem"
}

src_install() {
	make -C engine DESTDIR=${D} install || die
	dodoc CHANGES COPYING EVMS*.txt PLUGIN.IDS

	# no need for static libraries in /lib
	dodir /usr/lib
	mv ${D}/lib/*.a ${D}/usr/lib

	# make the non-existant symlinks :/  i bet they'll fix
	# this upstream in the near future...
	cd ${D}/lib
	rm -f libdlist.so libevms.so
	ln -sf libevms-1.0.0.so libevms.so.1
	ln -sf libevms.so.1 libevms.so
	ln -sf libdlist-1.0.so libdlist.so.1
	ln -sf libdlist.so.1 libdlist.so

	# the gtk+ frontend should live in /usr/sbin though..
	if [ -n "`use gtk`" ]
	then
		dodir /usr/sbin
		mv ${D}/sbin/evmsgui ${D}/usr/sbin
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/evms-init evms
}
